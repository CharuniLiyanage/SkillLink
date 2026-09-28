import 'package:flutter/material.dart';

import '../../services/api_service.dart';
import '../../utils/app_colors.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({
    super.key,
  });

  @override
  State<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState
    extends State<NotificationsScreen> {
  List<dynamic> notifications = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadNotifications();
  }

  Future<void> loadNotifications() async {
    final result =
        await ApiService.getNotifications();

    if (!mounted) return;

    setState(() {
      notifications = result;
      isLoading = false;
    });
  }

  Future<void> markAsRead(
    int notificationId,
  ) async {
    final success =
        await ApiService.markNotificationAsRead(
      notificationId,
    );

    if (!mounted) return;

    if (success) {
      await loadNotifications();
    }
  }

  String formatDateTime(String value) {
    try {
      final dateTime =
          DateTime.parse(value).toLocal();

      final hour = dateTime.hour;

      final minute =
          dateTime.minute.toString().padLeft(2, '0');

      final period =
          hour >= 12 ? 'PM' : 'AM';

      final displayHour =
          hour == 0
              ? 12
              : hour > 12
                  ? hour - 12
                  : hour;

      return '${dateTime.day}/'
          '${dateTime.month}/'
          '${dateTime.year} '
          '$displayHour:$minute $period';
    } catch (e) {
      return value;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notifications',
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : notifications.isEmpty
              ? RefreshIndicator(
                  onRefresh: loadNotifications,
                  child: ListView(
                    physics:
                        const AlwaysScrollableScrollPhysics(),
                    children: const [
                      SizedBox(height: 180),
                      Icon(
                        Icons
                            .notifications_none_rounded,
                        size: 60,
                        color:
                            AppColors.textSecondary,
                      ),
                      SizedBox(height: 16),
                      Center(
                        child: Text(
                          'No notifications yet.',
                          style: TextStyle(
                            fontSize: 16,
                            color:
                                AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: loadNotifications,
                  child: ListView.separated(
                    padding:
                        const EdgeInsets.all(16),
                    itemCount:
                        notifications.length,
                    separatorBuilder:
                        (_, _) =>
                            const SizedBox(
                      height: 10,
                    ),
                    itemBuilder:
                        (context, index) {
                      final notification =
                          notifications[index];

                      final id =
                          int.tryParse(
                        notification['id']
                            .toString(),
                      );

                      final title =
                          notification['title']
                                  ?.toString() ??
                              'Notification';

                      final message =
                          notification['message']
                                  ?.toString() ??
                              '';

                      final isRead =
                          notification['isRead'] ==
                              true;

                      final createdAt =
                          notification['createdAt']
                                  ?.toString() ??
                              '';

                      return Card(
                        child: InkWell(
                          borderRadius:
                              BorderRadius.circular(
                            12,
                          ),
                          onTap: () {
                            if (!isRead &&
                                id != null) {
                              markAsRead(id);
                            }
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.all(
                              16,
                            ),
                            child: Row(
                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,
                              children: [
                                Container(
                                  width: 46,
                                  height: 46,
                                  decoration:
                                      BoxDecoration(
                                    color: AppColors
                                        .primary
                                        .withValues(
                                      alpha: 0.1,
                                    ),
                                    shape:
                                        BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons
                                        .notifications_rounded,
                                    color: AppColors
                                        .primary,
                                  ),
                                ),
                                const SizedBox(
                                  width: 12,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment
                                            .start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              title,
                                              style:
                                                  TextStyle(
                                                fontSize:
                                                    16,
                                                fontWeight:
                                                    isRead
                                                        ? FontWeight.w600
                                                        : FontWeight.w800,
                                                color: AppColors
                                                    .textPrimary,
                                              ),
                                            ),
                                          ),
                                          if (!isRead)
                                            Container(
                                              width: 9,
                                              height: 9,
                                              decoration:
                                                  const BoxDecoration(
                                                color: AppColors
                                                    .secondary,
                                                shape: BoxShape
                                                    .circle,
                                              ),
                                            ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 6,
                                      ),
                                      Text(
                                        message,
                                        style:
                                            const TextStyle(
                                          fontSize: 14,
                                          color: AppColors
                                              .textSecondary,
                                          height: 1.35,
                                        ),
                                      ),
                                      if (createdAt
                                          .isNotEmpty) ...[
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Text(
                                          formatDateTime(
                                            createdAt,
                                          ),
                                          style:
                                              const TextStyle(
                                            fontSize:
                                                11,
                                            color: AppColors
                                                .textSecondary,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}