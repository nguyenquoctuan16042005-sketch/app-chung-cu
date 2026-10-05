import 'package:flutter/material.dart';

import '../../widgets/section_card.dart';
import '../../widgets/status_chip.dart';

class MaintenancePage extends StatelessWidget {
  const MaintenancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          Container(
            color: Colors.white,
            child: const TabBar(
              tabs: [
                Tab(text: 'Thiết bị'),
                Tab(text: 'Lịch bảo trì'),
                Tab(text: 'Sửa chữa'),
              ],
            ),
          ),

          Expanded(
            child: TabBarView(
              children: [
                _devices(),
                _schedule(),
                _repairs(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _devices() {
    return _list([
      'TB001 • Thang máy Block A • Hoạt động bình thường',
      'TB002 • Máy bơm nước • Hoạt động bình thường',
      'TB003 • Camera Block B • Đang kiểm tra',
    ]);
  }

  Widget _schedule() {
    return _list([
      'Thang máy Block A • 10/10/2026 • Chờ thực hiện',
      'Máy bơm nước • 15/10/2026 • Chờ thực hiện',
    ]);
  }

  Widget _repairs() {
    return _list([
      'BT001 • Thang máy Block A • Hoàn thành',
      'BT002 • Camera Block B • Đang xử lý',
    ]);
  }

  Widget _list(List<String> items) {
    return ListView(
      padding: const EdgeInsets.all(26),
      children: items.map((e) {
        final status =
            e.split(' • ').last;

        return Padding(
          padding:
              const EdgeInsets.only(
            bottom: 12,
          ),
          child: SectionCard(
            child: Row(
              children: [
                const Icon(
                  Icons.build_circle_outlined,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(e),
                ),
                StatusChip(status),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}