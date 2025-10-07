import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  // Notification channel for Android
  static const String _defaultChannelId = 'mobile';

  // Stream controllers for notification events
  final StreamController<RemoteMessage> _onMessageStreamController =
      StreamController<RemoteMessage>.broadcast();
  final StreamController<RemoteMessage> _onMessageOpenedAppStreamController =
      StreamController<RemoteMessage>.broadcast();
  final StreamController<RemoteMessage?> _onBackgroundMessageStreamController =
      StreamController<RemoteMessage?>.broadcast();

  // Getters for streams
  Stream<RemoteMessage> get onMessageStream =>
      _onMessageStreamController.stream;
  Stream<RemoteMessage> get onMessageOpenedAppStream =>
      _onMessageOpenedAppStreamController.stream;
  Stream<RemoteMessage?> get onBackgroundMessageStream =>
      _onBackgroundMessageStreamController.stream;

  Future<void> initialize() async {
    try {
      // Initialize timezone
      tz.initializeTimeZones();

      // Initialize Firebase Messaging
      await _initializeFirebaseMessaging();

      // Initialize Local Notifications
      await _initializeLocalNotifications();

      // Request permissions
      await _requestPermissions();

      // Get FCM token
      await _getFCMToken();

      // Set up message handlers
      _setupMessageHandlers();

      debugPrint('NotificationService initialized successfully');
    } catch (e) {
      debugPrint('Error initializing NotificationService: $e');
    }
  }

  Future<void> _initializeFirebaseMessaging() async {
    // Set background message handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Got a message whilst in the foreground!');
      debugPrint('Message data: ${message.data}');

      if (message.notification != null) {
        debugPrint(
          'Message also contained a notification: ${message.notification}',
        );
        _showLocalNotification(message);
      }

      _onMessageStreamController.add(message);
    });

    // Handle when app is opened from notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('A new onMessageOpenedApp event was published!');
      _onMessageOpenedAppStreamController.add(message);
    });

    // Check if app was opened from notification
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _onBackgroundMessageStreamController.add(initialMessage);
    }
  }

  Future<void> _initializeLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Create notification channels for Android
    await _createNotificationChannels();
  }

  Future<void> _createNotificationChannels() async {
    if (Platform.isAndroid) {
      // Single default channel for all notifications
      const AndroidNotificationChannel defaultChannel =
          AndroidNotificationChannel(
        _defaultChannelId,
        'Notifications',
        description: 'All app notifications',
        importance: Importance.high,
        playSound: true,
        enableVibration: true,
      );

      await _localNotifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(defaultChannel);
    }
  }

  Future<void> _requestPermissions() async {
    // Request FCM permissions
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    debugPrint('User granted permission: ${settings.authorizationStatus}');

    // Request local notification permissions for iOS
    if (Platform.isIOS) {
      await _localNotifications
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    }
  }

  Future<void> _getFCMToken() async {
    try {
      String? token = await _firebaseMessaging.getToken();
      if (token != null) {
        debugPrint('FCM Token: $token');

        // Save token to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('fcm_token', token);

        await _sendTokenToServer(token);
      }
    } catch (e) {
      debugPrint('Error getting FCM token: $e');
    }

    // Listen for token refresh
    _firebaseMessaging.onTokenRefresh.listen((String token) async {
      debugPrint('FCM Token refreshed: $token');

      // Save new token to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('fcm_token', token);

      await _sendTokenToServer(token);
    });
  }

  Future<void> _sendTokenToServer(String token) async {
    try {
      // Example:
      // await ApiService.updateFCMToken(token);
      debugPrint('Token sent to server: $token');
    } catch (e) {
      debugPrint('Error sending token to server: $e');
    }
  }

  void _setupMessageHandlers() {
    // Handle all notifications the same way
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showLocalNotification(message);
    });
  }

  Future<void> _showLocalNotification(
    RemoteMessage message, {
    String channelId = _defaultChannelId,
    AndroidNotificationCategory category = AndroidNotificationCategory.message,
  }) async {
    final RemoteNotification? notification = message.notification;
    final AndroidNotification? android = message.notification?.android;

    if (notification != null) {
      await _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channelId,
            'Notifications',
            channelDescription: 'Notification channel',
            icon: android?.smallIcon ?? '@drawable/ic_launcher',
            color: const Color(0xFF2196F3),
            category: category,
            priority: Priority.high,
            importance: Importance.high,
            playSound: true,
            enableVibration: true,
            enableLights: true,
            channelShowBadge: true,
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: json.encode(message.data),
      );
    }
  }

  void _onNotificationTapped(NotificationResponse response) {
    if (response.payload != null) {
      final Map<String, dynamic> data = json.decode(response.payload!);
      debugPrint('Notification tapped with payload: $data');

      // Handle notification tap based on data
      _handleNotificationTap(data);
    }
  }

  void _handleNotificationTap(Map<String, dynamic> data) {
    final String? screen = data['screen'];

    // Navigate based on screen parameter if provided
    if (screen != null) {
      _navigateToScreen(screen, data);
    }
  }

  void _navigateToScreen(String screen, Map<String, dynamic> data) {
    debugPrint('Navigate to screen: $screen with data: $data');
  }

  // Method to show local notification programmatically
  Future<void> showLocalNotification({
    required String title,
    required String body,
    String? payload,
    String channelId = _defaultChannelId,
    AndroidNotificationCategory category = AndroidNotificationCategory.message,
  }) async {
    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channelId,
          'Notifications',
          channelDescription: 'Notification channel',
          icon: '@drawable/ic_launcher',
          color: const Color(0xFF2196F3),
          category: category,
          priority: Priority.high,
          importance: Importance.high,
          playSound: true,
          enableVibration: true,
          enableLights: true,
          channelShowBadge: true,
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: payload,
    );
  }

  // Method to schedule local notification
  Future<void> scheduleLocalNotification({
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
    String channelId = _defaultChannelId,
  }) async {
    await _localNotifications.zonedSchedule(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      NotificationDetails(
        android: AndroidNotificationDetails(
          channelId,
          'Notifications',
          channelDescription: 'Notification channel',
          icon: '@drawable/ic_launcher',
          color: const Color(0xFF2196F3),
          priority: Priority.high,
          importance: Importance.high,
          playSound: true,
          enableVibration: true,
          enableLights: true,
          channelShowBadge: true,
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: payload,
    );
  }

  // Method to cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _localNotifications.cancelAll();
  }

  // Method to cancel specific notification
  Future<void> cancelNotification(int id) async {
    await _localNotifications.cancel(id);
  }

  // Method to get FCM token
  Future<String?> getFCMToken() async {
    return await _firebaseMessaging.getToken();
  }

  // Method to subscribe to topic
  Future<void> subscribeToTopic(String topic) async {
    await _firebaseMessaging.subscribeToTopic(topic);
    debugPrint('Subscribed to topic: $topic');
  }

  // Method to unsubscribe from topic
  Future<void> unsubscribeFromTopic(String topic) async {
    await _firebaseMessaging.unsubscribeFromTopic(topic);
    debugPrint('Unsubscribed from topic: $topic');
  }

  // Method to get notification settings
  Future<NotificationSettings> getNotificationSettings() async {
    return await _firebaseMessaging.getNotificationSettings();
  }

  // Dispose method
  void dispose() {
    _onMessageStreamController.close();
    _onMessageOpenedAppStreamController.close();
    _onBackgroundMessageStreamController.close();
  }
}

// Background message handler (must be top-level function)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Ensure Firebase is initialized
  // await Firebase.initializeApp();

  debugPrint('Handling a background message: ${message.messageId}');
  debugPrint('Message data: ${message.data}');

  if (message.notification != null) {
    debugPrint(
      'Message also contained a notification: ${message.notification}',
    );
  }
}
