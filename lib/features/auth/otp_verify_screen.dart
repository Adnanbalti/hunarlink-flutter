import 'package:flutter/material.dart';
import 'auth_service.dart';
import '../home/home_screen.dart';

class OtpVerifyScreen extends StatefulWidget {
  final String phone;
  const OtpVerifyScreen({super.key, required this.phone});

  @override
  State<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends State<OtpVerifyScreen> {
  final _otpController = TextEditingController();
  bool _loading = false;
  String? _error;

  Future<void> _verifyOtp() async {
    final otp = _otpController.text.trim();
    if (otp.length < 4) {
      setState(() => _error = '4 digit OTP enter karo');
      return;
    }

    setState(() { _loading = true; _error = null; });

    try {
      await AuthService.verifyOtp(widget.phone, otp);
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      setState(() => _error = 'Invalid ya expired OTP');
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('OTP Verify')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text('OTP Enter Karo',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('${widget.phone} pe OTP bheja gaya',
                style: TextStyle(color: Colors.grey.shade600)),
              const SizedBox(height: 40),

              TextField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                decoration: InputDecoration(
                  labelText: 'OTP Code',
                  hintText: '1234',
                  prefixIcon: const Icon(Icons.lock_outline),
                ),
              ),

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
                onPressed: _loading ? null : _verifyOtp,
                child: _loading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Verify Karo', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}