import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/widgets/app_theme.dart';
import '../../service/account_settings_service.dart';

// ─── Token Helper ─────────────────────────────────────────────────────────────
// Ganti dengan auth provider yang sudah ada di project Anda
// (GetStorage, Riverpod, BLoC, SecureStorage, dll).
class _TokenStorage {
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
}

// ─── Entry Point ──────────────────────────────────────────────────────────────
class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  // ── Notification toggles ──────────────────────────────────────────────────
  // TODO: inisialisasi dari GET /api/profile → preferences
  bool _pushEnabled   = true;
  bool _emailEnabled  = false;
  bool _weeklyReport  = true;
  bool _sleepReminder = true;

  // ── Privacy toggles ───────────────────────────────────────────────────────
  bool _analyticsEnabled = true;
  bool _crashReport      = true;
  bool _personalization  = false;

  // ─── Delegate sheet-show ke method terpusat ───────────────────────────────
  // isDark diteruskan dari ValueListenableBuilder agar sheet memakai
  // tema yang sama dengan layar induknya.

  void _openChangePassword(bool isDark) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ChangePasswordSheet(isDark: isDark),
    );
  }

  void _openChangeEmail(bool isDark) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ChangeEmailSheet(isDark: isDark),
    );
  }

  void _openTwoFA(bool isDark) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _TwoFAComingSoonSheet(isDark: isDark),
    );
  }

  void _openDeleteAccount(bool isDark) {
    showDialog(
      context: context,
      builder: (_) => _DeleteAccountDialog(isDark: isDark),
    );
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

          // ── AppBar ────────────────────────────────────────────────────────
          appBar: AppBar(
            backgroundColor: appBarBg,
            elevation: 0,
            scrolledUnderElevation: 0,
            leading: _BackButton(isDark: isDark, iconColor: iconClr),
            title: Text(
              'Pengaturan Akun',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: titleClr,
                letterSpacing: -0.3,
              ),
            ),
            centerTitle: true,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(0.6),
              child: Divider(height: 0, thickness: 0.6, color: divClr),
            ),
          ),

          // ── Body ──────────────────────────────────────────────────────────
          body: ListView(
            padding: const EdgeInsets.symmetric(vertical: 24),
            children: [

              // ── Section: Keamanan Akun ─────────────────────────────────
              _SectionHeader(label: 'Keamanan Akun', isDark: isDark),
              _SettingsCard(
                isDark: isDark,
                children: [
                  // Ubah Kata Sandi — functional
                  _TapItem(
                    icon: Icons.lock_outline_rounded,
                    iconBg: const Color(0xFFEFF6FF),
                    iconColor: const Color(0xFF2563EB),
                    label: 'Ubah Kata Sandi',
                    subtitle: 'Perbarui kata sandi akun Anda',
                    isDark: isDark,
                    showDivider: true,
                    onTap: () => _openChangePassword(isDark),
                  ),

                  // Ubah Email — functional
                  _TapItem(
                    icon: Icons.email_outlined,
                    iconBg: const Color(0xFFF0FDF4),
                    iconColor: const Color(0xFF16A34A),
                    label: 'Ubah Email',
                    subtitle: 'Ganti alamat email terdaftar',
                    isDark: isDark,
                    showDivider: true,
                    onTap: () => _openChangeEmail(isDark),
                  ),

                  // 2FA — coming soon badge, tetap bisa dibuka
                  _TapItem(
                    icon: Icons.verified_user_outlined,
                    iconBg: const Color(0xFFF5F3FF),
                    iconColor: const Color(0xFF7C3AED),
                    label: 'Autentikasi Dua Faktor',
                    subtitle: 'Tambah lapisan keamanan ekstra',
                    isDark: isDark,
                    showDivider: false,
                    badge: 'Segera',
                    onTap: () => _openTwoFA(isDark),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // ── Section: Notifikasi ────────────────────────────────────
              _SectionHeader(label: 'Notifikasi', isDark: isDark),
              _SettingsCard(
                isDark: isDark,
                children: [
                  _ToggleItem(
                    icon: Icons.notifications_outlined,
                    iconBg: const Color(0xFFFFFBEB),
                    iconColor: const Color(0xFFD97706),
                    label: 'Push Notification',
                    subtitle: 'Pengingat & update di perangkat',
                    isDark: isDark,
                    value: _pushEnabled,
                    showDivider: true,
                    onChanged: (v) => setState(() => _pushEnabled = v),
                  ),
                  _ToggleItem(
                    icon: Icons.mark_email_unread_outlined,
                    iconBg: const Color(0xFFEFF6FF),
                    iconColor: const Color(0xFF0284C7),
                    label: 'Notifikasi Email',
                    subtitle: 'Ringkasan dikirim ke email',
                    isDark: isDark,
                    value: _emailEnabled,
                    showDivider: true,
                    onChanged: (v) => setState(() => _emailEnabled = v),
                  ),
                  _ToggleItem(
                    icon: Icons.bar_chart_rounded,
                    iconBg: const Color(0xFFF0FDF4),
                    iconColor: const Color(0xFF16A34A),
                    label: 'Laporan Mingguan',
                    subtitle: 'Statistik tidur tiap minggu',
                    isDark: isDark,
                    value: _weeklyReport,
                    showDivider: true,
                    onChanged: (v) => setState(() => _weeklyReport = v),
                  ),
                  _ToggleItem(
                    icon: Icons.bedtime_outlined,
                    iconBg: const Color(0xFFF5F3FF),
                    iconColor: const Color(0xFF7C3AED),
                    label: 'Pengingat Tidur',
                    subtitle: 'Ingatkan waktu tidur ideal',
                    isDark: isDark,
                    value: _sleepReminder,
                    showDivider: false,
                    onChanged: (v) => setState(() => _sleepReminder = v),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // ── Section: Privasi & Data ────────────────────────────────
              _SectionHeader(label: 'Privasi & Data', isDark: isDark),
              _SettingsCard(
                isDark: isDark,
                children: [
                  _ToggleItem(
                    icon: Icons.analytics_outlined,
                    iconBg: const Color(0xFFFFF7ED),
                    iconColor: const Color(0xFFEA580C),
                    label: 'Analitik Penggunaan',
                    subtitle: 'Bantu kami tingkatkan aplikasi',
                    isDark: isDark,
                    value: _analyticsEnabled,
                    showDivider: true,
                    onChanged: (v) => setState(() => _analyticsEnabled = v),
                  ),
                  _ToggleItem(
                    icon: Icons.bug_report_outlined,
                    iconBg: const Color(0xFFFFF1F2),
                    iconColor: const Color(0xFFE11D48),
                    label: 'Laporan Crash',
                    subtitle: 'Kirim laporan error otomatis',
                    isDark: isDark,
                    value: _crashReport,
                    showDivider: true,
                    onChanged: (v) => setState(() => _crashReport = v),
                  ),
                  _ToggleItem(
                    icon: Icons.tune_rounded,
                    iconBg: const Color(0xFFF0FDF4),
                    iconColor: const Color(0xFF16A34A),
                    label: 'Personalisasi',
                    subtitle: 'Rekomendasi berdasarkan data Anda',
                    isDark: isDark,
                    value: _personalization,
                    showDivider: false,
                    onChanged: (v) => setState(() => _personalization = v),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // ── Section: Lainnya ───────────────────────────────────────
              _SectionHeader(label: 'Lainnya', isDark: isDark),
              _SettingsCard(
                isDark: isDark,
                children: [
                  _TapItem(
                    icon: Icons.delete_outline_rounded,
                    iconBg: const Color(0xFFFFF1F2),
                    iconColor: const Color(0xFFE11D48),
                    label: 'Hapus Akun',
                    subtitle: 'Hapus semua data secara permanen',
                    isDark: isDark,
                    showDivider: false,
                    isDestructive: true,
                    onTap: () => _openDeleteAccount(isDark),
                  ),
                ],
              ),

              const SizedBox(height: 40),
            ],
          ),
        );
      },
    );
  }
}

// ─── Change Password Sheet ─────────────────────────────────────────────────────

class _ChangePasswordSheet extends StatefulWidget {
  final bool isDark;
  const _ChangePasswordSheet({required this.isDark});

  @override
  State<_ChangePasswordSheet> createState() => _ChangePasswordSheetState();
}

class _ChangePasswordSheetState extends State<_ChangePasswordSheet> {
  final _currentCtrl  = TextEditingController();
  final _newCtrl      = TextEditingController();
  final _confirmCtrl  = TextEditingController();

  bool _obscureCurrent = true;
  bool _obscureNew     = true;
  bool _obscureConfirm = true;
  bool _isLoading      = false;
  String? _errorMsg;

  @override
  void dispose() {
    _currentCtrl.dispose();
    _newCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  // ── Client-side validation (fast path sebelum hit network) ────────────────
  String? _validate() {
    if (_currentCtrl.text.trim().isEmpty) return 'Kata sandi saat ini harus diisi.';
    if (_newCtrl.text.length < 8)         return 'Kata sandi baru minimal 8 karakter.';
    if (_newCtrl.text == _currentCtrl.text) {
      return 'Kata sandi baru tidak boleh sama dengan yang lama.';
    }
    if (_newCtrl.text != _confirmCtrl.text) {
      return 'Konfirmasi kata sandi tidak cocok.';
    }
    return null;
  }

  Future<void> _submit() async {
    // 1. Client validation
    final clientErr = _validate();
    if (clientErr != null) {
      setState(() => _errorMsg = clientErr);
      return;
    }

    setState(() { _isLoading = true; _errorMsg = null; });

    // 2. Ambil token
    final token = await _TokenStorage.getToken();
    if (token == null) {
      setState(() {
        _isLoading = false;
        _errorMsg = 'Sesi tidak valid. Silakan login ulang.';
      });
      return;
    }

    // 3. API call → PUT /api/profile/password
    final result = await AccountSettingsService.changePassword(
      currentPassword: _currentCtrl.text,
      newPassword:     _newCtrl.text,
      token:           token,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (result.success) {
      Navigator.pop(context);
      _showSuccessSnackBar(context, result.message);
    } else {
      setState(() => _errorMsg = result.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _BaseSheet(
      isDark: widget.isDark,
      title: 'Ubah Kata Sandi',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_errorMsg != null) ...[
            _ErrorBanner(message: _errorMsg!, isDark: widget.isDark),
            const SizedBox(height: 16),
          ],
          _PasswordField(
            controller: _currentCtrl,
            label: 'Kata Sandi Saat Ini',
            obscure: _obscureCurrent,
            isDark: widget.isDark,
            onToggle: () => setState(() => _obscureCurrent = !_obscureCurrent),
          ),
          const SizedBox(height: 14),
          _PasswordField(
            controller: _newCtrl,
            label: 'Kata Sandi Baru',
            obscure: _obscureNew,
            isDark: widget.isDark,
            onToggle: () => setState(() => _obscureNew = !_obscureNew),
          ),
          const SizedBox(height: 14),
          _PasswordField(
            controller: _confirmCtrl,
            label: 'Konfirmasi Kata Sandi Baru',
            obscure: _obscureConfirm,
            isDark: widget.isDark,
            onToggle: () => setState(() => _obscureConfirm = !_obscureConfirm),
          ),
          const SizedBox(height: 24),
          _PrimaryButton(
            label: 'Simpan Perubahan',
            color: const Color(0xFF2563EB),
            isLoading: _isLoading,
            onTap: _submit,
          ),
        ],
      ),
    );
  }
}

// ─── Change Email Sheet ────────────────────────────────────────────────────────

class _ChangeEmailSheet extends StatefulWidget {
  final bool isDark;
  const _ChangeEmailSheet({required this.isDark});

  @override
  State<_ChangeEmailSheet> createState() => _ChangeEmailSheetState();
}

class _ChangeEmailSheetState extends State<_ChangeEmailSheet> {
  final _emailCtrl    = TextEditingController();
  final _passwordCtrl = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading       = false;
  String? _errorMsg;

  // Regex sederhana — validasi utama tetap di sisi server
  static final _emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  String? _validate() {
    final email = _emailCtrl.text.trim();
    if (email.isEmpty)                return 'Email baru harus diisi.';
    if (!_emailRegex.hasMatch(email)) return 'Format email tidak valid.';
    if (_passwordCtrl.text.isEmpty)   return 'Kata sandi harus diisi untuk verifikasi.';
    return null;
  }

  Future<void> _submit() async {
    final clientErr = _validate();
    if (clientErr != null) {
      setState(() => _errorMsg = clientErr);
      return;
    }

    setState(() { _isLoading = true; _errorMsg = null; });

    final token = await _TokenStorage.getToken();
    if (token == null) {
      setState(() {
        _isLoading = false;
        _errorMsg = 'Sesi tidak valid. Silakan login ulang.';
      });
      return;
    }

    // API call → PUT /api/profile/email
    final result = await AccountSettingsService.changeEmail(
      newEmail:        _emailCtrl.text.trim(),
      currentPassword: _passwordCtrl.text,
      token:           token,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (result.success) {
      Navigator.pop(context);
      _showSuccessSnackBar(context, result.message);
    } else {
      setState(() => _errorMsg = result.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _BaseSheet(
      isDark: widget.isDark,
      title: 'Ubah Email',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_errorMsg != null) ...[
            _ErrorBanner(message: _errorMsg!, isDark: widget.isDark),
            const SizedBox(height: 16),
          ],
          _InputField(
            controller: _emailCtrl,
            label: 'Email Baru',
            hint: 'email_baru@contoh.com',
            isDark: widget.isDark,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 14),
          _PasswordField(
            controller: _passwordCtrl,
            label: 'Konfirmasi dengan Kata Sandi',
            obscure: _obscurePassword,
            isDark: widget.isDark,
            onToggle: () => setState(() => _obscurePassword = !_obscurePassword),
          ),
          const SizedBox(height: 10),
          _HintText(
            isDark: widget.isDark,
            text: 'Kata sandi diperlukan untuk memverifikasi identitas Anda sebelum mengubah email.',
          ),
          const SizedBox(height: 24),
          _PrimaryButton(
            label: 'Simpan Email Baru',
            color: const Color(0xFF16A34A),
            isLoading: _isLoading,
            onTap: _submit,
          ),
        ],
      ),
    );
  }
}

// ─── 2FA Coming Soon Sheet ────────────────────────────────────────────────────

class _TwoFAComingSoonSheet extends StatelessWidget {
  final bool isDark;
  const _TwoFAComingSoonSheet({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return _BaseSheet(
      isDark: isDark,
      title: 'Autentikasi Dua Faktor',
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 28),
            decoration: BoxDecoration(
              color: const Color(0xFF7C3AED).withOpacity(isDark ? 0.12 : 0.06),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color: const Color(0xFF7C3AED).withOpacity(0.2), width: 0.9),
            ),
            child: Column(
              children: [
                Icon(Icons.shield_outlined,
                    size: 48,
                    color: const Color(0xFF7C3AED).withOpacity(0.7)),
                const SizedBox(height: 12),
                Text(
                  'Segera Hadir',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: isDark
                        ? const Color(0xFFF1F5F9)
                        : const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 6),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'Fitur autentikasi dua faktor sedang dalam pengembangan dan akan segera tersedia.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.5,
                      color: isDark
                          ? const Color(0xFF8B80C4)
                          : const Color(0xFF64748B),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                foregroundColor:
                    isDark ? const Color(0xFF8B80C4) : const Color(0xFF64748B),
                side: BorderSide(
                  color: isDark
                      ? const Color(0xFF352F5A)
                      : const Color(0xFFE2E8F0),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text('Tutup',
                  style: TextStyle(fontSize: 15)),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Delete Account Dialog ─────────────────────────────────────────────────────

class _DeleteAccountDialog extends StatelessWidget {
  final bool isDark;
  const _DeleteAccountDialog({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: isDark ? const Color(0xFF1C1836) : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFE11D48).withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.delete_outline_rounded,
                color: Color(0xFFE11D48), size: 20),
          ),
          const SizedBox(width: 12),
          Text('Hapus Akun',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: isDark
                    ? const Color(0xFFF1F5F9)
                    : const Color(0xFF0F172A),
              )),
        ],
      ),
      content: Text(
        'Tindakan ini akan menghapus semua data Anda secara permanen dan tidak dapat dipulihkan. Yakin ingin melanjutkan?',
        style: TextStyle(
          fontSize: 13.5,
          height: 1.5,
          color: isDark ? const Color(0xFF8B80C4) : const Color(0xFF64748B),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Batal',
              style: TextStyle(
                  color: isDark
                      ? const Color(0xFF8B80C4)
                      : const Color(0xFF64748B))),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Hapus Akun',
              style: TextStyle(
                  color: Color(0xFFE11D48), fontWeight: FontWeight.w700)),
        ),
      ],
    );
  }
}

// ─── Global SnackBar ──────────────────────────────────────────────────────────

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
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 3),
    ),
  );
}

// ─── Layout Widgets ───────────────────────────────────────────────────────────

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
          color: isDark ? const Color(0xFF1C1836) : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(10),
          border: isDark
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
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
          color: isDark ? const Color(0xFF6B5FC4) : const Color(0xFF94A3B8),
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
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF1C1836), Color(0xFF13112A)],
              )
            : null,
        color: isDark ? null : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? const Color(0xFF352F5A) : const Color(0xFFE2E8F0),
          width: 0.9,
        ),
        boxShadow: isDark
            ? [
                BoxShadow(
                    color: const Color(0xFF4F46E5).withOpacity(0.10),
                    blurRadius: 20,
                    offset: const Offset(0, 6)),
                BoxShadow(
                    color: Colors.black.withOpacity(0.20),
                    blurRadius: 6,
                    offset: const Offset(0, 2)),
              ]
            : [
                BoxShadow(
                    color: const Color(0xFF0F172A).withOpacity(0.05),
                    blurRadius: 16,
                    offset: const Offset(0, 4)),
              ],
      ),
      child: Column(children: children),
    );
  }
}

// ─── _TapItem ─────────────────────────────────────────────────────────────────

class _TapItem extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String label;
  final String subtitle;
  final bool isDark;
  final bool showDivider;
  final bool isDestructive;
  final String? badge;
  final VoidCallback onTap;

  const _TapItem({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.label,
    required this.subtitle,
    required this.isDark,
    required this.showDivider,
    required this.onTap,
    this.isDestructive = false,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedIconBg = isDark ? iconColor.withOpacity(0.18) : iconBg;
    final labelColor = isDestructive
        ? const Color(0xFFE11D48)
        : (isDark ? const Color(0xFFF1F5F9) : const Color(0xFF0F172A));

    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(20),
            splashColor: iconColor.withOpacity(isDark ? 0.12 : 0.05),
            highlightColor: iconColor.withOpacity(isDark ? 0.06 : 0.02),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: resolvedIconBg,
                      borderRadius: BorderRadius.circular(12),
                      border: isDark
                          ? Border.all(
                              color: iconColor.withOpacity(0.28), width: 0.9)
                          : null,
                      boxShadow: isDark
                          ? [BoxShadow(
                              color: iconColor.withOpacity(0.20),
                              blurRadius: 8)]
                          : null,
                    ),
                    child: Icon(icon, size: 20, color: iconColor),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(label,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: labelColor,
                            )),
                        const SizedBox(height: 2),
                        Text(subtitle,
                            style: TextStyle(
                              fontSize: 11.5,
                              color: isDark
                                  ? const Color(0xFF8B80C4)
                                  : const Color(0xFF94A3B8),
                            )),
                      ],
                    ),
                  ),
                  // Badge (Segera) ATAU chevron
                  if (badge != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: iconColor.withOpacity(isDark ? 0.18 : 0.10),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: iconColor.withOpacity(0.30), width: 0.8),
                      ),
                      child: Text(
                        badge!,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: iconColor,
                          letterSpacing: 0.3,
                        ),
                      ),
                    )
                  else
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF252040)
                            : const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(8),
                        border: isDark
                            ? Border.all(
                                color: const Color(0xFF352F5A), width: 0.8)
                            : null,
                      ),
                      child: Icon(Icons.chevron_right_rounded,
                          size: 16,
                          color: isDark
                              ? const Color(0xFF6B5FC4)
                              : const Color(0xFFCBD5E1)),
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
              height: 0,
              thickness: 0.6,
              color:
                  isDark ? const Color(0xFF252040) : const Color(0xFFF1F5F9),
            ),
          ),
      ],
    );
  }
}

// ─── _ToggleItem ──────────────────────────────────────────────────────────────

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
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: resolvedIconBg,
                  borderRadius: BorderRadius.circular(12),
                  border: isDark
                      ? Border.all(
                          color: iconColor.withOpacity(0.28), width: 0.9)
                      : null,
                  boxShadow: isDark
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
                    Text(label,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? const Color(0xFFF1F5F9)
                              : const Color(0xFF0F172A),
                        )),
                    const SizedBox(height: 2),
                    Text(subtitle,
                        style: TextStyle(
                          fontSize: 11.5,
                          color: isDark
                              ? const Color(0xFF8B80C4)
                              : const Color(0xFF94A3B8),
                        )),
                  ],
                ),
              ),
              CupertinoSwitch(
                value: value,
                onChanged: onChanged,
                activeColor: iconColor,
                trackColor:
                    isDark ? const Color(0xFF252040) : const Color(0xFFE2E8F0),
              ),
            ],
          ),
        ),
        if (showDivider)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Divider(
              height: 0,
              thickness: 0.6,
              color:
                  isDark ? const Color(0xFF252040) : const Color(0xFFF1F5F9),
            ),
          ),
      ],
    );
  }
}

// ─── Sheet Base ───────────────────────────────────────────────────────────────

class _BaseSheet extends StatelessWidget {
  final bool isDark;
  final String title;
  final Widget child;
  const _BaseSheet(
      {required this.isDark, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1C1836) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF352F5A)
                      : const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(title,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: isDark
                      ? const Color(0xFFF1F5F9)
                      : const Color(0xFF0F172A),
                  letterSpacing: -0.3,
                )),
            const SizedBox(height: 20),
            child,
          ],
        ),
      ),
    );
  }
}

// ─── Form Components ──────────────────────────────────────────────────────────

class _ErrorBanner extends StatelessWidget {
  final String message;
  final bool isDark;
  const _ErrorBanner({required this.message, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFE11D48).withOpacity(isDark ? 0.15 : 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: const Color(0xFFE11D48).withOpacity(0.3), width: 0.9),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline_rounded,
              size: 16, color: Color(0xFFE11D48)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(message,
                style: const TextStyle(
                    fontSize: 12.5,
                    color: Color(0xFFE11D48),
                    fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}

class _HintText extends StatelessWidget {
  final String text;
  final bool isDark;
  const _HintText({required this.text, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.info_outline_rounded,
            size: 14,
            color: isDark ? const Color(0xFF6B5FC4) : const Color(0xFF94A3B8)),
        const SizedBox(width: 6),
        Expanded(
          child: Text(text,
              style: TextStyle(
                fontSize: 11.5,
                height: 1.5,
                color: isDark
                    ? const Color(0xFF6B5FC4)
                    : const Color(0xFF94A3B8),
              )),
        ),
      ],
    );
  }
}

class _PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool obscure;
  final bool isDark;
  final VoidCallback onToggle;

  const _PasswordField({
    required this.controller,
    required this.label,
    required this.obscure,
    required this.isDark,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return _InputField(
      controller: controller,
      label: label,
      hint: '••••••••',
      isDark: isDark,
      obscureText: obscure,
      suffix: GestureDetector(
        onTap: onToggle,
        child: Icon(
          obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          size: 18,
          color: isDark ? const Color(0xFF8B80C4) : const Color(0xFF94A3B8),
        ),
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController? controller;
  final String label;
  final String hint;
  final bool isDark;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Widget? suffix;

  const _InputField({
    required this.label,
    required this.hint,
    required this.isDark,
    this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    final fillColor   = isDark ? const Color(0xFF13112A) : const Color(0xFFF8FAFC);
    final borderColor = isDark ? const Color(0xFF352F5A) : const Color(0xFFE2E8F0);
    final labelColor  = isDark ? const Color(0xFF8B80C4) : const Color(0xFF64748B);
    final textColor   = isDark ? const Color(0xFFF1F5F9) : const Color(0xFF0F172A);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: labelColor,
              letterSpacing: 0.2,
            )),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          style: TextStyle(fontSize: 14, color: textColor),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: labelColor.withOpacity(0.6)),
            filled: true,
            fillColor: fillColor,
            suffixIcon: suffix != null
                ? Padding(
                    padding: const EdgeInsets.only(right: 12), child: suffix)
                : null,
            suffixIconConstraints:
                const BoxConstraints(minWidth: 0, minHeight: 0),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: borderColor, width: 0.9)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: borderColor, width: 0.9)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: Color(0xFF2563EB), width: 1.5)),
          ),
        ),
      ],
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final Color color;
  final bool isLoading;
  final VoidCallback onTap;

  const _PrimaryButton({
    required this.label,
    required this.color,
    required this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          disabledBackgroundColor: color.withOpacity(0.6),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 0,
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: Colors.white),
              )
            : Text(label,
                style: const TextStyle(
                    fontSize: 15, fontWeight: FontWeight.w700)),
      ),
    );
  }
}