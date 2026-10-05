import 'package:flutter/material.dart';

import 'core/app_theme.dart';
import 'screens/auth/login_page.dart';

class ChungCuApp extends StatelessWidget {
  const ChungCuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quản lý chung cư',
      theme: AppTheme.lightTheme,
      home: const LoginPage(),
    );
  }
}