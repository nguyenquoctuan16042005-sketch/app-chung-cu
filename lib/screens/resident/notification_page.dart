import 'package:flutter/material.dart';

import '../../core/app_theme.dart';
import '../../data/app_repository.dart';
import '../../widgets/section_card.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final repo = AppRepository.instance;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông báo'),
        actions: [
          TextButton(
            onPressed: () {
              repo.markAllNotificationsRead();
            },
            child: const Text('Đánh dấu tất cả đã đọc'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: AnimatedBuilder(
        animation: repo,
        builder: (_, __) {
          return ListView(
            padding: const EdgeInsets.all(26),
            children: [
              if (repo.notifications.isEmpty)
                const SectionCard(
                  child: Center(
                    child: Text(
                      'Chưa có thông báo nào',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),

              ...repo.notifications.map(
                (item) => Padding(
                  padding: const EdgeInsets.only(
                    bottom: 12,
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () {
                      repo.markNotificationRead(
                        item.id,
                      );
                    },
                    child: SectionCard(
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: item.isRead
                                ? Colors.grey.shade100
                                : AppColors.primaryLight,
                            child: Icon(
                              Icons.notifications_none,
                              color: item.isRead
                                  ? Colors.grey
                                  : AppColors.primary,
                            ),
                          ),

                          const SizedBox(
                            width: 14,
                          ),

                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.title,
                                  style: TextStyle(
                                    fontWeight: item.isRead
                                        ? FontWeight.normal
                                        : FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  item.message,
                                  style: const TextStyle(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          if (!item.isRead)
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}