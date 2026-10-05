import 'package:flutter/material.dart';

class ModeloUnico extends StatelessWidget {
  const ModeloUnico({super.key});

  @override
  Widget build(BuildContext context) {
     return Scaffold(
      
      body: const Center(
        child: Text(' modelo unico',
        style: TextStyle(fontSize: 50,
        color: Color.fromARGB(255, 165, 75, 75),)
        ),
      ),
    );
  }
}