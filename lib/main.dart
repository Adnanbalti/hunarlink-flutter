import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/auth_service.dart';
import 'features/auth/phone_input_screen.dart';
import 'features/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final loggedIn = await AuthService.isLoggedIn();
  runApp(MyApp(isLoggedIn: loggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HunarLink',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: isLoggedIn ? const HomeScreen() : const PhoneInputScreen(),
    );
  }
}