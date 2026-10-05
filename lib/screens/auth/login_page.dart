import 'package:flutter/material.dart';

import '../../core/app_theme.dart';
import '../admin/admin_home.dart';
import '../resident/resident_home.dart';

enum UserRole {
  admin,
  resident,
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() =>
      _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController =
      TextEditingController();
  final passwordController =
      TextEditingController();

  UserRole role = UserRole.admin;

  bool hidePassword = true;
  bool remember = false;

  void login() {
    if (role == UserRole.admin) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const AdminHome(),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const ResidentHome(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          if (MediaQuery.of(context).size.width >
              850)
            Expanded(
              child: Container(
                color: AppColors.primary,
                padding: const EdgeInsets.all(60),
                child: const Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.apartment_rounded,
                      color: Colors.white,
                      size: 70,
                    ),
                    SizedBox(height: 25),
                    Text(
                      'Quản lý chung cư\nđơn giản và hiệu quả',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 38,
                        height: 1.2,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 15),
                    Text(
                      'Quản lý cư dân, dịch vụ, thanh toán, phản ánh và bảo trì tại một nơi.',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          Expanded(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(30),
                child: SizedBox(
                  width: 430,
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Đăng nhập',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Chào mừng trở lại hệ thống quản lý chung cư.',
                        style: TextStyle(
                          color:
                              AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 30),

                      TextField(
                        controller:
                            usernameController,
                        decoration:
                            const InputDecoration(
                          labelText:
                              'Tên đăng nhập',
                          prefixIcon:
                              Icon(Icons.person),
                        ),
                      ),

                      const SizedBox(height: 16),

                      TextField(
                        controller:
                            passwordController,
                        obscureText: hidePassword,
                        decoration: InputDecoration(
                          labelText: 'Mật khẩu',
                          prefixIcon:
                              const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                hidePassword =
                                    !hidePassword;
                              });
                            },
                            icon: Icon(
                              hidePassword
                                  ? Icons.visibility
                                  : Icons
                                      .visibility_off,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      DropdownButtonFormField<UserRole>(
                        value: role,
                        decoration:
                            const InputDecoration(
                          labelText:
                              'Vai trò demo',
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: UserRole.admin,
                            child: Text(
                              'Ban quản lý',
                            ),
                          ),
                          DropdownMenuItem(
                            value:
                                UserRole.resident,
                            child: Text('Cư dân'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              role = value;
                            });
                          }
                        },
                      ),

                      CheckboxListTile(
                        value: remember,
                        contentPadding:
                            EdgeInsets.zero,
                        controlAffinity:
                            ListTileControlAffinity
                                .leading,
                        title: const Text(
                          'Ghi nhớ đăng nhập',
                        ),
                        onChanged: (value) {
                          setState(() {
                            remember =
                                value ?? false;
                          });
                        },
                      ),

                      const SizedBox(height: 10),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: login,
                          child: const Text(
                            'Đăng nhập',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}