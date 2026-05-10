import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../core/api/api_client.dart';

class AuthService {
  static final _storage = FlutterSecureStorage();

  static Future<void> sendOtp(String phone) async {
    await ApiClient.dio.post('/auth/send-otp', data: {'phone': phone});
  }

  static Future<String> verifyOtp(String phone, String otp) async {
    final response = await ApiClient.dio.post('/auth/verify-otp', data: {
      'phone': phone,
      'otp': otp,
    });
    final token = response.data['data']['token'];
    await _storage.write(key: 'jwt_token', value: token);
    return token;
  }

  static Future<void> logout() async {
    await _storage.delete(key: 'jwt_token');
  }

  static Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: 'jwt_token');
    return token != null;
  }
}