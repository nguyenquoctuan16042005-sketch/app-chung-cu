import 'package:flutter/material.dart';

import '../../widgets/section_card.dart';
import '../../widgets/status_chip.dart';

class FeedbackPage extends StatelessWidget {
  const FeedbackPage({super.key});

  @override
  Widget build(BuildContext context) {
    final data = [
      [
        'PA001',
        'Nguyễn Văn An',
        'A101',
        'Đèn hành lang bị hỏng',
        'Đang xử lý'
      ],
      [
        'PA002',
        'Trần Văn Bình',
        'A102',
        'Khu giữ xe chưa sạch',
        'Mới tiếp nhận'
      ],
    ];

    return ListView(
      padding: const EdgeInsets.all(26),
      children: [
        const TextField(
          decoration: InputDecoration(
            hintText:
                'Tìm phản ánh, cư dân, căn hộ...',
            prefixIcon: Icon(Icons.search),
          ),
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
                    label: Text('Cư dân')),
                DataColumn(
                    label: Text('Căn hộ')),
                DataColumn(
                    label: Text('Nội dung')),
                DataColumn(
                    label: Text('Trạng thái')),
                DataColumn(label: Text('')),
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
                    DataCell(
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons
                              .visibility_outlined,
                        ),
                      ),
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