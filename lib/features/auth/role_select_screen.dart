import 'package:flutter/material.dart';
import 'consumer_register_screen.dart';
import 'provider_register_screen.dart';

class RoleSelectScreen extends StatelessWidget {
  const RoleSelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Account Type')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text('Aap kaun hain?',
                style: TextStyle(
                  fontSize: 26, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('Account type select karo',
                style: TextStyle(color: Colors.grey.shade600)),
              const SizedBox(height: 40),

              // Consumer Card
              _roleCard(
                context: context,
                icon: Icons.person,
                color: const Color(0xFF2196F3),
                title: 'Consumer',
                subtitle: 'Service book karo\nElectrician, Plumber, Tutor etc.',
                onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) =>
                    const ConsumerRegisterScreen())),
              ),
              const SizedBox(height: 16),

              // Provider Card
              _roleCard(
                context: context,
                icon: Icons.handyman,
                color: const Color(0xFF4CAF50),
                title: 'Provider',
                subtitle: 'Apni service do aur kamao\nElectrician, Plumber, Tutor etc.',
                onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) =>
                    const ProviderRegisterScreen())),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _roleCard({
    required BuildContext context,
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade100,
              blurRadius: 8,
              offset: const Offset(0, 2))
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                    style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(subtitle,
                    style: TextStyle(
                      color: Colors.grey.shade600, fontSize: 13)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios,
              color: Colors.grey, size: 16),
          ],
        ),
      ),
    );
  }
}