import '../../core/api/api_client.dart';
import '../../shared/models/booking_model.dart';
import '../../shared/models/provider_model.dart';
import '../../shared/models/user_model.dart';

class BookingService {
  static Future<BookingModel> createBooking({
    required String consumerId,
    required String providerId,
    required String scheduledAt,
  }) async {
    final response = await ApiClient.dio.post(
      '/bookings',
      queryParameters: {
        'consumerId': consumerId,
        'providerId': providerId,
      },
      data: {'scheduledAt': scheduledAt},
    );
    return BookingModel.fromJson(response.data['data']);
  }

  static Future<List<BookingModel>> getMyBookings(String consumerId) async {
    final response = await ApiClient.dio.get('/bookings/my',
      queryParameters: {'consumerId': consumerId});
    final List data = response.data['data'] ?? [];
    return data.map((e) => BookingModel.fromJson(e)).toList();
  }
}