import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../shared/models/provider_model.dart';
import 'booking_service.dart';

class BookingScreen extends StatefulWidget {
  final ProviderModel provider;
  const BookingScreen({super.key, required this.provider});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  bool _loading = false;
  final _storage = const FlutterSecureStorage();

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (date != null) setState(() => _selectedDate = date);
  }

  Future<void> _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) setState(() => _selectedTime = time);
  }

  Future<void> _confirmBooking() async {
    if (_selectedDate == null || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Date aur time select karo')));
      return;
    }

    setState(() => _loading = true);

    try {
      final userId = await _storage.read(key: 'user_id');
      if (userId == null) throw Exception('User ID not found');

      final scheduledAt = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      ).toIso8601String();

      await BookingService.createBooking(
        consumerId: userId,
        providerId: widget.provider.id,
        scheduledAt: scheduledAt,
      );

      if (mounted) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Booking Confirmed! 🎉'),
            content: Text(
              '${widget.provider.user.name} ke saath booking ho gayi!\n'
              'Rs. ${widget.provider.hourlyRate.toInt()}/hr'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Booking error: $e')));
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(title: const Text('Booking Karo')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Provider info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: const Color(0xFF0F3460),
                    child: Text(
                      widget.provider.user.name[0].toUpperCase(),
                      style: const TextStyle(color: Colors.white)),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.provider.user.name,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text(widget.provider.skill,
                        style: TextStyle(color: Colors.grey.shade600)),
                    ],
                  ),
                  const Spacer(),
                  Text('Rs. ${widget.provider.hourlyRate.toInt()}/hr',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F3460))),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const Text('Date Select Karo',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _pickDate,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today, color: Color(0xFF0F3460)),
                    const SizedBox(width: 12),
                    Text(_selectedDate == null
                      ? 'Date choose karo'
                      : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                      style: TextStyle(
                        color: _selectedDate == null
                          ? Colors.grey : Colors.black)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            const Text('Time Select Karo',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _pickTime,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.access_time, color: Color(0xFF0F3460)),
                    const SizedBox(width: 12),
                    Text(_selectedTime == null
                      ? 'Time choose karo'
                      : _selectedTime!.format(context),
                      style: TextStyle(
                        color: _selectedTime == null
                          ? Colors.grey : Colors.black)),
                  ],
                ),
              ),
            ),
            const Spacer(),

            ElevatedButton(
              onPressed: _loading ? null : _confirmBooking,
              child: _loading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text('Booking Confirm Karo',
                    style: TextStyle(fontSize: 16)),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}