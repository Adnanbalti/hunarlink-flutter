import '../../core/api/api_client.dart';
import '../../shared/models/provider_model.dart';
import '../../shared/models/user_model.dart';

class ProviderService {
  static Future<List<ProviderModel>> getProviders({
    String? skill,
    String? city,
  }) async {
    final params = <String, dynamic>{};
    if (skill != null) params['skill'] = skill;
    if (city != null) params['city'] = city;

    final response = await ApiClient.dio.get('/providers',
      queryParameters: params.isNotEmpty ? params : null);

    final List data = response.data['data'] ?? [];
    return data.map((e) => ProviderModel.fromJson(e)).toList();
  }
}