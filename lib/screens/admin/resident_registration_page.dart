import 'package:flutter/material.dart';

import '../../widgets/section_card.dart';
import '../../widgets/status_chip.dart';

class ResidentRegistrationPage
    extends StatefulWidget {
  const ResidentRegistrationPage({
    super.key,
  });

  @override
  State<ResidentRegistrationPage>
      createState() =>
          _ResidentRegistrationPageState();
}

class _ResidentRegistrationPageState
    extends State<ResidentRegistrationPage> {
  final residents = [
    [
      'CD001',
      'Nguyễn Văn An',
      'A101',
      'Chủ sở hữu',
      '0901234567',
      'Đang cư trú',
    ],
    [
      'CD002',
      'Nguyễn Thị Mai',
      'A101',
      'Thành viên',
      '0912345678',
      'Đang cư trú',
    ],
    [
      'CD003',
      'Trần Văn Bình',
      'A102',
      'Người thuê',
      '0923456789',
      'Đang cư trú',
    ],
  ];

  void showAddDialog() {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title:
              const Text('Đăng ký nhân khẩu'),
          content: SizedBox(
            width: 520,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const TextField(
                    decoration: InputDecoration(
                      labelText: 'Họ tên',
                    ),
                  ),
                  const SizedBox(height: 12),
                  const TextField(
                    decoration: InputDecoration(
                      labelText: 'CCCD',
                    ),
                  ),
                  const SizedBox(height: 12),
                  const TextField(
                    decoration: InputDecoration(
                      labelText:
                          'Số điện thoại',
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField(
                    items: const [
                      DropdownMenuItem(
                        value: 'A101',
                        child: Text('A101'),
                      ),
                      DropdownMenuItem(
                        value: 'A102',
                        child: Text('A102'),
                      ),
                    ],
                    onChanged: (_) {},
                    decoration:
                        const InputDecoration(
                      labelText: 'Căn hộ',
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField(
                    items: const [
                      DropdownMenuItem(
                        value: 'Chủ sở hữu',
                        child:
                            Text('Chủ sở hữu'),
                      ),
                      DropdownMenuItem(
                        value: 'Người thuê',
                        child: Text('Người thuê'),
                      ),
                      DropdownMenuItem(
                        value: 'Thành viên',
                        child: Text('Thành viên'),
                      ),
                    ],
                    onChanged: (_) {},
                    decoration:
                        const InputDecoration(
                      labelText: 'Vai trò',
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.pop(context),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Lưu'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(26),
      children: [
        Row(
          children: [
            const Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText:
                      'Tìm theo họ tên, SĐT, căn hộ...',
                  prefixIcon:
                      Icon(Icons.search),
                ),
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton.icon(
              onPressed: showAddDialog,
              icon: const Icon(
                Icons.person_add_alt_1,
              ),
              label: const Text(
                'Đăng ký nhân khẩu',
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
                DataColumn(label: Text('Mã')),
                DataColumn(
                    label: Text('Họ tên')),
                DataColumn(
                    label: Text('Căn hộ')),
                DataColumn(
                    label: Text('Vai trò')),
                DataColumn(
                    label: Text('SĐT')),
                DataColumn(
                    label: Text('Trạng thái')),
                DataColumn(
                    label: Text('Thao tác')),
              ],
              rows: residents.map((r) {
                return DataRow(
                  cells: [
                    DataCell(Text(r[0])),
                    DataCell(Text(r[1])),
                    DataCell(Text(r[2])),
                    DataCell(Text(r[3])),
                    DataCell(Text(r[4])),
                    DataCell(
                      StatusChip(r[5]),
                    ),
                    DataCell(
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.visibility_outlined,
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.edit_outlined,
                            ),
                          ),
                        ],
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