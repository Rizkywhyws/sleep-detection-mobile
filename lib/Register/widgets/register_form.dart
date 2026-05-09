import 'package:flutter/material.dart';
import 'custom_text_field.dart';
import '../../service/auth_service.dart';
import 'package:flutter/services.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _usernameController = TextEditingController();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _agreeToTerms = false;
  bool _isLoading = false;

  String _selectedGender = 'L';

  String? _usernameError;
  String? _nameError;
  String? _emailError;
  String? _phoneError;
  String? _passwordError;
  String? _confirmError;
  String? _termsError;

  @override
  void dispose() {
    _usernameController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    final username = _usernameController.text.trim();
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    final password = _passwordController.text;
    final confirm = _confirmController.text;
    final gender = _selectedGender;

    setState(() {
      if (username.isEmpty) {
        _usernameError = 'Nama pengguna wajib diisi';
      } else {
        _usernameError = null;
      }

      if (name.isEmpty) {
        _nameError = 'Nama lengkap wajib diisi';
      } else if (!_isOnlyLettersAndSpaces(name)) {
        _nameError = 'Nama lengkap hanya boleh huruf';
      } else {
        _nameError = null;
      }

      if (email.isEmpty) {
        _emailError = 'Email wajib diisi';
      } else if (!_isValidEmail(email)) {
        _emailError = 'Format email tidak valid';
      } else {
        _emailError = null;
      }

      if (phone.isEmpty) {
        _phoneError = 'Nomor HP wajib diisi';
      } else if (!_isOnlyNumbers(phone)) {
        _phoneError = 'Nomor HP hanya boleh angka';
      } else {
        _phoneError = null;
      }

      if (password.isEmpty) {
        _passwordError = 'Kata sandi wajib diisi';
      } else if (password.length < 6) {
        _passwordError = 'Kata sandi minimal 6 karakter';
      } else {
        _passwordError = null;
      }

      if (confirm.isEmpty) {
        _confirmError = 'Konfirmasi kata sandi wajib diisi';
      } else if (password != confirm) {
        _confirmError = 'Kata sandi tidak cocok';
      } else {
        _confirmError = null;
      }

      _termsError = !_agreeToTerms
          ? 'Kamu harus menyetujui syarat & ketentuan'
          : null;
    });

    final hasError =
        _usernameError != null ||
        _nameError != null ||
        _emailError != null ||
        _phoneError != null ||
        _passwordError != null ||
        _confirmError != null ||
        _termsError != null;

    if (hasError) return;

    setState(() => _isLoading = true);

    final result = await AuthService.register(
      username: username,
      email: email,
      password: password,
      fullName: name,
      gender: gender,
      phone: phone,
    );

    setState(() => _isLoading = false);

    if (!mounted) return;

    if (result['success'] == true) {
      _showSnackBar(result['message'] ?? 'Registrasi berhasil');

      Future.delayed(const Duration(milliseconds: 800), () {
        if (!mounted) return;
        Navigator.pop(context);
      });
    } else {
      _showSnackBar(result['message'] ?? 'Registrasi gagal');
    }
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);
  }

  bool _isOnlyLettersAndSpaces(String value) {
    return RegExp(r"^[a-zA-Z\s]+$").hasMatch(value);
  }

  bool _isOnlyNumbers(String value) {
    return RegExp(r'^[0-9]+$').hasMatch(value);
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),

          const Center(
            child: Text(
              'Buat Akun!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A237E),
              ),
            ),
          ),

          const SizedBox(height: 4),

          const Center(
            child: Text(
              'Daftar untuk memulai',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),

          const SizedBox(height: 20),

          CustomTextField(
            label: 'Nama Pengguna',
            hintText: 'Masukkan nama pengguna',
            prefixIcon: Icons.person_outline,
            controller: _usernameController,
            errorText: _usernameError,
          ),

          const SizedBox(height: 12),

          CustomTextField(
            label: 'Nama Lengkap',
            hintText: 'Masukkan nama lengkap',
            prefixIcon: Icons.badge_outlined,
            controller: _nameController,
            keyboardType: TextInputType.name,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
            ],
            errorText: _nameError,
          ),

          const SizedBox(height: 12),

          CustomTextField(
            label: 'Email',
            hintText: 'Masukkan email',
            prefixIcon: Icons.email_outlined,
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            errorText: _emailError,
          ),

          const SizedBox(height: 12),

          CustomTextField(
            label: 'Nomor HP',
            hintText: 'Masukkan nomor HP',
            prefixIcon: Icons.phone_outlined,
            controller: _phoneController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            errorText: _phoneError,
          ),

          const SizedBox(height: 12),

          _buildGenderDropdown(),

          const SizedBox(height: 12),

          CustomTextField(
            label: 'Kata Sandi',
            hintText: 'Masukkan kata sandi',
            prefixIcon: Icons.lock_outline,
            isPassword: true,
            controller: _passwordController,
            obscureText: _obscurePassword,
            errorText: _passwordError,
            onToggleObscure: () {
              setState(() => _obscurePassword = !_obscurePassword);
            },
          ),

          const SizedBox(height: 12),

          CustomTextField(
            label: 'Konfirmasi Kata Sandi',
            hintText: 'Ulangi kata sandi',
            prefixIcon: Icons.lock_outline,
            isPassword: true,
            controller: _confirmController,
            obscureText: _obscureConfirm,
            errorText: _confirmError,
            onToggleObscure: () {
              setState(() => _obscureConfirm = !_obscureConfirm);
            },
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Checkbox(
                value: _agreeToTerms,
                activeColor: const Color(0xFF3B5BDB),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                onChanged: (val) {
                  setState(() {
                    _agreeToTerms = val ?? false;
                    if (_agreeToTerms) {
                      _termsError = null;
                    }
                  });
                },
              ),
              const Text(
                'Saya setuju dengan ',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/register');
                },
                child: const Text(
                  'Syarat & Ketentuan',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF3B5BDB),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          if (_termsError != null) ...[
            const SizedBox(height: 2),
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Text(
                _termsError!,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFFE53935),
                  height: 1.3,
                ),
              ),
            ),
          ],

          const SizedBox(height: 18),

          SizedBox(
            width: double.infinity,
            height: 50,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1A237E), Color(0xFF1E88E5)],
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleRegister,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  disabledBackgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'DAFTAR',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          letterSpacing: 2,
                        ),
                      ),
              ),
            ),
          ),

          const SizedBox(height: 14),

          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Sudah punya akun? ',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Text(
                    'Masuk',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF3B5BDB),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildGenderDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Jenis Kelamin',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF424242),
            letterSpacing: 0.2,
          ),
        ),

        const SizedBox(height: 8),

        DropdownButtonFormField<String>(
          value: _selectedGender,
          isExpanded: true,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF0B1D51),
            fontWeight: FontWeight.w500,
          ),
          dropdownColor: Colors.white,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Color(0xFF9E9E9E),
            size: 22,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFEEF4FF),
            prefixIcon: const Icon(
              Icons.wc_outlined,
              size: 20,
              color: Color(0xFF1565C0),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(28),
              borderSide: const BorderSide(color: Color(0xFFC7D9F8), width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(28),
              borderSide: const BorderSide(
                color: Color(0xFF1565C0),
                width: 1.2,
              ),
            ),
          ),
          items: const [
            DropdownMenuItem(
              value: 'L',
              child: Text(
                'Laki-laki',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
            DropdownMenuItem(
              value: 'P',
              child: Text(
                'Perempuan',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
          ],
          onChanged: (value) {
            setState(() {
              _selectedGender = value ?? 'L';
            });
          },
        ),
      ],
    );
  }
}
