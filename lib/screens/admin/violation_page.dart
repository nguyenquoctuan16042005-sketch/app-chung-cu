import 'package:flutter/material.dart';

import '../../widgets/section_card.dart';
import '../../widgets/status_chip.dart';

class ViolationPage extends StatelessWidget {
  const ViolationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final data = [
      [
        'VP001',
        'A103',
        'Gây tiếng ồn sau 22h',
        'Nhắc nhở',
        'Đang xử lý'
      ],
      [
        'VP002',
        'B202',
        'Để đồ tại hành lang',
        'Yêu cầu khắc phục',
        'Hoàn thành'
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
                      'Tìm căn hộ hoặc nội dung vi phạm...',
                  prefixIcon:
                      Icon(Icons.search),
                ),
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add),
              label:
                  const Text('Ghi nhận vi phạm'),
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
                DataColumn(label: Text('Mã')),
                DataColumn(
                    label: Text('Căn hộ')),
                DataColumn(
                    label: Text('Nội dung')),
                DataColumn(
                    label: Text('Xử lý')),
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
                    DataCell(
                      StatusChip(e[4]),
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