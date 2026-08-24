import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  final double largura;

  const AppLogo({
    super.key,
    this.largura = 220,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/nosso_postinho_header.png',
      width: largura,
      fit: BoxFit.contain,
    );
  }
}