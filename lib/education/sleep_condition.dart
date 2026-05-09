import 'package:flutter/material.dart';

class SleepCondition {
  final String id;
  final String emoji;
  final String badge;
  final String title;
  final String description;
  final List<String> symptoms;
  final String tip;
  final String tipLabel;
  final Color accent;

  // Light mode colors (unchanged)
  final Color cardColor;
  final Color badgeColor;
  final Color badgeTextColor;
  final Color titleColor;
  final Color descColor;
  final Color pillColor;
  final Color pillTextColor;
  final Color tipBoxColor;

  const SleepCondition({
    required this.id,
    required this.emoji,
    required this.badge,
    required this.title,
    required this.description,
    required this.symptoms,
    required this.tip,
    required this.tipLabel,
    required this.accent,
    required this.cardColor,
    required this.badgeColor,
    required this.badgeTextColor,
    required this.titleColor,
    required this.descColor,
    required this.pillColor,
    required this.pillTextColor,
    required this.tipBoxColor,
  });
}

final List<SleepCondition> sleepConditions = [
  const SleepCondition(
    id: 'insomnia',
    emoji: '😵',
    badge: 'INSOMNIA',
    title: 'Sulit Tidur & Terjaga',
    description:
        'Insomnia adalah kondisi di mana kamu sulit memulai tidur, sering terbangun di malam hari, atau tidak merasa segar setelah tidur meski sudah cukup lama berbaring.',
    symptoms: ['Sulit tertidur', 'Sering terbangun', 'Mudah lelah', 'Sulit fokus', 'Mood buruk'],
    tip: 'Hindari kafein setelah jam 2 siang, matikan layar 1 jam sebelum tidur, dan coba teknik pernapasan 4-7-8.',
    tipLabel: 'Tips Mengatasi',
    accent: Color(0xFFEF5350),
    cardColor: Color(0xFFFFF0EE),
    badgeColor: Color(0xFFFFDAD5),
    badgeTextColor: Color(0xFF993C1D),
    titleColor: Color(0xFF7A2418),
    descColor: Color(0xFF993C1D),
    pillColor: Color(0xFFFFDAD5),
    pillTextColor: Color(0xFF7A2418),
    tipBoxColor: Color(0xFFFFE8E4),
  ),
  const SleepCondition(
    id: 'sleep_apnea',
    emoji: '😮',
    badge: 'SLEEP APNEA',
    title: 'Napas Berhenti Saat Tidur',
    description:
        'Sleep apnea terjadi ketika pernapasan berulang kali berhenti dan mulai lagi saat tidur, menyebabkan kualitas tidur menurun drastis dan tubuh kekurangan oksigen.',
    symptoms: ['Mendengkur keras', 'Terbangun sesak', 'Mengantuk siang', 'Sakit kepala pagi', 'Sulit konsentrasi'],
    tip: 'Tidur dengan posisi miring, jaga berat badan ideal, hindari alkohol, dan konsultasikan ke dokter untuk pemeriksaan lebih lanjut.',
    tipLabel: 'Tips Mengatasi',
    accent: Color(0xFF3B82F6),
    cardColor: Color(0xFFEEF2FF),
    badgeColor: Color(0xFFC7D5FF),
    badgeTextColor: Color(0xFF1A237E),
    titleColor: Color(0xFF0D1B6E),
    descColor: Color(0xFF1A3A9E),
    pillColor: Color(0xFFC7D5FF),
    pillTextColor: Color(0xFF0D1B6E),
    tipBoxColor: Color(0xFFD8E2FF),
  ),
  const SleepCondition(
    id: 'healthy',
    emoji: '✨',
    badge: 'TIDUR SEHAT',
    title: 'Pola Tidur Ideal',
    description:
        'Tidur sehat berarti kamu mendapatkan istirahat yang cukup dan berkualitas, bangun dalam kondisi segar, serta memiliki energi dan fokus penuh sepanjang hari.',
    symptoms: ['Tidur 7–9 jam', 'Bangun segar', 'Mood stabil', 'Fokus optimal', 'Energi penuh'],
    tip: 'Pertahankan jadwal tidur yang konsisten, olahraga rutin di pagi hari, dan ciptakan lingkungan tidur yang nyaman, gelap, dan sejuk.',
    tipLabel: 'Cara Mempertahankan',
    accent: Color(0xFF10B981),
    cardColor: Color(0xFFE8F8F2),
    badgeColor: Color(0xFFB2EDDA),
    badgeTextColor: Color(0xFF085041),
    titleColor: Color(0xFF064035),
    descColor: Color(0xFF0F6E56),
    pillColor: Color(0xFFB2EDDA),
    pillTextColor: Color(0xFF064035),
    tipBoxColor: Color(0xFFC5F0E0),
  ),
];