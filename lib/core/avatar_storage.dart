import 'dart:convert';
import 'dart:typed_data';
import 'package:shared_preferences/shared_preferences.dart';

class AvatarStorage {
  static const String _prefKey = 'avatar_base64';

  static Future<bool> save(Uint8List bytes) async {
    try {
      if (bytes.isEmpty) return false;
      final base64String = base64Encode(bytes);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefKey, base64String);
      return true;
    } catch (_) {
      return false;
    }
  }

  static Future<Uint8List?> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final base64String = prefs.getString(_prefKey);
      if (base64String == null || base64String.length < 4) return null;
      final bytes = base64Decode(base64String);
      return bytes.isEmpty ? null : bytes;
    } catch (_) {
      return null;
    }
  }

  /// Hanya dipanggil saat hapus akun, BUKAN saat logout
  static Future<void> delete() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_prefKey);
    } catch (_) {}
  }
}