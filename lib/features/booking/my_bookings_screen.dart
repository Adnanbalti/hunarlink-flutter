import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../shared/models/booking_model.dart';
import '../../shared/widgets/empty_state.dart';
import '../../shared/widgets/loading_shimmer.dart';
import 'booking_service.dart';

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  List<BookingModel> _bookings = [];
  bool _loading = true;
  final _storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _loadBookings();
  }

  Future<void> _loadBookings() async {
    setState(() => _loading = true);
    try {
      final userId = await _storage.read(key: 'user_id');
      if (userId == null) throw Exception('User not found');
      final bookings = await BookingService.getMyBookings(userId);
      setState(() => _bookings = bookings);
    } catch (e) {
      setState(() => _bookings = []);
    } finally {
      setState(() => _loading = false);
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'CONFIRMED': return Colors.blue;
      case 'COMPLETED': return Colors.green;
      case 'CANCELLED': return Colors.red;
      default: return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meri Bookings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadBookings,
          ),
        ],
      ),
      body: _loading
        ? ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: 4,
            itemBuilder: (_, __) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: LoadingShimmer(height: 90),
            ),
          )
        : _bookings.isEmpty
          ? EmptyState(
              message: 'Abhi tak koi booking nahi\nkisi service ko book karo!',
              icon: Icons.calendar_today_outlined,
              onRetry: _loadBookings,
            )
          : RefreshIndicator(
              onRefresh: _loadBookings,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _bookings.length,
                itemBuilder: (context, index) {
                  final b = _bookings[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: const Color(0xFF0F3460),
                              child: Text(
                                b.provider.user.name[0].toUpperCase(),
                                style: const TextStyle(color: Colors.white)),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(b.provider.user.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                                  Text(b.provider.skill,
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 13)),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: _statusColor(b.status).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(b.status,
                                style: TextStyle(
                                  color: _statusColor(b.status),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(Icons.calendar_today,
                              size: 14, color: Colors.grey.shade500),
                            const SizedBox(width: 4),
                            Text(b.scheduledAt.split('T')[0],
                              style: TextStyle(
                                color: Colors.grey.shade600, fontSize: 13)),
                            const Spacer(),
                            Text('Rs. ${b.totalAmount.toInt()}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0F3460))),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
    );
  }
}