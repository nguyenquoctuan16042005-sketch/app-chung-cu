import 'package:flutter/material.dart';

import '../../core/app_theme.dart';
import '../../data/app_repository.dart';

import '../auth/login_page.dart';

import 'notification_page.dart';
import 'resident_dashboard_page.dart';
import 'resident_feedback_page.dart';
import 'resident_payment_page.dart';
import 'resident_profile_page.dart';
import 'resident_service_page.dart';

class ResidentHome extends StatefulWidget {
  const ResidentHome({
    super.key,
  });

  @override
  State<ResidentHome> createState() => _ResidentHomeState();
}

class _ResidentHomeState extends State<ResidentHome> {
  int selectedIndex = 0;

  final titles = const [
    'Trang chủ',
    'Phí dịch vụ',
    'Dịch vụ',
    'Phản ánh',
  ];

  void logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginPage(),
      ),
    );
  }

  void showNotifications() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const NotificationPage(),
      ),
    );
  }

  void showProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ResidentProfilePage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final repo = AppRepository.instance;
    final width = MediaQuery.of(context).size.width;
    final mobile = width < 850;

    final pages = [
      ResidentDashboardPage(
        onNavigateTab: (idx) {
          setState(() {
            selectedIndex = idx;
          });
        },
      ),
      const ResidentPaymentPage(),
      const ResidentServicePage(),
      const ResidentFeedbackPage(),
    ];

    if (mobile) {
      return Scaffold(
        appBar: AppBar(
          toolbarHeight: 65,
          title: Text(
            titles[selectedIndex],
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            _notificationButton(),
            GestureDetector(
              onTap: showProfile,
              child: const CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.primaryLight,
                child: Icon(
                  Icons.person,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.logout,
                color: Color(0xFFFF8A8A),
              ),
              tooltip: 'Đăng xuất',
              onPressed: logout,
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: pages[selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: (index) {
            setState(() {
              selectedIndex = index;
            });
          },
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textSecondary,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Trang chủ',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.credit_card_outlined),
              activeIcon: Icon(Icons.credit_card),
              label: 'Phí dịch vụ',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month_outlined),
              activeIcon: Icon(Icons.calendar_month),
              label: 'Dịch vụ',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.forum_outlined),
              activeIcon: Icon(Icons.forum),
              label: 'Phản ánh',
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 78,
            padding: const EdgeInsets.symmetric(
              horizontal: 32,
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
                // Logo
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: const Icon(
                    Icons.apartment_rounded,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
                const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'BLUEHOME',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'CƯ DÂN',
                      style: TextStyle(
                        fontSize: 10,
                        color: AppColors.textSecondary,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const Spacer(),

                // Navigation Tabs
                ...List.generate(
                  titles.length,
                  (index) {
                    final selected = index == selectedIndex;

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () {
                          setState(() {
                            selectedIndex = index;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: selected
                                ? AppColors.primaryLight
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            titles[index],
                            style: TextStyle(
                              color: selected
                                  ? AppColors.primary
                                  : AppColors.textSecondary,
                              fontWeight: selected
                                  ? FontWeight.bold
                                  : FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),

                const Spacer(),

                // Notification
                _notificationButton(),

                const SizedBox(width: 12),

                // Resident Profile Info
                AnimatedBuilder(
                  animation: repo,
                  builder: (_, __) {
                    final apt = repo.getApartmentById(
                      repo.currentResidentApartmentId,
                    );
                    final name = apt?.ownerName ?? 'Thu Hà';
                    final code = apt?.displayCode ?? 'A-05-01';

                    return InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: showProfile,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 6,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '$name · $code',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(width: 10),
                            const CircleAvatar(
                              radius: 17,
                              backgroundColor: AppColors.primaryLight,
                              child: Icon(
                                Icons.person,
                                color: AppColors.primary,
                                size: 19,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(width: 8),

                // Logout
                IconButton(
                  icon: const Icon(
                    Icons.logout_rounded,
                    color: Color(0xFFFF8A8A),
                    size: 21,
                  ),
                  tooltip: 'Đăng xuất',
                  onPressed: logout,
                ),
              ],
            ),
          ),

          Expanded(
            child: pages[selectedIndex],
          ),
        ],
      ),
    );
  }

  Widget _notificationButton() {
    final repo = AppRepository.instance;

    return AnimatedBuilder(
      animation: repo,
      builder: (_, __) {
        return Badge(
          isLabelVisible: repo.unreadNotifications > 0,
          label: Text(
            '${repo.unreadNotifications}',
          ),
          child: IconButton(
            onPressed: showNotifications,
            icon: const Icon(
              Icons.notifications_none_rounded,
            ),
          ),
        );
      },
    );
  }
}