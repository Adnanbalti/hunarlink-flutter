import 'package:flutter/material.dart';
import '../auth/auth_service.dart';
import '../auth/phone_input_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HunarLink'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await AuthService.logout();
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const PhoneInputScreen()),
                  (route) => false,
                );
              }
            },
          ),
        ],
      ),
      body: const Center(
        child: Text('Home Screen — Coming Soon!',
          style: TextStyle(fontSize: 18)),
      ),
    );
  }
}