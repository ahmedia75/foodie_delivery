import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../provider/notification_provider.dart';

class NotificationBadge extends StatelessWidget {
  final VoidCallback? onTap;
  final double size;
  final Color? backgroundColor;
  final Color? textColor;

  const NotificationBadge({
    super.key,
    this.onTap,
    this.size = 18.0,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationProvider>(
      builder: (context, notificationProvider, child) {
        final unreadCount = notificationProvider.unreadMessageCount;

        if (unreadCount == 0) {
          return IconButton(
            onPressed: onTap ??
                () {
                  Navigator.pushNamed(context, '/notifications');
                },
            icon: const Icon(
              Icons.notifications_outlined,
              color: AppColors.black,
            ),
          );
        }

        return Stack(
          children: [
            IconButton(
              onPressed: onTap ??
                  () {
                    Navigator.pushNamed(context, '/notifications');
                  },
              icon: const Icon(
                Icons.notifications_outlined,
                color: AppColors.textGray,
                size: 28,
              ),
            ),
            Positioned(
              right: 8,
              top: 8,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: backgroundColor ?? AppColors.statusRejected,
                  borderRadius: BorderRadius.circular(10),
                ),
                constraints: BoxConstraints(minWidth: size, minHeight: size),
                child: Text(
                  unreadCount > 99 ? '99+' : unreadCount.toString(),
                  style: TextStyle(
                    color: textColor ?? AppColors.primaryColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
