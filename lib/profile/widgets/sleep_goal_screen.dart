import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../../core/widgets/app_theme.dart';
import '../../service/new_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ─── Entry Point ──────────────────────────────────────────────────────────────
class _TokenStorage {
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }
}


class SleepGoalScreen extends StatefulWidget {
  const SleepGoalScreen({super.key});

  @override
  State<SleepGoalScreen> createState() => _SleepGoalScreenState();
}

class _SleepGoalScreenState extends State<SleepGoalScreen> {
  // ── State ─────────────────────────────────────────────────────────────────
  // TODO: inisialisasi dari GET /api/profile → sleep_goal
  double _targetHours      = 8.0;    // jam tidur per malam
  TimeOfDay _bedTime       = const TimeOfDay(hour: 22, minute: 30);
  TimeOfDay _wakeTime      = const TimeOfDay(hour: 6, minute: 30);
  _SleepQualityGoal _qualityGoal = _SleepQualityGoal.good;
  bool _enableReminder     = true;
  bool _adaptiveSchedule   = false;
  bool _isLoading          = false;
  String? _errorMsg;

  // ── Computed: menampilkan selisih bedTime → wakeTime ──────────────────────
  String get _durationDisplay {
    final bedMinutes  = _bedTime.hour * 60 + _bedTime.minute;
    final wakeMinutes = _wakeTime.hour * 60 + _wakeTime.minute;
    final diff = wakeMinutes >= bedMinutes
        ? wakeMinutes - bedMinutes
        : (24 * 60 - bedMinutes) + wakeMinutes;
    final h = diff ~/ 60;
    final m = diff % 60;
    return m == 0 ? '${h}j' : '${h}j ${m}m';
  }

  // ── Time Picker ───────────────────────────────────────────────────────────
  Future<void> _pickTime({
    required BuildContext context,
    required TimeOfDay initial,
    required ValueChanged<TimeOfDay> onPicked,
  }) async {
    final picked = await showTimePicker(
      context:      context,
      initialTime:  initial,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
        child: child!,
      ),
    );
    if (picked != null) onPicked(picked);
  }

  // ── Save Handler ──────────────────────────────────────────────────────────
  Future<void> _handleSave() async {
  setState(() { _isLoading = true; _errorMsg = null; });

  final token = await _TokenStorage.getToken();
  print('=== DEBUG TOKEN ===');
  print('token value: $token');
  print('token length: ${token?.length}');
  print('===================');

  if (token == null) {
    setState(() {
      _isLoading = false;
      _errorMsg  = 'Sesi tidak valid. Silakan login ulang.';
    });
    return;
  }

  final result = await SleepGoalService.updateSleepGoal(
    token:            token,        // ← tambahkan ini
    targetHours:      _targetHours,
    bedTime:          '${_bedTime.hour.toString().padLeft(2, '0')}:${_bedTime.minute.toString().padLeft(2, '0')}',
    wakeTime:         '${_wakeTime.hour.toString().padLeft(2, '0')}:${_wakeTime.minute.toString().padLeft(2, '0')}',
    qualityGoal:      _qualityGoal.value,
    enableReminder:   _enableReminder,
    adaptiveSchedule: _adaptiveSchedule,
  );

  if (!mounted) return;
  setState(() => _isLoading = false);

  if (result.success) {
    _showSuccessSnackBar(context, result.message);
  } else {
    setState(() => _errorMsg = result.message);
  }
}
@override
void initState() {
  super.initState();
  _loadSleepGoal();
}

Future<void> _loadSleepGoal() async {
  final token = await _TokenStorage.getToken();
  if (token == null) return;

  final data = await SleepGoalService.fetchSleepGoal(token: token);
  if (data == null || !mounted) return;

  setState(() {
    _targetHours = (data['target_hours'] as num?)?.toDouble() ?? 8.0;

    final bed  = (data['target_bedtime']  as String?)?.split(':');
    final wake = (data['target_wake_time'] as String?)?.split(':');

    if (bed != null && bed.length == 2) {
      _bedTime = TimeOfDay(
        hour:   int.tryParse(bed[0])  ?? 22,
        minute: int.tryParse(bed[1])  ?? 30,
      );
    }
    if (wake != null && wake.length == 2) {
      _wakeTime = TimeOfDay(
        hour:   int.tryParse(wake[0]) ?? 6,
        minute: int.tryParse(wake[1]) ?? 30,
      );
    }
  });
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

          // ── AppBar ──────────────────────────────────────────────────────
          appBar: AppBar(
            backgroundColor: appBarBg,
            elevation: 0,
            scrolledUnderElevation: 0,
            leading: _BackButton(isDark: isDark, iconColor: iconClr),
            title: Text(
              'Tujuan Tidur',
              style: TextStyle(
                fontSize:      17,
                fontWeight:    FontWeight.w700,
                color:         titleClr,
                letterSpacing: -0.3,
              ),
            ),
            centerTitle: true,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(0.6),
              child: Divider(height: 0, thickness: 0.6, color: divClr),
            ),
          ),

          // ── Body ────────────────────────────────────────────────────────
          body: ListView(
            padding: const EdgeInsets.symmetric(vertical: 24),
            children: [
              // Error banner
              if (_errorMsg != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                  child: _ErrorBanner(message: _errorMsg!, isDark: isDark),
                ),

              // ── Section: Target Jam Tidur ──────────────────────────────
              _SectionHeader(label: 'Target Jam Tidur', isDark: isDark),
              _SettingsCard(
                isDark: isDark,
                children: [
                  _SliderItem(
                    isDark:   isDark,
                    value:    _targetHours,
                    min:      4.0,
                    max:      12.0,
                    divisions: 16,
                    icon:      Icons.bedtime_outlined,
                    iconBg:    const Color(0xFFF5F3FF),
                    iconColor: const Color(0xFF7C3AED),
                    label:    'Durasi Tidur',
                    subtitle: '${_targetHours.toStringAsFixed(1)} jam per malam (WHO: 7–9 jam)',
                    onChanged: (v) => setState(() => _targetHours = v),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // ── Section: Jadwal Tidur ──────────────────────────────────
              _SectionHeader(label: 'Jadwal Tidur', isDark: isDark),
              _SettingsCard(
                isDark: isDark,
                children: [
                  _TimePickerItem(
                    icon:        Icons.nightlight_round,
                    iconBg:      const Color(0xFF13112A),
                    iconColor:   const Color(0xFF7C3AED),
                    label:       'Jam Tidur',
                    subtitle:    _bedTime.format(context),
                    isDark:      isDark,
                    showDivider: true,
                    onTap:       () => _pickTime(
                      context:  context,
                      initial:  _bedTime,
                      onPicked: (t) => setState(() => _bedTime = t),
                    ),
                  ),
                  _TimePickerItem(
                    icon:        Icons.wb_sunny_outlined,
                    iconBg:      const Color(0xFFFFFBEB),
                    iconColor:   const Color(0xFFD97706),
                    label:       'Jam Bangun',
                    subtitle:    _wakeTime.format(context),
                    isDark:      isDark,
                    showDivider: true,
                    onTap:       () => _pickTime(
                      context:  context,
                      initial:  _wakeTime,
                      onPicked: (t) => setState(() => _wakeTime = t),
                    ),
                  ),
                  // Info: durasi yang terhitung
                  _InfoItem(
                    icon:      Icons.timelapse_rounded,
                    iconBg:    const Color(0xFFF0FDF4),
                    iconColor: const Color(0xFF16A34A),
                    label:     'Durasi Terjadwal',
                    subtitle:  _durationDisplay,
                    isDark:    isDark,
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // ── Section: Target Kualitas Tidur ─────────────────────────
              _SectionHeader(label: 'Target Kualitas Tidur', isDark: isDark),
              _SettingsCard(
                isDark: isDark,
                children: _SleepQualityGoal.values.map((quality) {
                  final isLast = quality == _SleepQualityGoal.values.last;
                  return _RadioItem<_SleepQualityGoal>(
                    icon:        quality.icon,
                    iconBg:      quality.iconBg,
                    iconColor:   quality.iconColor,
                    label:       quality.label,
                    subtitle:    quality.subtitle,
                    isDark:      isDark,
                    value:       quality,
                    groupValue:  _qualityGoal,
                    showDivider: !isLast,
                    onChanged:   (v) => setState(() => _qualityGoal = v!),
                  );
                }).toList(),
              ),

              const SizedBox(height: 8),

              // ── Section: Pengingat & Adaptasi ──────────────────────────
              _SectionHeader(label: 'Pengingat & Adaptasi', isDark: isDark),
              _SettingsCard(
                isDark: isDark,
                children: [
                  _ToggleItem(
                    icon:        Icons.alarm_outlined,
                    iconBg:      const Color(0xFFEFF6FF),
                    iconColor:   const Color(0xFF2563EB),
                    label:       'Pengingat Jam Tidur',
                    subtitle:    'Notifikasi 30 menit sebelum jam tidur',
                    isDark:      isDark,
                    value:       _enableReminder,
                    showDivider: true,
                    onChanged:   (v) => setState(() => _enableReminder = v),
                  ),
                  _ToggleItem(
                    icon:        Icons.auto_awesome_outlined,
                    iconBg:      const Color(0xFFF5F3FF),
                    iconColor:   const Color(0xFF7C3AED),
                    label:       'Jadwal Adaptif',
                    subtitle:    'Sesuaikan otomatis berdasarkan pola tidur',
                    isDark:      isDark,
                    value:       _adaptiveSchedule,
                    showDivider: false,
                    onChanged:   (v) => setState(() => _adaptiveSchedule = v),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // ── Save Button ────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _PrimaryButton(
                  label:     'Simpan Tujuan Tidur',
                  color:     const Color(0xFFD97706),
                  isLoading: _isLoading,
                  icon:      Icons.save_outlined,
                  onTap:     _handleSave,
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        );
      },
    );
  }
}

// ─── Enums ────────────────────────────────────────────────────────────────────

enum _SleepQualityGoal {
  basic(
    value:     'basic',
    label:     'Dasar',
    subtitle:  'Tidur cukup tanpa sering terbangun',
    icon:      Icons.hotel_outlined,
    iconBg:    Color(0xFFF0FDF4),
    iconColor: Color(0xFF16A34A),
  ),
  good(
    value:     'good',
    label:     'Baik',
    subtitle:  'Tidur nyenyak dengan siklus REM optimal',
    icon:      Icons.star_outline_rounded,
    iconBg:    Color(0xFFFFFBEB),
    iconColor: Color(0xFFD97706),
  ),
  excellent(
    value:     'excellent',
    label:     'Sempurna',
    subtitle:  'Tidur restoratif penuh dengan skor tinggi',
    icon:      Icons.auto_awesome_outlined,
    iconBg:    Color(0xFFF5F3FF),
    iconColor: Color(0xFF7C3AED),
  );

  final String value;
  final String label;
  final String subtitle;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;

  const _SleepQualityGoal({
    required this.value,
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
  });
}

// ─── Custom Widgets ───────────────────────────────────────────────────────────

/// Item slider untuk target durasi tidur
class _SliderItem extends StatelessWidget {
  final bool isDark;
  final double value;
  final double min;
  final double max;
  final int divisions;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String label;
  final String subtitle;
  final ValueChanged<double> onChanged;

  const _SliderItem({
    required this.isDark,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.label,
    required this.subtitle,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedIconBg = isDark ? iconColor.withOpacity(0.18) : iconBg;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width:  40,
                height: 40,
                decoration: BoxDecoration(
                  color:        resolvedIconBg,
                  borderRadius: BorderRadius.circular(12),
                  border:       isDark
                      ? Border.all(color: iconColor.withOpacity(0.28), width: 0.9)
                      : null,
                  boxShadow:    isDark
                      ? [BoxShadow(color: iconColor.withOpacity(0.20), blurRadius: 8)]
                      : null,
                ),
                child: Icon(icon, size: 20, color: iconColor),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize:   14,
                        fontWeight: FontWeight.w600,
                        color:      isDark
                            ? const Color(0xFFF1F5F9)
                            : const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 11.5,
                        color:    isDark
                            ? const Color(0xFF8B80C4)
                            : const Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor:   iconColor,
              inactiveTrackColor: isDark
                  ? const Color(0xFF252040)
                  : const Color(0xFFE2E8F0),
              thumbColor:         iconColor,
              overlayColor:       iconColor.withOpacity(0.16),
              trackHeight:        3,
            ),
            child: Slider(
              value:     value,
              min:       min,
              max:       max,
              divisions: divisions,
              onChanged: onChanged,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${min.toInt()}j',
                    style: TextStyle(
                      fontSize: 10.5,
                      color:    isDark
                          ? const Color(0xFF6B5FC4)
                          : const Color(0xFFCBD5E1),
                    )),
                Text('${max.toInt()}j',
                    style: TextStyle(
                      fontSize: 10.5,
                      color:    isDark
                          ? const Color(0xFF6B5FC4)
                          : const Color(0xFFCBD5E1),
                    )),
              ],
            ),
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}

/// Item untuk memilih waktu (tap → time picker)
class _TimePickerItem extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String label;
  final String subtitle;
  final bool isDark;
  final bool showDivider;
  final VoidCallback onTap;

  const _TimePickerItem({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.label,
    required this.subtitle,
    required this.isDark,
    required this.showDivider,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedIconBg = isDark ? iconColor.withOpacity(0.18) : iconBg;

    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap:          onTap,
            borderRadius:   BorderRadius.circular(20),
            splashColor:    iconColor.withOpacity(isDark ? 0.12 : 0.05),
            highlightColor: iconColor.withOpacity(isDark ? 0.06 : 0.02),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Container(
                    width:  40,
                    height: 40,
                    decoration: BoxDecoration(
                      color:        resolvedIconBg,
                      borderRadius: BorderRadius.circular(12),
                      border:       isDark
                          ? Border.all(
                              color: iconColor.withOpacity(0.28), width: 0.9)
                          : null,
                      boxShadow:    isDark
                          ? [BoxShadow(
                              color: iconColor.withOpacity(0.20), blurRadius: 8)]
                          : null,
                    ),
                    child: Icon(icon, size: 20, color: iconColor),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      label,
                      style: TextStyle(
                        fontSize:   14,
                        fontWeight: FontWeight.w600,
                        color:      isDark
                            ? const Color(0xFFF1F5F9)
                            : const Color(0xFF0F172A),
                      ),
                    ),
                  ),
                  // Nilai waktu ditampilkan sebagai badge pill
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color:        iconColor.withOpacity(isDark ? 0.18 : 0.08),
                      borderRadius: BorderRadius.circular(20),
                      border:       Border.all(
                          color: iconColor.withOpacity(0.30), width: 0.8),
                    ),
                    child: Text(
                      subtitle,
                      style: TextStyle(
                        fontSize:   13,
                        fontWeight: FontWeight.w700,
                        color:      iconColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (showDivider)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Divider(
              height:    0,
              thickness: 0.6,
              color:     isDark
                  ? const Color(0xFF252040)
                  : const Color(0xFFF1F5F9),
            ),
          ),
      ],
    );
  }
}

/// Item info (read-only, tanpa tap/toggle)
class _InfoItem extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String label;
  final String subtitle;
  final bool isDark;

  const _InfoItem({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.label,
    required this.subtitle,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedIconBg = isDark ? iconColor.withOpacity(0.18) : iconBg;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width:  40,
            height: 40,
            decoration: BoxDecoration(
              color:        resolvedIconBg,
              borderRadius: BorderRadius.circular(12),
              border:       isDark
                  ? Border.all(color: iconColor.withOpacity(0.28), width: 0.9)
                  : null,
              boxShadow:    isDark
                  ? [BoxShadow(
                      color: iconColor.withOpacity(0.20), blurRadius: 8)]
                  : null,
            ),
            child: Icon(icon, size: 20, color: iconColor),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize:   14,
                fontWeight: FontWeight.w600,
                color:      isDark
                    ? const Color(0xFFF1F5F9)
                    : const Color(0xFF0F172A),
              ),
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              fontSize:   14,
              fontWeight: FontWeight.w700,
              color:      iconColor,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Shared Widgets (identik dengan account_settings_screen.dart) ─────────────

class _RadioItem<T> extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String label;
  final String subtitle;
  final bool isDark;
  final T value;
  final T groupValue;
  final bool showDivider;
  final ValueChanged<T?> onChanged;

  const _RadioItem({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.label,
    required this.subtitle,
    required this.isDark,
    required this.value,
    required this.groupValue,
    required this.showDivider,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedIconBg = isDark ? iconColor.withOpacity(0.18) : iconBg;

    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap:          () => onChanged(value),
            borderRadius:   BorderRadius.circular(20),
            splashColor:    iconColor.withOpacity(isDark ? 0.12 : 0.05),
            highlightColor: iconColor.withOpacity(isDark ? 0.06 : 0.02),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Container(
                    width:  40,
                    height: 40,
                    decoration: BoxDecoration(
                      color:        resolvedIconBg,
                      borderRadius: BorderRadius.circular(12),
                      border:       isDark
                          ? Border.all(
                              color: iconColor.withOpacity(0.28), width: 0.9)
                          : null,
                      boxShadow:    isDark
                          ? [BoxShadow(
                              color: iconColor.withOpacity(0.20), blurRadius: 8)]
                          : null,
                    ),
                    child: Icon(icon, size: 20, color: iconColor),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          label,
                          style: TextStyle(
                            fontSize:   14,
                            fontWeight: FontWeight.w600,
                            color:      isDark
                                ? const Color(0xFFF1F5F9)
                                : const Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 11.5,
                            color:    isDark
                                ? const Color(0xFF8B80C4)
                                : const Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Radio<T>(
                    value:      value,
                    groupValue: groupValue,
                    onChanged:  onChanged,
                    activeColor: iconColor,
                    fillColor:   WidgetStateProperty.resolveWith((states) {
                      if (states.contains(WidgetState.selected)) return iconColor;
                      return isDark
                          ? const Color(0xFF352F5A)
                          : const Color(0xFFCBD5E1);
                    }),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity:         VisualDensity.compact,
                  ),
                ],
              ),
            ),
          ),
        ),
        if (showDivider)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Divider(
              height:    0,
              thickness: 0.6,
              color:     isDark
                  ? const Color(0xFF252040)
                  : const Color(0xFFF1F5F9),
            ),
          ),
      ],
    );
  }
}

class _ToggleItem extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String label;
  final String subtitle;
  final bool isDark;
  final bool value;
  final bool showDivider;
  final ValueChanged<bool> onChanged;

  const _ToggleItem({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.label,
    required this.subtitle,
    required this.isDark,
    required this.value,
    required this.showDivider,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedIconBg = isDark ? iconColor.withOpacity(0.18) : iconBg;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                width:  40,
                height: 40,
                decoration: BoxDecoration(
                  color:        resolvedIconBg,
                  borderRadius: BorderRadius.circular(12),
                  border:       isDark
                      ? Border.all(color: iconColor.withOpacity(0.28), width: 0.9)
                      : null,
                  boxShadow:    isDark
                      ? [BoxShadow(
                          color: iconColor.withOpacity(0.20), blurRadius: 8)]
                      : null,
                ),
                child: Icon(icon, size: 20, color: iconColor),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize:   14,
                        fontWeight: FontWeight.w600,
                        color:      isDark
                            ? const Color(0xFFF1F5F9)
                            : const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 11.5,
                        color:    isDark
                            ? const Color(0xFF8B80C4)
                            : const Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
              ),
              CupertinoSwitch(
                value:       value,
                onChanged:   onChanged,
                activeColor: iconColor,
                trackColor:  isDark
                    ? const Color(0xFF252040)
                    : const Color(0xFFE2E8F0),
              ),
            ],
          ),
        ),
        if (showDivider)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Divider(
              height:    0,
              thickness: 0.6,
              color:     isDark
                  ? const Color(0xFF252040)
                  : const Color(0xFFF1F5F9),
            ),
          ),
      ],
    );
  }
}

class _BackButton extends StatelessWidget {
  final bool isDark;
  final Color iconColor;
  const _BackButton({required this.isDark, required this.iconColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color:        isDark ? const Color(0xFF1C1836) : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(10),
          border:       isDark
              ? Border.all(color: const Color(0xFF352F5A), width: 0.8)
              : null,
        ),
        child: Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: iconColor),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String label;
  final bool isDark;
  const _SectionHeader({required this.label, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 10),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          fontSize:      11,
          fontWeight:    FontWeight.w700,
          letterSpacing: 0.8,
          color:         isDark
              ? const Color(0xFF6B5FC4)
              : const Color(0xFF94A3B8),
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final bool isDark;
  final List<Widget> children;
  const _SettingsCard({required this.isDark, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        gradient: isDark
            ? const LinearGradient(
                begin:  Alignment.topLeft,
                end:    Alignment.bottomRight,
                colors: [Color(0xFF1C1836), Color(0xFF13112A)],
              )
            : null,
        color:        isDark ? null : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border:       Border.all(
          color: isDark ? const Color(0xFF352F5A) : const Color(0xFFE2E8F0),
          width: 0.9,
        ),
        boxShadow: isDark
            ? [
                BoxShadow(
                    color:      const Color(0xFF4F46E5).withOpacity(0.10),
                    blurRadius: 20,
                    offset:     const Offset(0, 6)),
                BoxShadow(
                    color:      Colors.black.withOpacity(0.20),
                    blurRadius: 6,
                    offset:     const Offset(0, 2)),
              ]
            : [
                BoxShadow(
                    color:      const Color(0xFF0F172A).withOpacity(0.05),
                    blurRadius: 16,
                    offset:     const Offset(0, 4)),
              ],
      ),
      child: Column(children: children),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  final String message;
  final bool isDark;
  const _ErrorBanner({required this.message, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color:        const Color(0xFFE11D48).withOpacity(isDark ? 0.15 : 0.06),
        borderRadius: BorderRadius.circular(12),
        border:       Border.all(
            color: const Color(0xFFE11D48).withOpacity(0.3), width: 0.9),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline_rounded,
              size: 16, color: Color(0xFFE11D48)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontSize:   12.5,
                color:      Color(0xFFE11D48),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final Color color;
  final bool isLoading;
  final IconData? icon;
  final VoidCallback onTap;

  const _PrimaryButton({
    required this.label,
    required this.color,
    required this.onTap,
    this.isLoading = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor:         color,
          disabledBackgroundColor: color.withOpacity(0.6),
          foregroundColor:         Colors.white,
          padding:                 const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14)),
          elevation: 0,
        ),
        child: isLoading
            ? const SizedBox(
                width:  20,
                height: 20,
                child:  CircularProgressIndicator(
                    strokeWidth: 2, color: Colors.white),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 18),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    label,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
      ),
    );
  }
}

void _showSuccessSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          const Icon(Icons.check_circle_outline_rounded,
              color: Colors.white, size: 18),
          const SizedBox(width: 10),
          Expanded(
              child: Text(message,
                  style: const TextStyle(fontWeight: FontWeight.w500))),
        ],
      ),
      backgroundColor: const Color(0xFF16A34A),
      behavior:        SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin:   const EdgeInsets.all(16),
      duration: const Duration(seconds: 3),
    ),
  );
}