// lib/features/sleep_log/sleep_log_screen.dart

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/widgets/app_theme.dart';
import '../service/sleep_log_service.dart';

class _TokenStorage {
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }
}

class SleepLogScreen extends StatefulWidget {
  const SleepLogScreen({super.key});

  @override
  State<SleepLogScreen> createState() => _SleepLogScreenState();
}

class _SleepLogScreenState extends State<SleepLogScreen> {
  // ── State Form ────────────────────────────────────────────────────────
  DateTime  _selectedDate = DateTime.now();
  TimeOfDay _bedTime      = const TimeOfDay(hour: 22, minute: 0);
  TimeOfDay _wakeTime     = const TimeOfDay(hour: 6,  minute: 0);
  int       _quality      = 3;
  final _notesCtrl        = TextEditingController();

  bool    _isLoading = false;
  String? _errorMsg;

  // ── List riwayat log ──────────────────────────────────────────────────
  List<SleepLogEntry> _logs       = [];
  bool                _logsLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLogs();
  }

  @override
  void dispose() {
    _notesCtrl.dispose();
    super.dispose();
  }

  // ── Durasi otomatis ───────────────────────────────────────────────────
  String get _durationDisplay {
    final bedMins  = _bedTime.hour * 60  + _bedTime.minute;
    var   wakeMins = _wakeTime.hour * 60 + _wakeTime.minute;
    if (wakeMins <= bedMins) wakeMins += 24 * 60;
    final diff = wakeMins - bedMins;
    final h = diff ~/ 60;
    final m = diff % 60;
    return m == 0 ? '${h}j' : '${h}j ${m}m';
  }

  // ── Tanggal format ────────────────────────────────────────────────────
  String get _dateDisplay {
    final now = DateTime.now();
    if (_selectedDate.year == now.year &&
        _selectedDate.month == now.month &&
        _selectedDate.day == now.day) {
      return 'Hari Ini';
    }
    final yesterday = now.subtract(const Duration(days: 1));
    if (_selectedDate.year == yesterday.year &&
        _selectedDate.month == yesterday.month &&
        _selectedDate.day == yesterday.day) {
      return 'Kemarin';
    }
    return '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}';
  }

  String get _dateForApi =>
      '${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}';

  String _timeStr(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  // ── Load riwayat ──────────────────────────────────────────────────────
  Future<void> _loadLogs() async {
    setState(() => _logsLoading = true);
    final token = await _TokenStorage.getToken();
    if (token == null) { setState(() => _logsLoading = false); return; }

    final logs = await SleepLogService.fetchAll(token: token, limit: 10);
    if (mounted) setState(() { _logs = logs; _logsLoading = false; });
  }

  // ── Time Picker ───────────────────────────────────────────────────────
  Future<void> _pickTime({
    required TimeOfDay initial,
    required ValueChanged<TimeOfDay> onPicked,
  }) async {
    final picked = await showTimePicker(
      context:     context,
      initialTime: initial,
      builder: (ctx, child) => MediaQuery(
        data: MediaQuery.of(ctx).copyWith(alwaysUse24HourFormat: false),
        child: child!,
      ),
    );
    if (picked != null) onPicked(picked);
  }

  // ── Date Picker ───────────────────────────────────────────────────────
  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context:      context,
      initialDate:  _selectedDate,
      firstDate:    DateTime.now().subtract(const Duration(days: 30)),
      lastDate:     DateTime.now(),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  // ── Save ──────────────────────────────────────────────────────────────
  Future<void> _handleSave() async {
    setState(() { _isLoading = true; _errorMsg = null; });

    final token = await _TokenStorage.getToken();
    if (token == null) {
      setState(() { _isLoading = false; _errorMsg = 'Sesi tidak valid. Silakan login ulang.'; });
      return;
    }

    final result = await SleepLogService.create(
      token:    token,
      date:     _dateForApi,
      bedTime:  _timeStr(_bedTime),
      wakeTime: _timeStr(_wakeTime),
      quality:  _quality,
      notes:    _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (result.success) {
      _notesCtrl.clear();
      setState(() => _quality = 3);
      _showSnackBar(result.message, isError: false);
      _loadLogs(); // refresh list
    } else {
      setState(() => _errorMsg = result.message);
    }
  }

  // ── Delete ────────────────────────────────────────────────────────────
  Future<void> _handleDelete(SleepLogEntry log) async {
    final token = await _TokenStorage.getToken();
    if (token == null) return;

    final result = await SleepLogService.delete(token: token, id: log.id);
    if (!mounted) return;

    if (result.success) {
      _showSnackBar(result.message, isError: false);
      _loadLogs();
    } else {
      _showSnackBar(result.message, isError: true);
    }
  }

  void _showSnackBar(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(children: [
        Icon(
          isError ? Icons.error_outline_rounded : Icons.check_circle_outline_rounded,
          color: Colors.white, size: 18,
        ),
        const SizedBox(width: 10),
        Expanded(child: Text(message,
            style: const TextStyle(fontWeight: FontWeight.w500))),
      ]),
      backgroundColor: isError ? const Color(0xFFE11D48) : const Color(0xFF16A34A),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 3),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: AppTheme.instance,
      builder: (context, isDark, _) {
        final bg       = isDark ? const Color(0xFF0F0D1F) : const Color(0xFFF8FAFC);
        final appBarBg = isDark ? const Color(0xFF13112A) : Colors.white;
        final titleClr = isDark ? const Color(0xFFF1F5F9) : const Color(0xFF0F172A);
        final iconClr  = isDark ? const Color(0xFF8B80C4) : const Color(0xFF64748B);
        final divClr   = isDark ? const Color(0xFF252040) : const Color(0xFFE2E8F0);

        return Scaffold(
          backgroundColor: bg,
          appBar: AppBar(
            backgroundColor: appBarBg,
            elevation: 0,
            scrolledUnderElevation: 0,
            leading: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1C1836) : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(10),
                  border: isDark
                      ? Border.all(color: const Color(0xFF352F5A), width: 0.8)
                      : null,
                ),
                child: Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: iconClr),
              ),
            ),
            title: Text('Log Tidur',
                style: TextStyle(
                    fontSize: 17, fontWeight: FontWeight.w700,
                    color: titleClr, letterSpacing: -0.3)),
            centerTitle: true,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(0.6),
              child: Divider(height: 0, thickness: 0.6, color: divClr),
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.symmetric(vertical: 24),
            children: [
              // ── Error Banner ─────────────────────────────────────────
              if (_errorMsg != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                  child: _ErrorBanner(message: _errorMsg!, isDark: isDark),
                ),

              // ── Section: Form Input ───────────────────────────────────
              _SectionHeader(label: 'Catat Tidur Baru', isDark: isDark),
              _Card(
                isDark: isDark,
                child: Column(children: [

                  // Tanggal
                  _TapItem(
                    icon: Icons.calendar_today_rounded,
                    iconColor: const Color(0xFF7C3AED),
                    iconBg: const Color(0xFFF5F3FF),
                    label: 'Tanggal',
                    value: _dateDisplay,
                    isDark: isDark,
                    showDivider: true,
                    onTap: _pickDate,
                  ),

                  // Jam Tidur
                  _TapItem(
                    icon: Icons.nightlight_round,
                    iconColor: const Color(0xFF4F46E5),
                    iconBg: const Color(0xFFEEF2FF),
                    label: 'Jam Tidur',
                    value: _timeStr(_bedTime),
                    isDark: isDark,
                    showDivider: true,
                    onTap: () => _pickTime(
                      initial: _bedTime,
                      onPicked: (t) => setState(() => _bedTime = t),
                    ),
                  ),

                  // Jam Bangun
                  _TapItem(
                    icon: Icons.wb_sunny_outlined,
                    iconColor: const Color(0xFFD97706),
                    iconBg: const Color(0xFFFFFBEB),
                    label: 'Jam Bangun',
                    value: _timeStr(_wakeTime),
                    isDark: isDark,
                    showDivider: true,
                    onTap: () => _pickTime(
                      initial: _wakeTime,
                      onPicked: (t) => setState(() => _wakeTime = t),
                    ),
                  ),

                  // Durasi (info)
                  _InfoItem(
                    icon: Icons.timelapse_rounded,
                    iconColor: const Color(0xFF16A34A),
                    iconBg: const Color(0xFFF0FDF4),
                    label: 'Durasi',
                    value: _durationDisplay,
                    isDark: isDark,
                    showDivider: true,
                  ),

                  // Kualitas tidur
                  _QualityItem(
                    quality: _quality,
                    isDark:  isDark,
                    onChanged: (v) => setState(() => _quality = v),
                  ),
                ]),
              ),

              const SizedBox(height: 8),

              // ── Section: Catatan ──────────────────────────────────────
              _SectionHeader(label: 'Catatan (Opsional)', isDark: isDark),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1C1836) : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark
                          ? const Color(0xFF352F5A)
                          : const Color(0xFFE2E8F0),
                      width: 0.9,
                    ),
                  ),
                  child: TextField(
                    controller: _notesCtrl,
                    maxLines: 3,
                    maxLength: 500,
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark
                          ? const Color(0xFFF1F5F9)
                          : const Color(0xFF0F172A),
                    ),
                    decoration: InputDecoration(
                      hintText: 'Mimpi, perasaan, atau catatan lainnya...',
                      hintStyle: TextStyle(
                        color: isDark
                            ? const Color(0xFF6B5FC4)
                            : const Color(0xFF94A3B8),
                        fontSize: 13,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(16),
                      counterStyle: TextStyle(
                        color: isDark
                            ? const Color(0xFF6B5FC4)
                            : const Color(0xFF94A3B8),
                        fontSize: 11,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // ── Tombol Simpan ─────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleSave,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7C3AED),
                      disabledBackgroundColor:
                          const Color(0xFF7C3AED).withOpacity(0.6),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 20, height: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white))
                        : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.save_outlined, size: 18),
                              SizedBox(width: 8),
                              Text('Simpan Log Tidur',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700)),
                            ],
                          ),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // ── Section: Riwayat ──────────────────────────────────────
              _SectionHeader(label: 'Riwayat 10 Terakhir', isDark: isDark),
              if (_logsLoading)
                const Center(
                    child: Padding(
                  padding: EdgeInsets.all(24),
                  child: CircularProgressIndicator(),
                ))
              else if (_logs.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _EmptyState(isDark: isDark),
                )
              else
                ...(_logs.map((log) => Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                      child: _LogItem(
                        log:    log,
                        isDark: isDark,
                        onDelete: () => _confirmDelete(log),
                      ),
                    ))),

              const SizedBox(height: 40),
            ],
          ),
        );
      },
    );
  }

  Future<void> _confirmDelete(SleepLogEntry log) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Log?'),
        content: Text('Log tidur ${log.date} akan dihapus.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Batal')),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Hapus',
                  style: TextStyle(color: Color(0xFFE11D48)))),
        ],
      ),
    );
    if (confirmed == true) _handleDelete(log);
  }
}

// ─── Widgets ─────────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String label;
  final bool isDark;
  const _SectionHeader({required this.label, required this.isDark});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 10),
        child: Text(label.toUpperCase(),
            style: TextStyle(
              fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.8,
              color: isDark
                  ? const Color(0xFF6B5FC4)
                  : const Color(0xFF94A3B8),
            )),
      );
}

class _Card extends StatelessWidget {
  final bool isDark;
  final Widget child;
  const _Card({required this.isDark, required this.child});

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          gradient: isDark
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF1C1836), Color(0xFF13112A)],
                )
              : null,
          color: isDark ? null : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark
                ? const Color(0xFF352F5A)
                : const Color(0xFFE2E8F0),
            width: 0.9,
          ),
          boxShadow: isDark
              ? [
                  BoxShadow(
                      color: const Color(0xFF4F46E5).withOpacity(0.10),
                      blurRadius: 20, offset: const Offset(0, 6)),
                ]
              : [
                  BoxShadow(
                      color: const Color(0xFF0F172A).withOpacity(0.05),
                      blurRadius: 16, offset: const Offset(0, 4)),
                ],
        ),
        child: child,
      );
}

class _TapItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String label;
  final String value;
  final bool isDark;
  final bool showDivider;
  final VoidCallback onTap;

  const _TapItem({
    required this.icon, required this.iconColor, required this.iconBg,
    required this.label, required this.value, required this.isDark,
    required this.showDivider, required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedIconBg = isDark ? iconColor.withOpacity(0.18) : iconBg;
    return Column(children: [
      InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(children: [
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                color: resolvedIconBg,
                borderRadius: BorderRadius.circular(12),
                border: isDark
                    ? Border.all(color: iconColor.withOpacity(0.28), width: 0.9)
                    : null,
              ),
              child: Icon(icon, size: 20, color: iconColor),
            ),
            const SizedBox(width: 14),
            Expanded(child: Text(label,
                style: TextStyle(
                  fontSize: 14, fontWeight: FontWeight.w600,
                  color: isDark
                      ? const Color(0xFFF1F5F9)
                      : const Color(0xFF0F172A),
                ))),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(isDark ? 0.18 : 0.08),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: iconColor.withOpacity(0.30), width: 0.8),
              ),
              child: Text(value,
                  style: TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w700,
                    color: iconColor,
                  )),
            ),
          ]),
        ),
      ),
      if (showDivider)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Divider(height: 0, thickness: 0.6,
              color: isDark
                  ? const Color(0xFF252040)
                  : const Color(0xFFF1F5F9)),
        ),
    ]);
  }
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String label;
  final String value;
  final bool isDark;
  final bool showDivider;

  const _InfoItem({
    required this.icon, required this.iconColor, required this.iconBg,
    required this.label, required this.value, required this.isDark,
    required this.showDivider,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedIconBg = isDark ? iconColor.withOpacity(0.18) : iconBg;
    return Column(children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              color: resolvedIconBg,
              borderRadius: BorderRadius.circular(12),
              border: isDark
                  ? Border.all(color: iconColor.withOpacity(0.28), width: 0.9)
                  : null,
            ),
            child: Icon(icon, size: 20, color: iconColor),
          ),
          const SizedBox(width: 14),
          Expanded(child: Text(label,
              style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.w600,
                color: isDark
                    ? const Color(0xFFF1F5F9)
                    : const Color(0xFF0F172A),
              ))),
          Text(value,
              style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.w700,
                color: iconColor,
              )),
        ]),
      ),
      if (showDivider)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Divider(height: 0, thickness: 0.6,
              color: isDark
                  ? const Color(0xFF252040)
                  : const Color(0xFFF1F5F9)),
        ),
    ]);
  }
}

class _QualityItem extends StatelessWidget {
  final int quality;
  final bool isDark;
  final ValueChanged<int> onChanged;

  const _QualityItem({
    required this.quality, required this.isDark, required this.onChanged,
  });

  static const _labels = ['Sangat Buruk', 'Buruk', 'Cukup', 'Baik', 'Sangat Baik'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFFD97706).withOpacity(0.18)
                  : const Color(0xFFFFFBEB),
              borderRadius: BorderRadius.circular(12),
              border: isDark
                  ? Border.all(
                      color: const Color(0xFFD97706).withOpacity(0.28),
                      width: 0.9)
                  : null,
            ),
            child: const Icon(Icons.star_rounded,
                size: 20, color: Color(0xFFD97706)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Kualitas Tidur',
                  style: TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w600,
                    color: isDark
                        ? const Color(0xFFF1F5F9)
                        : const Color(0xFF0F172A),
                  )),
              Text(_labels[quality - 1],
                  style: TextStyle(
                    fontSize: 11.5,
                    color: isDark
                        ? const Color(0xFF8B80C4)
                        : const Color(0xFF94A3B8),
                  )),
            ]),
          ),
        ]),
        const SizedBox(height: 12),
        Row(mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (i) {
              final star = i + 1;
              return GestureDetector(
                onTap: () => onChanged(star),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Icon(
                    star <= quality
                        ? Icons.star_rounded
                        : Icons.star_outline_rounded,
                    size: 36,
                    color: star <= quality
                        ? const Color(0xFFD97706)
                        : isDark
                            ? const Color(0xFF352F5A)
                            : const Color(0xFFE2E8F0),
                  ),
                ),
              );
            })),
      ]),
    );
  }
}

class _LogItem extends StatelessWidget {
  final SleepLogEntry log;
  final bool isDark;
  final VoidCallback onDelete;

  const _LogItem({
    required this.log, required this.isDark, required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C1836) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF352F5A) : const Color(0xFFE2E8F0),
          width: 0.9,
        ),
      ),
      child: Row(children: [
        // Kualitas bintang
        Column(children: [
          ...List.generate(5, (i) => Icon(
            i < log.quality
                ? Icons.star_rounded
                : Icons.star_outline_rounded,
            size: 12,
            color: i < log.quality
                ? const Color(0xFFD97706)
                : isDark
                    ? const Color(0xFF352F5A)
                    : const Color(0xFFE2E8F0),
          )),
        ]),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(log.date,
                style: TextStyle(
                  fontSize: 12, fontWeight: FontWeight.w600,
                  color: isDark
                      ? const Color(0xFF8B80C4)
                      : const Color(0xFF64748B),
                )),
            const SizedBox(height: 2),
            Text(log.timeRange,
                style: TextStyle(
                  fontSize: 14, fontWeight: FontWeight.w700,
                  color: isDark
                      ? const Color(0xFFF1F5F9)
                      : const Color(0xFF0F172A),
                )),
            if (log.notes != null && log.notes!.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(log.notes!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11.5,
                    color: isDark
                        ? const Color(0xFF6B5FC4)
                        : const Color(0xFF94A3B8),
                  )),
            ],
          ]),
        ),
        // Durasi badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFF7C3AED).withOpacity(isDark ? 0.18 : 0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: const Color(0xFF7C3AED).withOpacity(0.30), width: 0.8),
          ),
          child: Text(log.durationDisplay,
              style: const TextStyle(
                fontSize: 12, fontWeight: FontWeight.w700,
                color: Color(0xFF7C3AED),
              )),
        ),
        const SizedBox(width: 8),
        // Hapus
        GestureDetector(
          onTap: onDelete,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFE11D48).withOpacity(isDark ? 0.15 : 0.06),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.delete_outline_rounded,
                size: 16, color: Color(0xFFE11D48)),
          ),
        ),
      ]),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final bool isDark;
  const _EmptyState({required this.isDark});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1C1836) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? const Color(0xFF352F5A) : const Color(0xFFE2E8F0),
            width: 0.9,
          ),
        ),
        child: Column(children: [
          Icon(Icons.bedtime_outlined, size: 40,
              color: isDark
                  ? const Color(0xFF6B5FC4)
                  : const Color(0xFF94A3B8)),
          const SizedBox(height: 12),
          Text('Belum ada log tidur',
              style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.w600,
                color: isDark
                    ? const Color(0xFF8B80C4)
                    : const Color(0xFF64748B),
              )),
          const SizedBox(height: 4),
          Text('Catat tidur pertamamu di atas',
              style: TextStyle(
                fontSize: 12,
                color: isDark
                    ? const Color(0xFF6B5FC4)
                    : const Color(0xFF94A3B8),
              )),
        ]),
      );
}

class _ErrorBanner extends StatelessWidget {
  final String message;
  final bool isDark;
  const _ErrorBanner({required this.message, required this.isDark});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFE11D48).withOpacity(isDark ? 0.15 : 0.06),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: const Color(0xFFE11D48).withOpacity(0.3), width: 0.9),
        ),
        child: Row(children: [
          const Icon(Icons.error_outline_rounded,
              size: 16, color: Color(0xFFE11D48)),
          const SizedBox(width: 8),
          Expanded(child: Text(message,
              style: const TextStyle(
                fontSize: 12.5, color: Color(0xFFE11D48),
                fontWeight: FontWeight.w500,
              ))),
        ]),
      );
}