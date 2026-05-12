// profile_avatar_controller.dart
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/avatar_storage.dart';
import 'profile_avatar.dart';

class ProfileAvatarController extends StatefulWidget {
  final bool isDark;

  const ProfileAvatarController({super.key, required this.isDark});

  @override
  State<ProfileAvatarController> createState() => _ProfileAvatarControllerState();
}

class _ProfileAvatarControllerState extends State<ProfileAvatarController> {
  Uint8List? _imageBytes;

  @override
  void initState() {
    super.initState();
    _loadAvatar(); // ← load saat halaman dibuka / login kembali
  }

  Future<void> _loadAvatar() async {
    final bytes = await AvatarStorage.load();
    if (!mounted) return;
    setState(() => _imageBytes = bytes);
  }

  Future<void> _pickAndSaveAvatar() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (picked == null) return;

    final bytes = await picked.readAsBytes();
    await AvatarStorage.save(bytes); // ← simpan ke local storage

    if (!mounted) return;
    setState(() => _imageBytes = bytes);
  }

  @override
  Widget build(BuildContext context) {
    return ProfileAvatar(
      isDark: widget.isDark,
      imageBytes: _imageBytes,
      onTapCamera: _pickAndSaveAvatar,
    );
  }
}