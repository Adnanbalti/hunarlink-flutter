import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'otp_verify_screen.dart';

class PhoneInputScreen extends StatefulWidget {
  const PhoneInputScreen({super.key});

  @override
  State<PhoneInputScreen> createState() => _PhoneInputScreenState();
}

class _PhoneInputScreenState extends State<PhoneInputScreen> {
  final _phoneController = TextEditingController();
  bool _loading = false;
  String? _error;

  Future<void> _sendOtp() async {
    final phone = _phoneController.text.trim();
    if (phone.isEmpty || phone.length < 10) {
      setState(() => _error = 'Valid phone number enter karo');
      return;
    }

    setState(() { _loading = true; _error = null; });

    try {
      await AuthService.sendOtp(phone);
      if (mounted) {
        Navigator.push(context, MaterialPageRoute(
          builder: (_) => OtpVerifyScreen(phone: phone),
        ));
      }
    } catch (e) {
      setState(() => _error = 'OTP send karne mein error. Backend check karo.');
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              const Text('HunarLink',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('Apna phone number enter karo',
                style: TextStyle(fontSize: 16, color: Colors.grey.shade600)),
              const SizedBox(height: 40),

              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  hintText: '03001234567',
                  prefixIcon: const Icon(Icons.phone),
                ),
              ),
              const SizedBox(height: 12),

              if (_error != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(_error!,
                    style: TextStyle(color: Colors.red.shade700, fontSize: 13)),
                ),

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _loading ? null : _sendOtp,
                child: _loading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('OTP Bhejo', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}