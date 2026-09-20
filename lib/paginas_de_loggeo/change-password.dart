import 'package:flutter/material.dart';

class ChangePassword extends StatelessWidget {
  const ChangePassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IMPORTANTE: Fondo transparente para ver la app de fondo
      backgroundColor: Colors.black.withValues(alpha: 0.5),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(30),
          padding: const EdgeInsetsDirectional.symmetric(
            vertical: 150,
            horizontal: 15,
          ),

          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 250,
                child: TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  ),
                ),
              ),

              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Salir'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
