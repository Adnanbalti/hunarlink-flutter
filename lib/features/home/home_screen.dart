import 'package:flutter/material.dart';
import '../auth/auth_service.dart';
import '../auth/phone_input_screen.dart';
import '../provider/provider_list_screen.dart';
import '../booking/my_bookings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final List<Map<String, dynamic>> categories = const [
    {'name': 'Plumber', 'icon': Icons.plumbing, 'color': Color(0xFF2196F3)},
    {'name': 'Electrician', 'icon': Icons.electric_bolt, 'color': Color(0xFFFFC107)},
    {'name': 'Tutor', 'icon': Icons.school, 'color': Color(0xFF4CAF50)},
    {'name': 'Carpenter', 'icon': Icons.handyman, 'color': Color(0xFF795548)},
    {'name': 'Painter', 'icon': Icons.format_paint, 'color': Color(0xFFE91E63)},
    {'name': 'Cleaner', 'icon': Icons.cleaning_services, 'color': Color(0xFF00BCD4)},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('HunarLink',
          style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const MyBookingsScreen())),
          ),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF0F3460),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Assalam o Alaikum! 👋',
                    style: TextStyle(color: Colors.white70, fontSize: 14)),
                  SizedBox(height: 4),
                  Text('Kaunsi service chahiye?',
                    style: TextStyle(color: Colors.white,
                      fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const Text('Categories',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final cat = categories[index];
                return GestureDetector(
                  onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) =>
                      ProviderListScreen(skill: cat['name']))),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: (cat['color'] as Color).withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(cat['icon'] as IconData,
                            color: cat['color'] as Color, size: 28),
                        ),
                        const SizedBox(height: 8),
                        Text(cat['name'],
                          style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}