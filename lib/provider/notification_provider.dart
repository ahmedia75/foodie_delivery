import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/notification_service.dart';

class NotificationProvider extends ChangeNotifier {
  final NotificationService _notificationService = NotificationService();

  List<RemoteMessage> _messages = [];
  bool _isInitialized = false;
  String? _fcmToken;
  NotificationSettings? _notificationSettings;

  // Getters
  List<RemoteMessage> get messages => _messages;
  bool get isInitialized => _isInitialized;
  String? get fcmToken => _fcmToken;
  NotificationSettings? get notificationSettings => _notificationSettings;

  // Keys for persistent storage
  static const String _storageKey = 'stored_notifications';

  // Initialize the notification provider
  Future<void> initialize() async {
    if (_isInitialized) {
      debugPrint('NotificationProvider already initialized, skipping...');
      return;
    }

    try {
      await _notificationService.initialize();
      _isInitialized = true;

      // Get FCM token
      _fcmToken = await _notificationService.getFCMToken();

      // Get notification settings
      _notificationSettings =
          await _notificationService.getNotificationSettings();

      // Load saved notifications from local storage
      await _loadMessagesFromStorage();

      // Listen to notification streams
      _setupNotificationListeners();

      notifyListeners();
      debugPrint('NotificationProvider initialized successfully');
    } catch (e) {
      debugPrint('Error initializing NotificationProvider: $e');
    }
  }

  void _setupNotificationListeners() {
    debugPrint('Setting up notification listeners...');

    // Listen to foreground messages
    _notificationService.onMessageStream.listen((RemoteMessage message) {
      debugPrint('=== FOREGROUND MESSAGE RECEIVED ===');
      _addMessage(message);
      debugPrint('Received foreground message: ${message.messageId}');
    });

    // Listen to app opened from notification
    _notificationService.onMessageOpenedAppStream.listen((
      RemoteMessage message,
    ) {
      debugPrint('=== APP OPENED FROM NOTIFICATION ===');
      _addMessage(message);
      _handleNotificationTap(message);
      debugPrint('App opened from notification: ${message.messageId}');
    });

    // Listen to background messages
    _notificationService.onBackgroundMessageStream.listen((
      RemoteMessage? message,
    ) {
      if (message != null) {
        debugPrint('=== BACKGROUND MESSAGE RECEIVED ===');
        _addMessage(message);
        _handleNotificationTap(message);
        debugPrint(
          'App opened from background notification: ${message.messageId}',
        );
      }
    });

    debugPrint('Notification listeners set up successfully');
  }

  void _addMessage(RemoteMessage message) {
    // Check for duplicate messages
    final existingMessage = _messages
        .where(
          (m) =>
              m.messageId == message.messageId ||
              (m.notification?.title == message.notification?.title &&
                  m.notification?.body == message.notification?.body &&
                  (m.sentTime
                              ?.difference(message.sentTime ?? DateTime.now())
                              .abs()
                              .inMinutes ??
                          0) <
                      1),
        )
        .firstOrNull;

    if (existingMessage != null) {
      debugPrint('Duplicate message detected, skipping: ${message.messageId}');
      return;
    }

    debugPrint('Adding message to provider: ${message.messageId}');
    debugPrint('Message title: ${message.notification?.title}');
    debugPrint('Message body: ${message.notification?.body}');
    debugPrint('Message data: ${message.data}');

    _messages.insert(0, message);
    if (_messages.length > 50) {
      _messages = _messages.take(50).toList();
    }
    _saveMessagesToStorage(); // persist updated list
    notifyListeners();

    debugPrint('Total messages in provider: ${_messages.length}');
  }

  void _handleNotificationTap(RemoteMessage message) {
    final Map<String, dynamic> data = message.data;
    final String? type = data['type'];
    final String? orderId = data['order_id'];
    final String? screen = data['screen'];

    switch (type) {
      case 'order_update':
        if (orderId != null) {
          _navigateToOrderDetails(orderId);
        }
        break;
      case 'promotion':
        _navigateToPromotions();
        break;
      default:
        if (screen != null) {
          _navigateToScreen(screen, data);
        }
        break;
    }
  }

  void _navigateToOrderDetails(String orderId) {
    debugPrint('Navigate to order details: $orderId');
  }

  void _navigateToPromotions() {
    debugPrint('Navigate to promotions');
  }

  void _navigateToScreen(String screen, Map<String, dynamic> data) {
    debugPrint('Navigate to screen: $screen with data: $data');
  }

  // Save messages list to SharedPreferences as JSON strings
  Future<void> _saveMessagesToStorage() async {
    final prefs = await SharedPreferences.getInstance();

    final List<String> serializedMessages = _messages.map((msg) {
      return jsonEncode(_remoteMessageToMap(msg));
    }).toList();

    await prefs.setStringList(_storageKey, serializedMessages);
    debugPrint(
      'Saved ${serializedMessages.length} notifications to local storage',
    );
  }

  // Load messages list from SharedPreferences
  Future<void> _loadMessagesFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final storedMessages = prefs.getStringList(_storageKey) ?? [];

    _messages = storedMessages.map((str) {
      final Map<String, dynamic> map = jsonDecode(str);
      return _mapToRemoteMessage(map);
    }).toList();

    debugPrint('Loaded ${_messages.length} notifications from local storage');
    notifyListeners();
  }

  Map<String, dynamic> _remoteMessageToMap(RemoteMessage message) {
    return {
      'messageId': message.messageId,
      'title': message.notification?.title,
      'body': message.notification?.body,
      'data': message.data,
      'sentTime': message.sentTime?.millisecondsSinceEpoch,
    };
  }

  RemoteMessage _mapToRemoteMessage(Map<String, dynamic> map) {
    return RemoteMessage(
      messageId: map['messageId'],
      notification: RemoteNotification(title: map['title'], body: map['body']),
      data: Map<String, dynamic>.from(map['data']),
      sentTime: map['sentTime'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['sentTime'])
          : null,
    );
  }

  // Clear messages list (and persist)
  void clearMessages() {
    debugPrint('Clearing all messages from provider');
    _messages.clear();
    _saveMessagesToStorage();
    notifyListeners();
  }

  // Remove specific message (and persist)
  void removeMessage(String messageId) {
    _messages.removeWhere((message) => message.messageId == messageId);
    _saveMessagesToStorage();
    notifyListeners();
  }

  // Get unread message count
  int get unreadMessageCount {
    return _messages
        .where((message) => !message.data.containsKey('read'))
        .length;
  }

  // Mark message as read (remove for now)
  // void markMessageAsRead(String messageId) {
  //   removeMessage(messageId);
  // }

  void markMessageAsRead(String messageId) {
    final index = _messages.indexWhere((msg) => msg.messageId == messageId);
    if (index != -1) {
      final oldMessage = _messages[index];
      final updatedData = Map<String, dynamic>.from(oldMessage.data);
      updatedData['read'] = true;

      final updatedMessage = RemoteMessage(
        messageId: oldMessage.messageId,
        data: updatedData,
        notification: oldMessage.notification,
        sentTime: oldMessage.sentTime,
        from: oldMessage.from,
        collapseKey: oldMessage.collapseKey,
        category: oldMessage.category,
        messageType: oldMessage.messageType,
        mutableContent: oldMessage.mutableContent,
      );

      _messages[index] = updatedMessage;
      _saveMessagesToStorage(); // If you use persistence
      notifyListeners();
    }
  }

  // Mark all messages as read (clear all)
  // void markAllMessagesAsRead() {
  //   clearMessages();
  // }

  void markAllMessagesAsRead() {
    _messages = _messages.map((oldMessage) {
      final updatedData = Map<String, dynamic>.from(oldMessage.data);
      updatedData['read'] = true;

      return RemoteMessage(
        messageId: oldMessage.messageId,
        data: updatedData,
        notification: oldMessage.notification,
        sentTime: oldMessage.sentTime,
        from: oldMessage.from,
        collapseKey: oldMessage.collapseKey,
        category: oldMessage.category,
        messageType: oldMessage.messageType,
        mutableContent: oldMessage.mutableContent,
      );
    }).toList();

    _saveMessagesToStorage(); // Persist changes
    notifyListeners();
  }

  // The rest of the methods are unchanged...

  // Dispose
  @override
  void dispose() {
    _notificationService.dispose();
    super.dispose();
  }
}
