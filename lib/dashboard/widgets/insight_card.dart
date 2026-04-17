import 'package:flutter/material.dart';

class InsightCard extends StatelessWidget {
  const InsightCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        // ✅ Background biru muda agar terlihat di atas putih
        color: const Color(0xFFEEF4FF),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFC7D9F8), // ✅ Border tipis biru
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4D7AD4).withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // ✅ Header: ikon + label + badge aktif
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: const Color(0xFF4D7AD4),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.lightbulb_outline_rounded,
                  color: Colors.white,
                  size: 15,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'INSIGHT HARI INI',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF185FA5),
                  letterSpacing: 0.5,
                ),
              ),
              const Spacer(),
              // ✅ Badge "Aktif" dengan dot hijau
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Color(0xFF4CAF50),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    'Aktif',
                    style: TextStyle(
                      fontSize: 10,
                      color: Color(0xFF27500A),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          // ✅ Teks insight dengan warna biru gelap (kontras di atas biru muda)
          const Text(
            'Ritme sirkadian Anda menunjukkan konsistensi tinggi. Pertahankan jadwal tidur ini untuk performa kognitif maksimal.',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF0C447C),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}