// lib/features/insight/data/services/insight_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../config/api_config.dart';
import '../models/insight_model.dart';

class InsightService {
  // lib/features/insight/data/services/insight_service.dart
Future<InsightModel?> fetchInsight(String token) async {
  final response = await http.get(
    Uri.parse('${ApiConfig.baseUrl}/insight'),
    headers: {
      'Authorization': 'Bearer $token', // token plain (sebelum di-hash)
      'Accept': 'application/json',
    },
  ).timeout(const Duration(seconds: 10));

  if (response.statusCode == 401) {
    throw Exception('Sesi berakhir, silakan login ulang');
  }

  if (response.statusCode != 200) {
    throw Exception('Gagal memuat insight');
  }

  final body = jsonDecode(response.body);
  if (body['data'] == null) return null;

  return InsightModel.fromJson(body);
}
}