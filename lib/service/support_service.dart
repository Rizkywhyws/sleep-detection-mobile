// lib/features/support/data/services/support_service.dart
import 'package:url_launcher/url_launcher.dart';

class SupportService {
  static const _whatsAppNumber = '082257305018';
  static const _supportEmail = 'noctura1@gmail.com';

  // ── FAQ ───────────────────────────────────────────────────────────────────
  List<FaqItem> getFaqs() => _localFaqs;

  // ── Contact ───────────────────────────────────────────────────────────────
  Future<void> openWhatsApp(String message) async {
    final encoded = Uri.encodeComponent(message);
    final uri = Uri.parse('https://wa.me/$_whatsAppNumber?text=$encoded');
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Tidak dapat membuka WhatsApp');
    }
  }

  Future<void> openEmail({required String subject}) async {
    final uri = Uri(
      scheme: 'mailto',
      path: _supportEmail,
      query: 'subject=${Uri.encodeComponent(subject)}',
    );
    if (!await launchUrl(uri)) {
      throw Exception('Tidak dapat membuka aplikasi email');
    }
  }
}

// ── Data Model & Local Data ─────────────────────────────────────────────────

class FaqItem {
  final String question;
  final String answer;
  const FaqItem({required this.question, required this.answer});
}

const List<FaqItem> _localFaqs = [
  FaqItem(
    question: 'Bagaimana cara mengatur pengingat tidur?',
    answer: 'Buka menu Profil → Tujuan Tidur, lalu aktifkan notifikasi harian.',
  ),
  FaqItem(
    question: 'Apakah data tidur saya aman?',
    answer:
        'Data disimpan secara terenkripsi dan tidak dibagikan ke pihak ketiga.',
  ),
  FaqItem(
    question: 'Kenapa grafik tidur saya kosong?',
    answer:
        'Pastikan kamu sudah mengisi data tidur minimal 1 hari. Grafik butuh minimal 3 data.',
  ),
  FaqItem(
    question: 'Bagaimana cara menghapus akun?',
    answer: 'Masuk ke Pengaturan Akun → Hapus Akun. Proses ini permanen.',
  ),
];