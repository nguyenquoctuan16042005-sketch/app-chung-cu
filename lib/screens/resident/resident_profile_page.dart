import 'package:flutter/material.dart';

import '../../data/app_repository.dart';
import '../../widgets/section_card.dart';

class ResidentProfilePage extends StatelessWidget {
  const ResidentProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = AppRepository.instance;
    final apt = repo.getApartmentById(repo.currentResidentApartmentId);
    final name = apt?.ownerName ?? 'Thu Hà';
    final code = apt?.displayCode ?? 'A-05-01';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hồ sơ cá nhân'),
      ),
      body: ListView(
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
                    const SizedBox(height: 15),
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Chủ sở hữu • Căn $code',
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 25),
                    const TextField(
                      decoration: InputDecoration(
                        labelText: 'Số điện thoại',
                        prefixIcon: Icon(Icons.phone),
                        hintText: '0987654321',
                      ),
                    ),
                    const SizedBox(height: 14),
                    const TextField(
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email),
                        hintText: 'thuha@bluehome.vn',
                      ),
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Đã cập nhật thông tin thành công'),
                            ),
                          );
                        },
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
      ),
    );
  }
}