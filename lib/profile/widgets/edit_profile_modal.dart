import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/service/profile_service.dart';
import '../../../core/avatar_storage.dart'; // ← tambah import

class EditProfileModal extends StatefulWidget {
  final String initialFullName;
  final String initialUsername;
  final String initialEmail;
  final String initialPhone;
  final String initialGender;
  final VoidCallback onUpdated;
  final Function(Uint8List bytes) onImagePicked;

  const EditProfileModal({
    super.key,
    required this.initialFullName,
    required this.initialUsername,
    required this.initialEmail,
    required this.initialPhone,
    required this.initialGender,
    required this.onUpdated,
    required this.onImagePicked,
  });

  @override
  State<EditProfileModal> createState() => _EditProfileModalState();
}

class _EditProfileModalState extends State<EditProfileModal> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _fullNameController;
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  String     _gender      = 'L';
  XFile?     _pickedFile;
  Uint8List? _pickedBytes;
  bool       _isLoading   = false;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController(text: widget.initialFullName);
    _usernameController = TextEditingController(text: widget.initialUsername);
    _emailController    = TextEditingController(text: widget.initialEmail);
    _phoneController    = TextEditingController(text: widget.initialPhone);
    _gender             = widget.initialGender.isNotEmpty ? widget.initialGender : 'L';
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();

    await showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!kIsWeb)
              ListTile(
                leading: const Icon(Icons.camera_alt_rounded),
                title: const Text('Kamera'),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
            ListTile(
              leading: const Icon(Icons.photo_library_rounded),
              title: const Text('Galeri'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    ).then((source) async {
      if (source == null) return;

      final picked = await picker.pickImage(
        source: source,
        maxWidth: 512, maxHeight: 512, imageQuality: 80,
      );

      if (picked != null) {
        final bytes = await picked.readAsBytes();

        await AvatarStorage.save(bytes); // ← FIX: simpan ke disk

        setState(() {
          _pickedFile  = picked;
          _pickedBytes = bytes;
        });

        widget.onImagePicked(bytes);
      }
    });
  }

  Widget _buildAvatar() {
    ImageProvider? imageProvider;
    if (_pickedBytes != null) imageProvider = MemoryImage(_pickedBytes!);

    return CircleAvatar(
      radius: 48,
      backgroundColor: const Color(0xFFEFF6FF),
      backgroundImage: imageProvider,
      child: imageProvider == null
          ? const Icon(Icons.person_rounded, size: 48, color: Color(0xFF2563EB))
          : null,
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final result = await ProfileService.updateProfile(
      username: _usernameController.text.trim(),
      email:    _emailController.text.trim(),
      profile:  {
        'full_name': _fullNameController.text.trim(),
        'gender':    _gender,
        'phone':     _phoneController.text.trim(),
      },
    );

    setState(() => _isLoading = false);
    if (!mounted) return;

    if (result['success']) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('full_name', _fullNameController.text.trim());
      await prefs.setString('username',  _usernameController.text.trim());
      await prefs.setString('email',     _emailController.text.trim());

      widget.onUpdated();
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profil berhasil diperbarui'),
          backgroundColor: Color(0xFF16A34A),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? 'Gagal memperbarui profil'),
          backgroundColor: const Color(0xFFDC2626),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40, height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Edit Profil',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF0F172A)),
              ),
              const SizedBox(height: 24),
              Center(
                child: Stack(
                  children: [
                    _buildAvatar(),
                    Positioned(
                      bottom: 0, right: 0,
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          width: 32, height: 32,
                          decoration: BoxDecoration(
                            color: const Color(0xFF2563EB),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(Icons.camera_alt_rounded, size: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              _buildField(
                label: 'Nama Lengkap',
                controller: _fullNameController,
                hint: 'Masukkan nama lengkap',
                validator: (v) => v!.isEmpty ? 'Nama tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),
              _buildField(
                label: 'Username',
                controller: _usernameController,
                hint: 'Masukkan username',
                validator: (v) => v!.isEmpty ? 'Username tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),
              _buildField(
                label: 'Email',
                controller: _emailController,
                hint: 'Masukkan email',
                keyboardType: TextInputType.emailAddress,
                validator: (v) => v!.isEmpty ? 'Email tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),
              _buildField(
                label: 'Nomor Telepon',
                controller: _phoneController,
                hint: 'Masukkan nomor telepon',
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              const Text(
                'Jenis Kelamin',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF475569)),
              ),
              const SizedBox(height: 8),
              Row(children: [
                _buildGenderOption('L', 'Laki-laki'),
                const SizedBox(width: 12),
                _buildGenderOption('P', 'Perempuan'),
              ]),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 20, height: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Text(
                          'Simpan Perubahan',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF475569))),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFFCBD5E1)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border:        OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF2563EB))),
          ),
        ),
      ],
    );
  }

  Widget _buildGenderOption(String value, String label) {
    final isSelected = _gender == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _gender = value),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFEFF6FF) : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? const Color(0xFF2563EB) : const Color(0xFFE2E8F0),
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                size: 18,
                color: isSelected ? const Color(0xFF2563EB) : const Color(0xFFCBD5E1),
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected ? const Color(0xFF2563EB) : const Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}