import 'package:flutter/material.dart';
import '../../core/api/api_client.dart';
import 'auth_service.dart';
import 'otp_verify_screen.dart';

class ConsumerRegisterScreen extends StatefulWidget {
  const ConsumerRegisterScreen({super.key});

  @override
  State<ConsumerRegisterScreen> createState() =>
      _ConsumerRegisterScreenState();
}

class _ConsumerRegisterScreenState extends State<ConsumerRegisterScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _loading = false;
  String? _error;

  Future<void> _register() async {
    if (_nameController.text.trim().isEmpty) {
      setState(() => _error = 'Naam enter karo'); return;
    }
    if (_phoneController.text.trim().length < 11) {
      setState(() => _error = 'Valid phone number enter karo'); return;
    }

    setState(() { _loading = true; _error = null; });

    try {
      // Check karo phone already registered hai ya nahi
      final checkRes = await ApiClient.dio.get('/auth/check-phone',
        queryParameters: {'phone': _phoneController.text.trim()});

      if (checkRes.data['data']['exists'] == true) {
        setState(() => _error = 'Yeh number already registered hai. Login karo.');
        return;
      }

      // Register karo
      final res = await ApiClient.dio.post('/auth/register/consumer', data: {
        'name': _nameController.text.trim(),
        'phone': _phoneController.text.trim(),
      });

      final token = res.data['data']['token'];
      final userId = res.data['data']['userId'];
      await AuthService.saveUserData(token: token, userId: userId);

      // OTP bhejo
      await ApiClient.dio.post('/auth/send-otp',
        data: {'phone': _phoneController.text.trim()});

      if (mounted) {
        Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (_) => OtpVerifyScreen(
            phone: _phoneController.text.trim(),
            isRegistration: true,
          )));
      }
    } catch (e) {
      setState(() => _error = 'Registration failed. Dobara try karo.');
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Consumer Registration')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const Text('Account Banao',
                style: TextStyle(
                  fontSize: 26, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('Apni details enter karo',
                style: TextStyle(color: Colors.grey.shade600)),
              const SizedBox(height: 32),

              TextField(
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'Poora Naam',
                  hintText: 'Ali Raza',
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                maxLength: 11,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  hintText: '03001234567',
                  prefixIcon: Icon(Icons.phone),
                ),
              ),

              if (_error != null) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(_error!,
                    style: TextStyle(color: Colors.red.shade700)),
                ),
              ],

              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: _loading ? null : _register,
                child: _loading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Aage Barhein',
                      style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}