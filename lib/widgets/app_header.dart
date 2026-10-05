import 'package:flutter/material.dart';

import '../core/app_theme.dart';
import '../data/app_repository.dart';

class AppHeader extends StatelessWidget {
  final String userName;
  final String role;

  const AppHeader({
    super.key,
    this.userName = 'Minh Anh',
    this.role = 'Ban quản lý',
  });

  void showNotifications(
    BuildContext context,
  ) {
    final repo = AppRepository.instance;

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text(
            'Thông báo',
          ),
          content: SizedBox(
            width: 520,
            height: 460,
            child: AnimatedBuilder(
              animation: repo,
              builder: (_, __) {
                return ListView.separated(
                  itemCount:
                      repo.notifications.length,
                  separatorBuilder: (_, __) =>
                      const Divider(),
                  itemBuilder: (_, index) {
                    final item =
                        repo.notifications[index];

                    return ListTile(
                      onTap: () {
                        repo.markNotificationRead(
                          item.id,
                        );
                      },
                      leading: CircleAvatar(
                        backgroundColor:
                            AppColors.primaryLight,
                        child: const Icon(
                          Icons
                              .notifications_none,
                          color:
                              AppColors.primary,
                        ),
                      ),
                      title:
                          Text(item.title),
                      subtitle:
                          Text(item.message),
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final repo = AppRepository.instance;

    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(
        horizontal: 28,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: AppColors.border,
          ),
        ),
      ),
      child: Row(
        children: [
          const Spacer(),

          AnimatedBuilder(
            animation: repo,
            builder: (_, __) {
              return Badge(
                isLabelVisible:
                    repo.unreadNotifications > 0,
                label: Text(
                  '${repo.unreadNotifications}',
                ),
                child: IconButton(
                  onPressed: () {
                    showNotifications(context);
                  },
                  icon: const Icon(
                    Icons
                        .notifications_none_rounded,
                  ),
                ),
              );
            },
          ),

          const SizedBox(width: 16),

          const CircleAvatar(
            backgroundColor:
                AppColors.primaryLight,
            child: Icon(
              Icons.person,
              color: AppColors.primary,
            ),
          ),

          const SizedBox(width: 10),

          Column(
            mainAxisAlignment:
                MainAxisAlignment.center,
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: const TextStyle(
                  fontWeight:
                      FontWeight.w600,
                ),
              ),
              Text(
                role,
                style: const TextStyle(
                  color:
                      AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}