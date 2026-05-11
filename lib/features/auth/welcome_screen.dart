import 'package:flutter/material.dart';
import 'phone_input_screen.dart';
import 'role_select_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),

              // Logo
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F3460),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Icon(Icons.handyman,
                  color: Colors.white, size: 60),
              ),
              const SizedBox(height: 24),

              const Text('HunarLink',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F3460))),
              const SizedBox(height: 8),
              Text('Pakistan ka #1 Service Marketplace',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600)),

              const Spacer(),

              // Register button
              ElevatedButton(
                onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) =>
                    const RoleSelectScreen())),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F3460),
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Register Karo',
                  style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
              const SizedBox(height: 12),

              // Login button
              OutlinedButton(
                onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) =>
                    const PhoneInputScreen(isLogin: true))),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 52),
                  side: const BorderSide(color: Color(0xFF0F3460), width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Login Karo',
                  style: TextStyle(fontSize: 16, color: Color(0xFF0F3460))),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}