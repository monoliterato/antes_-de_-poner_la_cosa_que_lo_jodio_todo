import 'package:flutter/material.dart';

class BaseLoggeo extends StatelessWidget {
  final Widget extencion;
  const BaseLoggeo({super.key, required this.extencion});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IMPORTANTE: Fondo transparente para ver la app de fondo
      backgroundColor: Colors.black.withValues(alpha: 0.5),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(30),
          padding: const EdgeInsetsDirectional.symmetric(
            vertical: 40,
            horizontal: 15,
          ),

          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: extencion,
        ),
      ),
    );
  }
}
