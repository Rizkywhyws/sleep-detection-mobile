import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;

class EdukasiService {
  static String get baseUrl {
    if (kIsWeb) {
      // Untuk Web (Chrome)
      return 'http://localhost:8000/api/edukasi';
    } else {
      // Untuk Android Emulator
      return 'http://10.0.2.2:8000/api/edukasi';
      // Untuk HP Real: ganti dengan IP komputer
      // return 'http://192.168.1.100:8000/api/edukasi';
    }
  }

  static Future<List<dynamic>> getEdukasi({bool onlyPublished = true}) async {
    try {
      final url = onlyPublished ? '$baseUrl/published' : baseUrl;
      print('📡 Panggil API: $url');
      
      final response = await http.get(Uri.parse(url));
      
      print('📡 Response status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        print('📡 Data diterima: ${data['data']?.length ?? 0} item');
        return data['data'] ?? [];
      } else {
        print('❌ Error: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('❌ Exception: $e');
      return [];
    }
  }
}