import 'package:flutter/material.dart';
import '../core/widgets/wavy_header.dart';
import 'widgets/login_form.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: screenHeight),
          child: Column(
            children: [
              const WavyHeader(),
              const SizedBox(height: 40),
              const LoginForm(),
              const SizedBox(height: 36),
              //const SocialLogin(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}