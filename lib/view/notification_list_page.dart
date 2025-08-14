import 'package:flutter/material.dart';
import 'package:foodie_delivery/widgets/expandable_text.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../constants/app_colors.dart';
import '../provider/notification_provider.dart';

class NotificationListPage extends StatelessWidget {
  const NotificationListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.secondary,
        elevation: 3,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.primary),
        actions: [
          // Test button for debugging
          // IconButton(
          //   onPressed: () {
          //     final notificationProvider = Provider.of<NotificationProvider>(
          //       context,
          //       listen: false,
          //     );
          //     notificationProvider.addTestNotification();
          //     ScaffoldMessenger.of(context).showSnackBar(
          //       const SnackBar(
          //         content: Text('Test notification added'),
          //         backgroundColor: Colors.green,
          //       ),
          //     );
          //   },
          //   icon: const Icon(Icons.bug_report, color: Colors.white),
          //   tooltip: 'Add Test Notification',
          // ),
          Consumer<NotificationProvider>(
            builder: (context, notificationProvider, child) {
              return PopupMenuButton<String>(
                onSelected: (value) {
                  switch (value) {
                    case 'mark_all_read':
                      notificationProvider.markAllMessagesAsRead();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('All notifications marked as read'),
                          backgroundColor: Colors.green,
                        ),
                      );
                      break;
                    case 'clear_all':
                      _showClearAllDialog(context, notificationProvider);
                      break;
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'mark_all_read',
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor.withOpacity(0.12),
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(6),
                          child: const Icon(
                            Icons.mark_email_read,
                            color: AppColors.primaryColor,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Mark all as read',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            // Optional subtitle for extra description
                            // Text(
                            //   'Mark all notifications as read',
                            //   style: TextStyle(
                            //     fontSize: 12,
                            //     color: Colors.grey,
                            //   ),
                            // ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'clear_all',
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.15),
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(6),
                          child: const Icon(
                            Icons.delete_forever,
                            color: Colors.redAccent,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Clear all',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.redAccent,
                              ),
                            ),
                            // Optional subtitle for clarity
                            // Text(
                            //   'Delete all notifications',
                            //   style: TextStyle(
                            //     fontSize: 12,
                            //     color: Colors.grey,
                            //   ),
                            // ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
                icon: const Icon(
                  Icons.more_vert,
                  color: AppColors.primaryColor,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                // Optional: change color of menu background for better contrast
                color: Colors.white,
                elevation: 6,
              );
            },
          ),
        ],
      ),
      body: Consumer<NotificationProvider>(
        builder: (context, notificationProvider, child) {
          // Debug information
          debugPrint('NotificationProvider state:');
          debugPrint(
            '  - Messages count: ${notificationProvider.messages.length}',
          );
          debugPrint(
            '  - Is initialized: ${notificationProvider.isInitialized}',
          );
          debugPrint('  - FCM Token: ${notificationProvider.fcmToken}');

          if (notificationProvider.messages.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_none,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No notifications yet',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'You\'ll see your notifications here',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  // const SizedBox(height: 16),
                  // // Debug info
                  // Container(
                  //   padding: const EdgeInsets.all(16),
                  //   margin: const EdgeInsets.all(16),
                  //   decoration: BoxDecoration(
                  //     color: Colors.grey[100],
                  //     borderRadius: BorderRadius.circular(8),
                  //   ),
                  //   child: Column(
                  //     children: [
                  //       Text(
                  //         'Debug Info:',
                  //         style: TextStyle(
                  //           fontWeight: FontWeight.bold,
                  //           color: Colors.grey[700],
                  //         ),
                  //       ),
                  //       const SizedBox(height: 8),
                  //       Text(
                  //         'Provider initialized: ${notificationProvider.isInitialized}',
                  //         style: TextStyle(color: Colors.grey[600]),
                  //       ),
                  //       Text(
                  //         'FCM Token: ${notificationProvider.fcmToken?.substring(0, 20) ?? 'Not available'}...',
                  //         style: TextStyle(color: Colors.grey[600]),
                  //       ),
                  //                                Text(
                  //          'Messages count: ${notificationProvider.messages.length}',
                  //          style: TextStyle(color: Colors.grey[600]),
                  //        ),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: notificationProvider.messages.length,
            itemBuilder: (context, index) {
              final message = notificationProvider.messages[index];
              final isRead = message.data.containsKey('read') &&
                  message.data['read'] == true;

              return _buildNotificationTile(
                context,
                message,
                isRead,
                notificationProvider,
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildNotificationTile(
    BuildContext context,
    RemoteMessage message,
    bool isRead,
    NotificationProvider notificationProvider,
  ) {
    final notification = message.notification;
    String title = notification?.title ?? 'Notification';
    String body = notification?.body ?? 'No content';

    // Simple notification icon
    const IconData icon = Icons.notifications;
    const Color iconColor = AppColors.primaryColor;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: isRead ? 1 : 3,
      color: isRead
          ? AppColors.iconGray
          : AppColors.backgroundlightColor, // <--- Here!
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: iconColor.withOpacity(0.1),
          child: const Icon(icon, color: AppColors.textGray, size: 24),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
            color: isRead ? AppColors.textGray : AppColors.black,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text(
            //   body,
            //   style: TextStyle(
            //     color: isRead ? AppColors.primaryColor : AppColors.primaryColor,
            //   ),
            // ),
            ExpandableText(text: body),
            const SizedBox(height: 4),
            Text(
              _formatTimestamp(message.sentTime?.millisecondsSinceEpoch),
              style: const TextStyle(fontSize: 12, color: AppColors.textGray),
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            switch (value) {
              case 'mark_read':
                if (!isRead) {
                  notificationProvider.markMessageAsRead(
                    message.messageId ?? '',
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Marked as read'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
                break;
              case 'delete':
                notificationProvider.removeMessage(message.messageId ?? '');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Notification deleted'),
                    backgroundColor: Colors.orange,
                  ),
                );
                break;
            }
          },
          itemBuilder: (context) => [
            if (!isRead)
              PopupMenuItem(
                value: 'mark_read',
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withOpacity(0.12),
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(6),
                      child: const Icon(
                        Icons.mark_email_read,
                        color: AppColors.primaryColor,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Mark as read',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(6),
                    child: const Icon(
                      Icons.delete_forever,
                      color: Colors.redAccent,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Delete',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.redAccent,
                    ),
                  ),
                ],
              ),
            ),
          ],
          icon: const Icon(Icons.more_vert),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          // Optional: change color of menu background for better contrast
          color: Colors.white,
          elevation: 6,
        ),
        onTap: () {
          // Handle notification tap
          _handleNotificationTap(context, message);
        },
      ),
    );
  }

  void _handleNotificationTap(BuildContext context, RemoteMessage message) {
    // Simple notification tap - you can customize this based on your needs
    final data = message.data;
    final screen = data['screen'];

    print("screen$screen");

    // Navigate based on screen parameter if provided
    if (screen != null) {
      Navigator.pushNamed(context, '/$screen', arguments: data);
    }
  }

  String _formatTimestamp(int? timestamp) {
    if (timestamp == null) return 'Just now';

    final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }

  void _showClearAllDialog(
    BuildContext context,
    NotificationProvider notificationProvider,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Notifications'),
        content: const Text(
          'Are you sure you want to clear all notifications? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              notificationProvider.clearMessages();
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('All notifications cleared'),
                  backgroundColor: Colors.orange,
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }
}
