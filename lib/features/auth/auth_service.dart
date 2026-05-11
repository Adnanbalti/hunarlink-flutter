import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../core/api/api_client.dart';

class AuthService {
  static const _storage = FlutterSecureStorage();

  static Future<void> sendOtp(String phone) async {
    await ApiClient.dio.post('/auth/send-otp', data: {'phone': phone});
  }

  static Future<Map<String, dynamic>> verifyOtp(String phone, String otp) async {
    final response = await ApiClient.dio.post('/auth/verify-otp', data: {
      'phone': phone,
      'otp': otp,
    });
    final data = response.data['data'];
    final role = data['role'];

    if (role == 'NEW_USER') {
      return {'isNewUser': true, 'phone': phone};
    }

    await _storage.write(key: 'jwt_token', value: data['token']);
    await _storage.write(key: 'user_id', value: data['userId']);
    return {'isNewUser': false};
  }

  static Future<void> verifyOtpOnly(String phone, String otp) async {
    await ApiClient.dio.post('/auth/verify-otp', data: {
      'phone': phone,
      'otp': otp,
    });
  }

  static Future<void> saveUserData({
    required String token,
    required String userId,
  }) async {
    await _storage.write(key: 'jwt_token', value: token);
    await _storage.write(key: 'user_id', value: userId);
  }

  static Future<void> logout() async {
    await _storage.delete(key: 'jwt_token');
    await _storage.delete(key: 'user_id');
  }

  static Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: 'jwt_token');
    return token != null && token.isNotEmpty;
  }
}