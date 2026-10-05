import 'package:flutter/material.dart';

import '../../widgets/app_header.dart';
import '../../widgets/app_sidebar.dart';

import '../auth/login_page.dart';

import 'admin_dashboard_page.dart';
import 'admin_profile_page.dart';
import 'apartment_management_page.dart';
import 'feedback_page.dart';
import 'maintenance_page.dart';
import 'payment_page.dart';
import 'service_management_page.dart';
import 'violation_page.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({
    super.key,
  });

  @override
  State<AdminHome> createState() =>
      _AdminHomeState();
}

class _AdminHomeState
    extends State<AdminHome> {
  int selectedIndex = 0;

  final items = const [
    AppNavItem(
      title: 'Tổng quan',
      icon: Icons.grid_view_rounded,
    ),
    AppNavItem(
      title: 'Quản lý căn hộ',
      icon: Icons.apartment_outlined,
    ),
    AppNavItem(
      title: 'Quản lý dịch vụ',
      icon:
          Icons.calendar_month_outlined,
    ),
    AppNavItem(
      title: 'Thanh toán phí dịch vụ',
      icon: Icons.credit_card_outlined,
    ),
    AppNavItem(
      title: 'Xử lý vi phạm',
      icon:
          Icons.shield_outlined,
    ),
    AppNavItem(
      title:
          'Tiếp nhận và phản hồi thông tin',
      icon:
          Icons.forum_outlined,
    ),
    AppNavItem(
      title: 'Bảo trì và sửa chữa',
      icon: Icons.build_outlined,
    ),
    AppNavItem(
      title: 'Hồ sơ cá nhân',
      icon:
          Icons.account_circle_outlined,
    ),
  ];

  final pages = const [
    AdminDashboardPage(),
    ApartmentManagementPage(),
    ServiceManagementPage(),
    PaymentPage(),
    ViolationPage(),
    FeedbackPage(),
    MaintenancePage(),
    AdminProfilePage(),
  ];

  void logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) =>
            const LoginPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width =
        MediaQuery.of(context).size.width;

    if (width < 850) {
      return Scaffold(
        appBar: AppBar(
          title:
              Text(items[selectedIndex].title),
        ),
        drawer: Drawer(
          child: SafeArea(
            child: ListView(
              children: [
                const ListTile(
                  leading:
                      Icon(Icons.apartment),
                  title: Text(
                    'BLUEHOME',
                    style: TextStyle(
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),
                ...List.generate(
                  items.length,
                  (index) => ListTile(
                    selected:
                        selectedIndex ==
                            index,
                    leading: Icon(
                      items[index].icon,
                    ),
                    title: Text(
                      items[index].title,
                    ),
                    onTap: () {
                      setState(() {
                        selectedIndex =
                            index;
                      });

                      Navigator.pop(
                        context,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        body: pages[selectedIndex],
      );
    }

    return Scaffold(
      body: Row(
        children: [
          AppSidebar(
            items: items,
            selectedIndex:
                selectedIndex,
            onSelected: (index) {
              setState(() {
                selectedIndex = index;
              });
            },
            onLogout: logout,
          ),

          Expanded(
            child: Column(
              children: [
                const AppHeader(),

                Expanded(
                  child:
                      pages[selectedIndex],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}