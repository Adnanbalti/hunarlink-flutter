import 'package:flutter/material.dart';
import '../../core/api/api_client.dart';
import 'auth_service.dart';
import 'otp_verify_screen.dart';

class ProviderRegisterScreen extends StatefulWidget {
  const ProviderRegisterScreen({super.key});

  @override
  State<ProviderRegisterScreen> createState() =>
      _ProviderRegisterScreenState();
}

class _ProviderRegisterScreenState extends State<ProviderRegisterScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cnicController = TextEditingController();
  final _experienceController = TextEditingController();
  final _cityController = TextEditingController();
  String _selectedSkill = 'Plumber';
  String _selectedCountry = 'Pakistan';
  bool _loading = false;
  String? _error;

  final List<String> _skills = [
    'Plumber', 'Electrician', 'Tutor',
    'Carpenter', 'Painter', 'Cleaner',
  ];

  final List<String> _countries = [
    'Pakistan', 'Saudi Arabia', 'UAE',
    'UK', 'USA', 'Canada',
  ];

  Future<void> _register() async {
    if (_nameController.text.trim().isEmpty) {
      setState(() => _error = 'Naam enter karo'); return;
    }
    if (_phoneController.text.trim().length < 11) {
      setState(() => _error = 'Valid phone number enter karo'); return;
    }
    if (_cnicController.text.trim().length < 13) {
      setState(() => _error = 'Valid CNIC enter karo (13 digits)'); return;
    }
    if (_cityController.text.trim().isEmpty) {
      setState(() => _error = 'City enter karo'); return;
    }
    if (_experienceController.text.trim().isEmpty) {
      setState(() => _error = 'Experience enter karo'); return;
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
      final res = await ApiClient.dio.post('/auth/register/provider', data: {
        'name': _nameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'cnic': _cnicController.text.trim(),
        'skill': _selectedSkill,
        'city': _cityController.text.trim(),
        'country': _selectedCountry,
        'yearsOfExperience': int.parse(_experienceController.text.trim()),
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
      appBar: AppBar(title: const Text('Provider Registration')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const Text('Provider Account',
                style: TextStyle(
                  fontSize: 26, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text('Apni complete details enter karo',
                style: TextStyle(color: Colors.grey.shade600)),
              const SizedBox(height: 24),

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

              TextField(
                controller: _cnicController,
                keyboardType: TextInputType.number,
                maxLength: 13,
                decoration: const InputDecoration(
                  labelText: 'CNIC Number',
                  hintText: '3520112345678',
                  prefixIcon: Icon(Icons.credit_card),
                ),
              ),

              DropdownButtonFormField<String>(
                value: _selectedSkill,
                decoration: const InputDecoration(
                  labelText: 'Skill',
                  prefixIcon: Icon(Icons.handyman),
                ),
                items: _skills.map((s) => DropdownMenuItem(
                  value: s, child: Text(s))).toList(),
                onChanged: (v) => setState(() => _selectedSkill = v!),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: _cityController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'City',
                  hintText: 'Lahore',
                  prefixIcon: Icon(Icons.location_city),
                ),
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _selectedCountry,
                decoration: const InputDecoration(
                  labelText: 'Country',
                  prefixIcon: Icon(Icons.flag),
                ),
                items: _countries.map((c) => DropdownMenuItem(
                  value: c, child: Text(c))).toList(),
                onChanged: (v) => setState(() => _selectedCountry = v!),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: _experienceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Years of Experience',
                  hintText: '3',
                  prefixIcon: Icon(Icons.work_history),
                ),
              ),

              if (_error != null) ...[
                const SizedBox(height: 12),
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
                  : const Text('Register Karo',
                      style: TextStyle(fontSize: 16)),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}