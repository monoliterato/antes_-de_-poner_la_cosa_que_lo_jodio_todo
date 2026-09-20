import 'package:flutter/material.dart';

class AppColors {
  static const  celesteClaro = Color(0xFF71b4f0);
  static const  degradadoOscuro = Color(0xFF191433);
  static const  degradadoClaro = Color.fromARGB(255, 76, 75, 126);
  static const  magentaOscuro = Color(0xFF9b4c71);
  static const  magentaClaro = Color.fromARGB(255, 243, 208, 224);
  static const  purpuraSaturado = Color(0xFF5b3dc7);
  static const  blancoPrimario = Color.fromARGB(255, 210, 210, 213);

static const gradientColors = LinearGradient(
  colors: [
    degradadoOscuro,
    degradadoClaro,
  ],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
);

}
