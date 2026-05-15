// lib/features/insight/presentation/widgets/insight_card.dart
import 'package:flutter/material.dart';
import '../../core/widgets/app_theme.dart';
import '../../models/insight_model.dart';
import '../../service/insight_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InsightCard extends StatefulWidget {
  const InsightCard({super.key,});

  @override
  State<InsightCard> createState() => _InsightCardState();
}

class _InsightCardState extends State<InsightCard> {
  final _service = InsightService();
  late Future<InsightModel?> _future;

   @override
  void initState() {
    super.initState();
    _future = _loadInsight();
  }
  Future<InsightModel?> _loadInsight() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('auth_token') ?? '';
  if (token.isEmpty) return null;
  try {
    return await _service.fetchInsight(token);
  } catch (e) {
    debugPrint('InsightCard error: $e');  
    return null;
  }
}

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: AppTheme.instance,
      builder: (context, isDark, _) {
        return FutureBuilder<InsightModel?>(
          future: _future,
          builder: (context, snapshot) {
            // Loading state
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildShimmer(isDark);
            }

            // Belum ada prediction
            if (!snapshot.hasData || snapshot.data == null) {
              return _buildEmpty(isDark);
            }

            final insight = snapshot.data!;
            return _buildCard(isDark, insight);
          },
        );
      },
    );
  }

  Widget _buildCard(bool isDark, InsightModel insight) {
    // Warna tetap sama seperti sebelumnya
    const blueDark  = Color(0xFF1D4E89);
    const blueMid   = Color(0xFF4D7AD4);
    const blueLight = Color(0xFFEAF3FF);

    final bg1         = isDark ? const Color(0xFF0F2744) : blueDark.withOpacity(0.10);
    final bg2         = isDark ? const Color(0xFF1A3A6B) : blueMid.withOpacity(0.12);
    final bg3         = isDark ? const Color(0xFF1E2D4A) : blueLight;
    final borderColor = isDark ? const Color(0xFF2E5299) : const Color(0xFFC7D9F8);
    final titleColor  = isDark ? const Color(0xFF93C5FD) : const Color(0xFF185FA5);
    final bodyColor   = isDark ? const Color(0xFFBFDBFE) : const Color(0xFF0C447C);
    final badgeBg     = isDark ? const Color(0xFF1E3A2E) : Colors.white.withOpacity(0.68);
    final badgeBorder = isDark ? const Color(0xFF2D6A3F) : const Color(0xFFB9D7C0);
    final badgeText   = isDark ? const Color(0xFF86EFAC) : const Color(0xFF27500A);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [bg1, bg2, bg3],
          stops: const [0.0, 0.45, 1.0],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: blueMid.withOpacity(isDark ? 0.20 : 0.10),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [blueDark, blueMid],
                  ),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: blueMid.withOpacity(0.24),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.lightbulb_outline_rounded,
                  color: Colors.white,
                  size: 15,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'INSIGHT HARI INI',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: titleColor,
                  letterSpacing: 0.7,
                ),
              ),
              const Spacer(),
              // Badge menampilkan label prediksi
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: badgeBg,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: badgeBorder, width: 0.8),
                ),
                child: Row(
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
                    Text(
                      insight.label, // ← dari API
                      style: TextStyle(
                        fontSize: 10,
                        color: badgeText,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            insight.description, // ← dari API
            style: TextStyle(
              fontSize: 14,
              color: bodyColor,
              height: 1.6,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmer(bool isDark) {
    // Placeholder saat loading — ukuran sama dengan card asli
    return Container(
      height: 110,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C1836) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }

  Widget _buildEmpty(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C1836) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? const Color(0xFF352F5A) : const Color(0xFFE2E8F0),
          width: 0.9,
        ),
      ),
      child: Text(
        'Belum ada insight. Lengkapi data tidur kamu untuk mendapatkan analisis.',
        style: TextStyle(
          fontSize: 13,
          color: isDark ? const Color(0xFF8B80C4) : const Color(0xFF94A3B8),
          height: 1.5,
        ),
      ),
    );
  }
}