import 'package:flutter/material.dart';

import 'screens/splash_screen.dart';
import 'utils/app_theme.dart';

void main() {
  runApp(const NossoPostinho());
}

class NossoPostinho extends StatelessWidget {
  const NossoPostinho({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Nosso Postinho',
      theme: AppTheme.tema,
      home: const SplashScreen(),
    );
  }
}