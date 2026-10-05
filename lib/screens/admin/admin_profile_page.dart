import 'package:flutter/material.dart';

import '../../widgets/section_card.dart';

class AdminProfilePage
    extends StatelessWidget {
  const AdminProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(26),
      children: [
        Center(
          child: SizedBox(
            width: 550,
            child: SectionCard(
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 45,
                    child: Icon(
                      Icons.person,
                      size: 50,
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Nguyễn Minh Tuấn',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                  const Text('Ban quản lý'),
                  const SizedBox(height: 25),
                  const TextField(
                    decoration: InputDecoration(
                      labelText:
                          'Số điện thoại',
                      prefixIcon:
                          Icon(Icons.phone),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const TextField(
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon:
                          Icon(Icons.email),
                    ),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text(
                        'Cập nhật thông tin',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}