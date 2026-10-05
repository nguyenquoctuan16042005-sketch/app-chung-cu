import 'package:flutter/material.dart';

import '../../widgets/stat_card.dart';
import '../../widgets/process_card.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: const [
        Text(
          'Tổng quan chung cư',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),

        SizedBox(height: 20),

        StatCard(
          title: 'Cư dân',
          value: '1.240',
          icon: Icons.people,
        ),

        SizedBox(height: 12),

        StatCard(
          title: 'Dịch vụ đang sử dụng',
          value: '830',
          icon: Icons.miscellaneous_services,
        ),

        SizedBox(height: 12),

        StatCard(
          title: 'Khoản phí chưa thanh toán',
          value: '48',
          icon: Icons.payments,
        ),

        SizedBox(height: 25),

        Text(
          'Công việc gần đây',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        SizedBox(height: 12),

        ProcessCard(
          title: 'Đăng ký nhân khẩu mới',
          subtitle: 'Căn A101 • Nguyễn Văn An',
          icon: Icons.person_add,
        ),

        ProcessCard(
          title: 'Phản ánh đèn hành lang',
          subtitle: 'Đang xử lý',
          icon: Icons.feedback,
        ),

        ProcessCard(
          title: 'Bảo trì thang máy',
          subtitle: 'Dự kiến 05/10/2026',
          icon: Icons.build,
        ),
      ],
    );
  }
}