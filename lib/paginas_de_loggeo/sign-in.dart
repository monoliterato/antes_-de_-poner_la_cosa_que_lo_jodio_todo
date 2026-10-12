import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

//importacion de los metodos para el loggeo
import '../auth_services.dart';

//importaciones de loggeo
import 'base-loggeo.dart';
import 'forgot-password.dart';
import 'sign-up.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();
  String errorMessage = '';
  bool _isSubmitting = false;

  @override
  void dispose() {
    controllerEmail.dispose();
    controllerPassword.dispose();
    super.dispose();
  }

  Future<void> _submitSignIn() async {
    if (_isSubmitting) return;

    setState(() {
      _isSubmitting = true;
      errorMessage = '';
    });

    try {
      final ingresado = await ingresar();
      if (ingresado && mounted) {
        Navigator.pop(context);
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  void abrirNotificacion(BuildContext context, int valor) {
    Navigator.push(
      context,
      PageRouteBuilder(
        opaque: false, // Evita que la pantalla de atrás se destruya o esconda
        pageBuilder: (context, animation, secondaryAnimation) {
          if (valor == 1) {
            return const SignUp();
          } else {
            return const ForgotPassword();
          } // 2. Llama a tu clase aquí
        },
      ),
    );
  }

  Future<bool> ingresar() async {
    try {
      await authService.value.signIn(
        email: controllerEmail.text,
        password: controllerPassword.text,
      );
      return true;
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        setState(() {
          errorMessage = e.message ?? 'EXISTE UN ERROR';
        });
      }
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseLoggeo(
      extencion: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 20,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'INGRESAR',
            style: TextStyle(
              fontSize: 30,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            width: 250,
            child: TextField(
              controller: controllerEmail,
              obscureText: false,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email',
              ),
            ),
          ),
          SizedBox(
            width: 250,
            child: TextField(
              controller: controllerPassword,
              obscureText: true,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
            ),
          ),

          Text(
            errorMessage,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.red),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);

              abrirNotificacion(context, 1);
            },
            child: Text(
              'NO TENGO UNA CUENTA AUN',
              style: TextStyle(
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
            ),
          ),

          GestureDetector(
            onTap: () {
              Navigator.pop(context);

              abrirNotificacion(context, 2);
            },
            child: const Text(
              'OLVIDE MI CONTRASEÑA',
              style: TextStyle(
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
            ),
          ),

          Row(
            spacing: 20,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _isSubmitting ? null : _submitSignIn,
                    child: _isSubmitting
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('INGRESAR'),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('SALIR'),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
