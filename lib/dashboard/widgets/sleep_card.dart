// lib/features/dashboard/widgets/sleep_card.dart
// ─── UPDATED: ambil data real dari API ────────────────────────────────────────

import 'package:flutter/material.dart';
import '../../core/widgets/app_theme.dart';
import '../../service/sleep_log_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../service/new_services.dart';

class _TokenStorage {
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }
}

// ─── SleepCard ────────────────────────────────────────────────────────────────
class SleepCard extends StatefulWidget {
  const SleepCard({super.key});

  @override
  State<SleepCard> createState() => _SleepCardState();
}

class _SleepCardState extends State<SleepCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fadeCtrl;
  late final Animation<double>   _fadeAnim;
  late final Animation<Offset>   _slideAnim;

  SleepLogEntry? _latest;
  bool           _loading = true;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );
    _fadeAnim  = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.04),
      end:   Offset.zero,
    ).animate(CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOutCubic));

    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  Future<void> _loadData() async {
    final token = await _TokenStorage.getToken();
    if (token == null) {
      if (mounted) setState(() => _loading = false);
      return;
    }
    final latest = await SleepLogService.fetchLatest(token: token);
    if (mounted) {
      setState(() { _latest = latest; _loading = false; });
      _fadeCtrl.forward();
    }
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const _SleepCardSkeleton();
    }
    return FadeTransition(
      opacity:  _fadeAnim,
      child: SlideTransition(
        position: _slideAnim,
        child: _SleepCardBody(entry: _latest),
      ),
    );
  }
}

// ── Skeleton loader ───────────────────────────────────────────────────────────
class _SleepCardSkeleton extends StatelessWidget {
  const _SleepCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: AppTheme.instance,
      builder: (_, isDark, __) => Container(
        height: 200,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1A1035) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark
                ? const Color(0xFF6D5FD8).withOpacity(0.35)
                : const Color(0xFF7C3AED).withOpacity(0.14),
            width: 0.8,
          ),
        ),
        child: Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: isDark
                ? const Color(0xFF9B6FFF)
                : const Color(0xFF7C3AED),
          ),
        ),
      ),
    );
  }
}

// ── Body ──────────────────────────────────────────────────────────────────────
class _SleepCardBody extends StatelessWidget {
  final SleepLogEntry? entry;
  const _SleepCardBody({this.entry});

  static const Color _violet     = Color(0xFF7C3AED);
  static const Color _indigo     = Color(0xFF4F46E5);
  static const Color _blue       = Color(0xFF4D7AD4);
  static const Color _darkViolet = Color(0xFF9B6FFF);
  static const Color _darkIndigo = Color(0xFF6D5FD8);

  // ── Estimasi sleep stages dari durasi & quality ───────────────────────
  // quality 1-5 → porsi Dalam & REM berbeda
  // Hasil: [lightFlex, deepFlex, remFlex, transitFlex]
  List<int> _estimateStages(int durationMinutes, int quality) {
    // Semakin tinggi quality, semakin banyak deep & REM
    // quality 1 → deep 15%, REM 15%
    // quality 5 → deep 35%, REM 25%
    final deepPct  = 0.15 + (quality - 1) * 0.05;   // 15%–35%
    final remPct   = 0.15 + (quality - 1) * 0.025;  // 15%–25%
    final lightPct = 0.35 - (quality - 1) * 0.02;   // 35%–27%
    // sisa = transisi/awake

    final deep   = (durationMinutes * deepPct).round();
    final rem    = (durationMinutes * remPct).round();
    final light  = (durationMinutes * lightPct).round();
    final transit = durationMinutes - deep - rem - light;

    // Kembalikan sebagai flex ratio (diperkecil ke 1-6 range)
    final total = deep + rem + light + transit;
    if (total == 0) return [2, 2, 2, 1];

    return [
      ((light   / total) * 10).round().clamp(1, 6),
      ((deep    / total) * 10).round().clamp(1, 6),
      ((rem     / total) * 10).round().clamp(1, 6),
      ((transit / total) * 10).round().clamp(1, 3),
    ];
  }

  // ── Kualitas label & warna ────────────────────────────────────────────
  String _qualityLabel(int quality) {
    switch (quality) {
      case 1: return 'Sangat Buruk';
      case 2: return 'Buruk';
      case 3: return 'Cukup';
      case 4: return 'Baik';
      case 5: return 'Excellent';
      default: return '-';
    }
  }

  // Quality → skor 0-100 untuk ditampilkan
  int _qualityScore(int quality) => quality * 20 - 10; // 1→10, 5→90 ...
  // atau lebih natural: 1→20, 2→40, 3→60, 4→80, 5→96
  int _qualityScoreNice(int quality) {
    const scores = [20, 42, 63, 80, 96];
    if (quality < 1 || quality > 5) return 0;
    return scores[quality - 1];
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: AppTheme.instance,
      builder: (context, isDark, _) {
        final primaryText   = isDark ? const Color(0xFFF1F5F9) : const Color(0xFF0F172A);
        final secondaryText = isDark ? const Color(0xFFBBA8F8) : const Color(0xFF64748B);
        final mutedText     = isDark ? const Color(0xFF7C6EDE) : const Color(0xFF94A3B8);
        final scoreLabel    = isDark ? const Color(0xFFBBA8F8) : const Color(0xFF475569);
        final legendColor   = isDark ? const Color(0xFFBBA8F8) : const Color(0xFF6B7280);
        final dividerColor  = isDark
            ? const Color(0xFF4F46E5).withOpacity(0.25)
            : _violet.withOpacity(0.10);
        final barInactive1  = isDark ? const Color(0xFF2D1B69) : const Color(0xFFE2E8F0);
        final barInactive2  = isDark ? const Color(0xFF3B2A8A) : const Color(0xFFCBD5E1);

        final cardBg1     = isDark ? const Color(0xFF1A1035) : Colors.white.withOpacity(0.92);
        final cardBg2     = isDark ? const Color(0xFF1E1A40) : const Color(0xFFF7F8FF);
        final cardBg3     = isDark ? const Color(0xFF14102A) : const Color(0xFFF4F0FF);
        final borderColor = isDark
            ? const Color(0xFF6D5FD8).withOpacity(0.35)
            : _violet.withOpacity(0.14);
        final shadowColor = isDark
            ? const Color(0xFF4F46E5).withOpacity(0.22)
            : const Color(0xFF312E81).withOpacity(0.08);
        final badgeBg     = isDark
            ? const Color(0xFF2D1B69).withOpacity(0.60)
            : const Color(0xFFEEF2FF);
        final badgeBorder = isDark
            ? const Color(0xFF6D5FD8).withOpacity(0.50)
            : _violet.withOpacity(0.18);
        final badgeText   = isDark ? const Color(0xFFBBA8F8) : const Color(0xFF5B21B6);

        // ── Data: pakai entry jika ada, fallback ke placeholder ───────
        final hasData     = entry != null;
        final durationStr = hasData ? entry!.durationDisplay : '--';
        final timeRange   = hasData ? entry!.timeRange        : '-- : -- - -- : --';
        final quality     = hasData ? entry!.quality          : 0;
        final qualityStr  = hasData ? _qualityLabel(quality)  : 'Belum Ada Data';
        final scoreStr    = hasData
            ? '${_qualityScoreNice(quality)}%'
            : '--%';
        final stages      = hasData
            ? _estimateStages(entry!.duration, quality)
            : [2, 2, 2, 1];

        // Parse durasi untuk display besar
        final durH = hasData ? (entry!.duration ~/ 60).toString() : '--';
        final durM = hasData ? (entry!.duration % 60).toString()  : '--';

        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin:  Alignment.topLeft,
              end:    Alignment.bottomRight,
              colors: [cardBg1, cardBg2, cardBg3],
              stops:  const [0.0, 0.55, 1.0],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: borderColor, width: 0.8),
            boxShadow: [
              BoxShadow(
                  color: shadowColor,
                  blurRadius: isDark ? 28 : 22,
                  offset: const Offset(0, 10)),
              if (isDark)
                BoxShadow(
                    color: const Color(0xFF4F46E5).withOpacity(0.10),
                    blurRadius: 48,
                    offset: const Offset(0, 24)),
            ],
          ),
          child: Stack(children: [
            if (isDark)
              Positioned(
                top: -30, right: -30,
                child: Container(
                  width: 100, height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF6D5FD8).withOpacity(0.12),
                  ),
                ),
              ),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

              // ── Header ────────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: [
                    Container(
                      width: 22, height: 22,
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF4F46E5).withOpacity(0.22)
                            : const Color(0xFFEEF2FF),
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Icon(Icons.dark_mode_rounded, size: 13,
                          color: isDark ? _darkViolet : _violet),
                    ),
                    const SizedBox(width: 8),
                    Text('TIDUR SEMALAM',
                        style: TextStyle(
                          fontSize: 11, fontWeight: FontWeight.w700,
                          letterSpacing: 1, color: secondaryText,
                        )),
                  ]),
                  // Badge kualitas
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [badgeBg, badgeBg.withOpacity(0.80)]),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: badgeBorder, width: 0.8),
                      boxShadow: isDark
                          ? [BoxShadow(
                              color: const Color(0xFF4F46E5).withOpacity(0.18),
                              blurRadius: 8, offset: const Offset(0, 2))]
                          : null,
                    ),
                    child: Row(children: [
                      Container(
                        width: 6, height: 6,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: isDark
                                ? [_darkViolet, _darkIndigo]
                                : [_violet, _blue],
                          ),
                          boxShadow: [BoxShadow(
                            color: (isDark ? _darkViolet : _violet)
                                .withOpacity(0.40),
                            blurRadius: 4, offset: const Offset(0, 1),
                          )],
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(qualityStr,
                          style: TextStyle(
                            fontSize: 11, fontWeight: FontWeight.w700,
                            color: badgeText,
                          )),
                    ]),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // ── Durasi ────────────────────────────────────────────
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(durH, style: TextStyle(
                      fontSize: 38, fontWeight: FontWeight.w800,
                      color: primaryText, height: 1, letterSpacing: -1.2)),
                  Text('j ', style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600,
                      color: secondaryText)),
                  Text(durM, style: TextStyle(
                      fontSize: 38, fontWeight: FontWeight.w800,
                      color: primaryText, height: 1, letterSpacing: -1.2)),
                  Text('m', style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600,
                      color: secondaryText)),
                ],
              ),
              const SizedBox(height: 3),
              Text(timeRange,
                  style: TextStyle(
                      fontSize: 11, fontWeight: FontWeight.w500,
                      color: mutedText)),

              const SizedBox(height: 12),

              // ── Sleep Stages Bar (estimasi) ───────────────────────
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Row(children: [
                  Expanded(flex: stages[0], child: _buildStage(
                      isDark ? const Color(0xFF6D5FD8).withOpacity(0.55)
                              : _violet.withOpacity(0.34))),
                  const SizedBox(width: 3),
                  Expanded(flex: stages[1], child: _buildStage(
                      isDark ? const Color(0xFF5B4DC8).withOpacity(0.75)
                              : _indigo.withOpacity(0.46))),
                  const SizedBox(width: 3),
                  Expanded(flex: stages[2], child: _buildStage(
                      isDark ? const Color(0xFF4D7AD4).withOpacity(0.80)
                              : _blue.withOpacity(0.56))),
                  const SizedBox(width: 3),
                  Expanded(flex: stages[3], child: _buildStage(
                      isDark ? const Color(0xFF6D5FD8).withOpacity(0.30)
                              : _violet.withOpacity(0.15))),
                ]),
              ),
              const SizedBox(height: 8),

              // ── Legend ────────────────────────────────────────────
              Row(children: [
                _buildLegend(
                    isDark ? const Color(0xFF9B6FFF) : _violet.withOpacity(0.68),
                    'Ringan', legendColor),
                const SizedBox(width: 14),
                _buildLegend(
                    isDark ? const Color(0xFF6D5FD8) : _indigo.withOpacity(0.74),
                    'Dalam', legendColor),
                const SizedBox(width: 14),
                _buildLegend(
                    isDark ? const Color(0xFF4D7AD4) : _blue.withOpacity(0.74),
                    'REM', legendColor),
                const SizedBox(width: 14),
                Text('*estimasi',
                    style: TextStyle(
                        fontSize: 9.5,
                        color: mutedText,
                        fontStyle: FontStyle.italic)),
              ]),

              const SizedBox(height: 12),
              Divider(color: dividerColor, thickness: 0.7, height: 0),
              const SizedBox(height: 12),

              // ── Skor ─────────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Kualitas Skor',
                        style: TextStyle(fontSize: 13,
                            color: scoreLabel, fontWeight: FontWeight.w500)),
                    ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        colors: isDark
                            ? [_darkViolet, _darkIndigo]
                            : [_blue, _violet],
                      ).createShader(bounds),
                      child: Text(scoreStr,
                          style: const TextStyle(
                            fontSize: 26, fontWeight: FontWeight.w800,
                            color: Colors.white, height: 1.1,
                            letterSpacing: -0.5,
                          )),
                    ),
                  ]),
                  // Bar chart 5 hari (dari stars)
                  if (hasData)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _buildBar(quality >= 1 ? quality / 5.0 : 0.1,
                            false, barInactive1, barInactive2, isDark),
                        const SizedBox(width: 4),
                        _buildBar(quality >= 2 ? quality / 5.0 * 0.8 : 0.2,
                            false, barInactive1, barInactive2, isDark),
                        const SizedBox(width: 4),
                        _buildBar(quality >= 3 ? quality / 5.0 * 0.9 : 0.3,
                            false, barInactive1, barInactive2, isDark),
                        const SizedBox(width: 4),
                        _buildBar(quality / 5.0 * 0.95,
                            false, barInactive1, barInactive2, isDark),
                        const SizedBox(width: 4),
                        _buildBar(1.0, true, barInactive1, barInactive2, isDark),
                      ],
                    )
                  else
                    Text('Belum ada\ndata tidur',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            fontSize: 11, color: mutedText, height: 1.5)),
                ],
              ),
            ]),
          ]),
        );
      },
    );
  }

  Widget _buildStage(Color color) => Container(
        height: 6,
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(4)),
      );

  Widget _buildLegend(Color color, String label, Color textColor) => Row(
        children: [
          Container(
            width: 7, height: 7,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
              boxShadow: [BoxShadow(
                  color: color.withOpacity(0.30), blurRadius: 4,
                  offset: const Offset(0, 1))],
            ),
          ),
          const SizedBox(width: 4),
          Text(label,
              style: TextStyle(
                  fontSize: 11, color: textColor,
                  fontWeight: FontWeight.w500)),
        ],
      );

  Widget _buildBar(double heightFactor, bool isActive,
      Color inactive1, Color inactive2, bool isDark) =>
      Container(
        width: 8,
        height: 32.0 * heightFactor.clamp(0.1, 1.0),
        decoration: BoxDecoration(
          gradient: isActive
              ? LinearGradient(
                  begin: Alignment.topCenter,
                  end:   Alignment.bottomCenter,
                  colors: isDark
                      ? [const Color(0xFF9B6FFF), const Color(0xFF4F46E5)]
                      : [const Color(0xFF7C3AED), const Color(0xFF4D7AD4)],
                )
              : LinearGradient(
                  begin: Alignment.topCenter,
                  end:   Alignment.bottomCenter,
                  colors: [inactive1, inactive2.withOpacity(0.85)],
                ),
          borderRadius: BorderRadius.circular(4),
          boxShadow: isActive
              ? [BoxShadow(
                  color: (isDark
                      ? const Color(0xFF9B6FFF)
                      : const Color(0xFF7C3AED)).withOpacity(0.30),
                  blurRadius: 8, offset: const Offset(0, 3))]
              : null,
        ),
      );
}

// ─── SleepGoalCard ────────────────────────────────────────────────────────────

class SleepGoalCard extends StatefulWidget {
  const SleepGoalCard({super.key});

  @override
  State<SleepGoalCard> createState() => _SleepGoalCardState();
}

class _SleepGoalCardState extends State<SleepGoalCard> {
  Map<String, dynamic>? _sleepGoal;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadSleepGoal();
  }

Future<void> _loadSleepGoal() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('auth_token');
  
  debugPrint('=== SleepGoalCard: token=$token');
  
  if (token == null) {
    if (mounted) setState(() => _loading = false);
    return;
  }

  final sleepGoal = await SleepGoalService.fetchSleepGoal(token: token);
  
  debugPrint('=== SleepGoalCard: sleepGoal=$sleepGoal'); // ← PALING PENTING
  
  if (mounted) {
    setState(() {
      _sleepGoal = sleepGoal;
      _loading = false;
    });
  }
}

  // ── Hitung sisa waktu ke jam tidur ────────────────────────────────────
  String _timeUntilBed(String bedTime) {
    final parts = bedTime.split(':');
    if (parts.length != 2) return '';
    final bh = int.tryParse(parts[0]) ?? 0;
    final bm = int.tryParse(parts[1]) ?? 0;

    final now  = DateTime.now();
    var   bed  = DateTime(now.year, now.month, now.day, bh, bm);
    if (bed.isBefore(now)) bed = bed.add(const Duration(days: 1));

    final diff = bed.difference(now);
    final h    = diff.inHours;
    final m    = diff.inMinutes % 60;

    if (h == 0) return '${m}m lagi';
    if (m == 0) return '${h}j lagi';
    return '${h}j ${m}m lagi';
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: AppTheme.instance,
      builder: (context, isDark, _) {
        if (_loading) {
          return Container(
            height: 80,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0E1F2A) : const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(child: SizedBox(
              width: 18, height: 18,
              child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: isDark
                      ? const Color(0xFF38BDF8)
                      : const Color(0xFF2563EB)),
            )),
          );
        }

        if (_sleepGoal == null) {
          return _NoGoalCard(isDark: isDark);
        }

        final bedTime  = _sleepGoal!['bed_time']  as String? ?? '--:--';
        final wakeTime = _sleepGoal!['wake_time'] as String? ?? '--:--';;
        final hours    = (_sleepGoal!['target_hours'] as num?)?.toDouble() ?? 8.0;
        final hoursStr = hours == hours.roundToDouble()
            ? '${hours.toInt()}j'
            : '${hours}j';
        final countdown = _timeUntilBed(bedTime);

        // Warna biru untuk goal card (berbeda dari SleepCard yg ungu)
        final bg1        = isDark ? const Color(0xFF0F2744) : const Color(0xFFEFF6FF);
        final bg2        = isDark ? const Color(0xFF1A3A6B) : const Color(0xFFDBEAFE);
        final borderClr  = isDark ? const Color(0xFF2E5299) : const Color(0xFFBFDBFE);
        final titleClr   = isDark ? const Color(0xFF93C5FD) : const Color(0xFF1D4ED8);
        final valueClr   = isDark ? const Color(0xFFBFDBFE) : const Color(0xFF1E40AF);
        final mutedClr   = isDark ? const Color(0xFF60A5FA) : const Color(0xFF3B82F6);
        final badgeBg    = isDark ? const Color(0xFF1E3A5F) : Colors.white;
        final badgeBorder= isDark ? const Color(0xFF2563EB).withOpacity(0.5)
                                  : const Color(0xFF93C5FD);

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end:   Alignment.bottomRight,
              colors: [bg1, bg2],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderClr, width: 0.9),
            boxShadow: [BoxShadow(
              color: const Color(0xFF2563EB).withOpacity(isDark ? 0.18 : 0.08),
              blurRadius: 16, offset: const Offset(0, 6),
            )],
          ),
          child: Row(children: [
            // Icon
            Container(
              width: 44, height: 44,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end:   Alignment.bottomRight,
                  colors: [Color(0xFF1D4ED8), Color(0xFF2563EB)],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(
                  color: const Color(0xFF2563EB).withOpacity(0.30),
                  blurRadius: 8, offset: const Offset(0, 3),
                )],
              ),
              child: const Icon(Icons.flag_rounded,
                  color: Colors.white, size: 22),
            ),
            const SizedBox(width: 14),

            // Label
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('TARGET MALAM INI',
                      style: TextStyle(
                        fontSize: 10, fontWeight: FontWeight.w800,
                        letterSpacing: 0.6, color: titleClr,
                      )),
                  const SizedBox(height: 4),
                  Row(children: [
                    Icon(Icons.nightlight_round, size: 13, color: mutedClr),
                    const SizedBox(width: 4),
                    Text('$bedTime  →  $wakeTime',
                        style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w700,
                          color: valueClr,
                        )),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: badgeBg,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: badgeBorder, width: 0.8),
                      ),
                      child: Text(hoursStr,
                          style: TextStyle(
                            fontSize: 11, fontWeight: FontWeight.w700,
                            color: titleClr,
                          )),
                    ),
                  ]),
                ],
              ),
            ),

            // Countdown
            if (countdown.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Icon(Icons.access_time_rounded, size: 13, color: mutedClr),
                  const SizedBox(height: 2),
                  Text(countdown,
                      style: TextStyle(
                        fontSize: 11, fontWeight: FontWeight.w700,
                        color: titleClr,
                      )),
                ],
              ),
          ]),
        );
      },
    );
  }
}

// ── Card jika belum set sleep goal ────────────────────────────────────────────
class _NoGoalCard extends StatelessWidget {
  final bool isDark;
  const _NoGoalCard({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final bg     = isDark ? const Color(0xFF1A1A2E) : const Color(0xFFF8FAFC);
    final border = isDark ? const Color(0xFF352F5A) : const Color(0xFFE2E8F0);
    final clr    = isDark ? const Color(0xFF6B5FC4) : const Color(0xFF94A3B8);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border, width: 0.9),
      ),
      child: Row(children: [
        Icon(Icons.flag_outlined, size: 20, color: clr),
        const SizedBox(width: 12),
        Expanded(child: Text('Belum ada target tidur. Set di Profil → Tujuan Tidur.',
            style: TextStyle(fontSize: 12.5, color: clr,
                fontWeight: FontWeight.w500))),
      ]),
    );
  }
}