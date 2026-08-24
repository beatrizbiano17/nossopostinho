import 'dart:async';

import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer(
      const Duration(seconds: 3),
      () {
        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.branco,

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/nosso_postinho_logo.png.jpeg',
              width: 280,
            ),

            const SizedBox(height: 35),

            Text(
              'Tecnologia e cuidado para todos',
              style: AppTextStyles.textoPequeno.copyWith(
                color: AppColors.azulEscuro,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 30),

            const SizedBox(
              width: 30,
              height: 30,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: AppColors.azulMedio,
              ),
            ),
          ],
        ),
      ),
    );
  }
}