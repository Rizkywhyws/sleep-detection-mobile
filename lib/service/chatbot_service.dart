// lib/features/chatbot/services/chatbot_service.dart

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../../config/api_config.dart';

class ChatMessage {
  final String role;    
  final String content;
  final DateTime timestamp;

  const ChatMessage({
    required this.role,
    required this.content,
    required this.timestamp,
  });

  Map<String, String> toOllamaFormat() => {
        'role':    role,
        'content': content,
      };
}

class ChatbotService {
  static String get _baseUrl {
  final uri = Uri.parse(ApiConfig.baseUrl);
  return '${uri.scheme}://${uri.host}:11434';
} 
  static const String _model     = 'llama3.2';
  static const String _systemPrompt = 'Kamu adalah SleepBot, asisten tidur. Jawab bahasa Indonesia, singkat 1-2 kalimat, tanpa markdown.';

  static final ChatbotService instance = ChatbotService._internal();
  ChatbotService._internal();
  factory ChatbotService() => instance;

  Future<String> sendMessage(List<ChatMessage> history) async {
    try {
      final messages = [
        {'role': 'system', 'content': _systemPrompt},
        ...history.map((m) => m.toOllamaFormat()),
      ];

      final response = await http
          .post(
            Uri.parse('$_baseUrl/api/chat'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'model':    _model,
              'messages': messages,
              'stream':   false,
              'options':  {
                'temperature': 0.5,
                'num_predict': 80,
              },
            }),
          )
          .timeout(const Duration(seconds: 60));

      if (response.statusCode != 200) {
        throw Exception('Ollama error: ${response.statusCode}');
      }

      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final content = body['message']?['content'] as String? ?? '';

      if (content.isEmpty) throw Exception('Response kosong dari Ollama');

      return content.trim();
    } on http.ClientException catch (e) {
      debugPrint('=== ChatbotService: ClientException=${e.message}');
      throw Exception('Tidak bisa terhubung ke Ollama. Pastikan ollama serve sedang berjalan.');
    } catch (e) {
      debugPrint('=== ChatbotService: ERROR=$e');
      if (e is Exception) rethrow;
      throw Exception('Terjadi kesalahan: $e');
    }
  }
}