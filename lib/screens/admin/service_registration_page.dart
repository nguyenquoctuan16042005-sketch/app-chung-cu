import 'package:flutter/material.dart';

import '../../widgets/section_card.dart';
import '../../widgets/status_chip.dart';

class ServiceRegistrationPage
    extends StatelessWidget {
  const ServiceRegistrationPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final data = [
      [
        'A101',
        'Gửi xe máy',
        '2',
        '120.000đ/xe',
        '01/01/2026',
        'Đang hoạt động'
      ],
      [
        'A102',
        'Gửi xe máy',
        '1',
        '120.000đ/xe',
        '15/02/2026',
        'Đang hoạt động'
      ],
      [
        'B201',
        'Gửi ô tô',
        '1',
        '800.000đ/xe',
        '20/01/2026',
        'Đang hoạt động'
      ],
    ];

    return ListView(
      padding: const EdgeInsets.all(26),
      children: [
        Row(
          children: [
            const Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText:
                      'Tìm căn hộ hoặc dịch vụ...',
                  prefixIcon:
                      Icon(Icons.search),
                ),
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add),
              label: const Text(
                'Đăng ký dịch vụ',
              ),
            ),
          ],
        ),

        const SizedBox(height: 18),

        SectionCard(
          padding: EdgeInsets.zero,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(
                    label: Text('Căn hộ')),
                DataColumn(
                    label: Text('Dịch vụ')),
                DataColumn(
                    label: Text('Số lượng')),
                DataColumn(
                    label: Text('Đơn giá')),
                DataColumn(
                    label: Text('Bắt đầu')),
                DataColumn(
                    label: Text('Trạng thái')),
              ],
              rows: data.map((e) {
                return DataRow(
                  cells: [
                    DataCell(Text(e[0])),
                    DataCell(Text(e[1])),
                    DataCell(Text(e[2])),
                    DataCell(Text(e[3])),
                    DataCell(Text(e[4])),
                    DataCell(
                      StatusChip(e[5]),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}