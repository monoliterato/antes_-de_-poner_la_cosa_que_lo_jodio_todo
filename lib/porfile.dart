import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'auth_services.dart';

class Porfile extends StatefulWidget {
  const Porfile({super.key});

  @override
  State<Porfile> createState() => _PorfileState();
}

class _PorfileState extends State<Porfile> {
  String errorMessage = '';

  
  Future<bool> expulsar() async {
    try {
      await authService.value.signOut();
      return true;
    } on FirebaseException catch (e) {
      setState(() {
        errorMessage = e.message ?? 'EXISTE UN ERROR';
      });
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('perfil')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Contenido de la página perfil'),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () async {
                final salir = await expulsar();
                if (salir) {
                  if (!mounted || !context.mounted) return;
                  Navigator.pop(context);
                }
              },

              icon: const Icon(Icons.download),
              label: const Text('salir'),
            ),
          ],
        ),
      ),
    );
  }
}
