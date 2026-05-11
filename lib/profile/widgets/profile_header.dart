import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/widgets/app_theme.dart';
import '../../../core/avatar_storage.dart';
import '/service/profile_service.dart';
import 'profile_avatar.dart';
import 'edit_profile_modal.dart';

class ProfileHeader extends StatefulWidget {
  const ProfileHeader({super.key});

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  String     _displayName = '';
  String     _email       = '';
  bool       _isLoading   = true;
  String     _username    = '';
  String     _phone       = '';
  String     _gender      = 'L';
  Uint8List? _imageBytes;

  @override
  void initState() {
    super.initState();
    _loadProfile();
    _loadAvatar();
  }

  Future<void> _loadAvatar() async {
    final bytes = await AvatarStorage.load();
    if (!mounted) return; // ← cek setelah await
    if (bytes != null) setState(() => _imageBytes = bytes);
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return; // ← cek setelah await

    setState(() {
      _displayName = prefs.getString('full_name') != null &&
              prefs.getString('full_name')!.isNotEmpty
          ? prefs.getString('full_name')!
          : prefs.getString('username') ?? '';
      _email     = prefs.getString('email')    ?? '';
      _username  = prefs.getString('username') ?? '';
      _phone     = prefs.getString('phone')    ?? '';
      _gender    = prefs.getString('gender')   ?? 'L';
      _isLoading = false;
    });

    final result = await ProfileService.getProfile();
    if (!mounted) return; // ← cek setelah await network call

    if (result['success'] == true) {
      final data    = result['data'] as Map<String, dynamic>?;
      if (data == null) return;
      final profile = data['profile'] as Map<String, dynamic>?;

      setState(() {
        final fullName = profile?['full_name'];
        final username = data['username'];
        _displayName = (fullName != null && fullName.toString().isNotEmpty)
            ? fullName.toString()
            : (username?.toString() ?? _displayName);
        _email    = data['email']?.toString()      ?? _email;
        _username = data['username']?.toString()   ?? _username;
        _phone    = profile?['phone']?.toString()  ?? _phone;
        _gender   = profile?['gender']?.toString() ?? _gender;
      });
    }
  }

  void _openEditModal(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => EditProfileModal(
        initialFullName: _displayName.isEmpty ? '' : _displayName,
        initialUsername: _username.isEmpty    ? '' : _username,
        initialEmail:    _email.isEmpty       ? '' : _email,
        initialPhone:    _phone.isEmpty       ? '' : _phone,
        initialGender:   _gender.isEmpty      ? 'L' : _gender,
        onUpdated:       _loadProfile,
        onImagePicked:   (bytes) {
          if (!mounted) return;
          setState(() => _imageBytes = bytes);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: AppTheme.instance,
      builder: (context, isDark, _) {
        return Column(
          children: [
            const SizedBox(height: 28),
            ProfileAvatar(
              isDark: isDark,
              imageBytes:  _imageBytes,
              onTapCamera: () => _openEditModal(context),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _isLoading
                    ? Container(
                        width: 120,
                        height: 22,
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF2D2654)
                              : const Color(0xFFE2E8F0),
                          borderRadius: BorderRadius.circular(6),
                        ))
                    : Text(
                        _displayName.isEmpty ? 'Pengguna' : _displayName,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF0F172A),
                          letterSpacing: -0.4,
                        ),
                      ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () => _openEditModal(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      gradient: isDark
                          ? LinearGradient(colors: [
                              const Color(0xFF4F46E5).withOpacity(0.30),
                              const Color(0xFF6366F1).withOpacity(0.20),
                            ])
                          : null,
                      color: isDark ? null : const Color(0xFFEAF2FF),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isDark
                            ? const Color(0xFF6366F1).withOpacity(0.55)
                            : const Color(0xFF4D7AD4).withOpacity(0.35),
                        width: 1,
                      ),
                      boxShadow: isDark
                          ? [
                              BoxShadow(
                                  color: const Color(0xFF4F46E5)
                                      .withOpacity(0.20),
                                  blurRadius: 10)
                            ]
                          : null,
                    ),
                    child: Text(
                      'Edit Profil',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? const Color(0xFFB9ABFF)
                            : const Color(0xFF2563EB),
                        letterSpacing: 0.1,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            _isLoading
                ? Container(
                    width: 180,
                    height: 14,
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF2D2654)
                          : const Color(0xFFE2E8F0),
                      borderRadius: BorderRadius.circular(4),
                    ))
                : Text(
                    _email.isEmpty ? '-' : _email,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: isDark
                          ? const Color(0xFF7C6FAA)
                          : const Color(0xFF94A3B8),
                    ),
                  ),
            const SizedBox(height: 24),
          ],
        );
      },
    );
  }
}