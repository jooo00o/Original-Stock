import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:original_stock/core/app_theme.dart';
import 'package:original_stock/widgets/circular_icon_button.dart';

class NotificationItem {
  final String title;
  final String message;
  final String time;
  final IconData icon;
  final bool isUnread;

  const NotificationItem({
    required this.title,
    required this.message,
    required this.time,
    required this.icon,
    this.isUnread = false,
  });
}

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final List<NotificationItem> _notifications = [
    const NotificationItem(
      title: "Order shipped",
      message: "Your order #OS-10293 has been shipped via express courier.",
      time: "2h ago",
      icon: Icons.local_shipping_outlined,
      isUnread: true,
    ),
    const NotificationItem(
      title: "Super Sale is Live",
      message: "Get up to 50% off on winter tailoring & seasonal jackets.",
      time: "5h ago",
      icon: Icons.local_offer_outlined,
      isUnread: true,
    ),
    const NotificationItem(
      title: "New collection drop",
      message: "The Autumn Tailoring drop is live now. Discover curated pieces.",
      time: "1d ago",
      icon: Icons.auto_awesome_outlined,
      isUnread: false,
    ),
    const NotificationItem(
      title: "Order delivered",
      message: "Order #OS-10188 has been successfully delivered. Enjoy your wear!",
      time: "3d ago",
      icon: Icons.check_circle_outline_rounded,
      isUnread: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top Navigation Row
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
              child: Row(
                children: [
                  CircularIconButton(
                    iconData: Icons.arrow_back_ios_new_rounded,
                    onTap: () => Navigator.pop(context),
                  ),
                  const Spacer(),
                  Text(
                    'Notifications',
                    style: AppText.titleMedium(color: AppColors.text),
                  ),
                  const Spacer(),
                  SizedBox(width: 44.r),
                ],
              ),
            ),
            Gap(8.h),

            // Notifications List
            Expanded(
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                itemCount: _notifications.length,
                separatorBuilder: (context, index) => Gap(12.h),
                itemBuilder: (context, index) {
                  final notif = _notifications[index];

                  return Container(
                    padding: EdgeInsets.all(16.r),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppRadius.card),
                      border: Border.all(
                        color: notif.isUnread
                            ? AppColors.primaryLight
                            : AppColors.hairline,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Per-type Icon in circular 44 with soft grey fill
                        CircularIconButton(
                          size: 44.r,
                          backgroundColor: AppColors.white,
                          iconData: notif.icon,
                          iconColor: AppColors.primary,
                          iconSize: 22.r,
                        ),
                        Gap(14.w),

                        // Notification Details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      notif.title,
                                      style: TextStyle(
                                        fontFamily: AppText.fontFamily,
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.text,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    notif.time,
                                    style: AppText.caption(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  // Unread dot in purple
                                  if (notif.isUnread) ...[
                                    Gap(8.w),
                                    Container(
                                      height: 8.r,
                                      width: 8.r,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              Gap(4.h),
                              Text(
                                notif.message,
                                style: AppText.bodySmall(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
