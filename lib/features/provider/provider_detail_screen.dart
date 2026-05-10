import 'package:flutter/material.dart';
import '../../shared/models/provider_model.dart';
import '../booking/booking_screen.dart';

class ProviderDetailScreen extends StatelessWidget {
  final ProviderModel provider;
  const ProviderDetailScreen({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(title: Text(provider.user.name)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              color: Colors.white,
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: const Color(0xFF0F3460),
                    child: Text(
                      provider.user.name[0].toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 12),
                  Text(provider.user.name,
                    style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(provider.skill,
                    style: TextStyle(
                      fontSize: 16, color: Colors.grey.shade600)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      Text(' ${provider.averageRating.toStringAsFixed(1)}',
                        style: const TextStyle(fontSize: 16)),
                      const SizedBox(width: 16),
                      const Icon(Icons.location_on,
                        color: Colors.grey, size: 20),
                      Text(' ${provider.city}',
                        style: TextStyle(
                          fontSize: 16, color: Colors.grey.shade600)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Info cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: _infoCard('Rate/hr',
                      'Rs. ${provider.hourlyRate.toInt()}',
                      Icons.payments)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _infoCard('Status',
                      provider.isVerified ? 'Verified ✓' : 'Pending',
                      Icons.verified)),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Bio
            if (provider.bio.isNotEmpty)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Baare mein',
                      style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(provider.bio,
                      style: TextStyle(
                        color: Colors.grey.shade700, height: 1.5)),
                  ],
                ),
              ),

            const SizedBox(height: 24),

            // Book button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) =>
                    BookingScreen(provider: provider))),
                child: const Text('Book Now',
                  style: TextStyle(fontSize: 16)),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _infoCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFF0F3460), size: 24),
          const SizedBox(height: 8),
          Text(value,
            style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 15)),
          Text(label,
            style: TextStyle(
              color: Colors.grey.shade600, fontSize: 12)),
        ],
      ),
    );
  }
}