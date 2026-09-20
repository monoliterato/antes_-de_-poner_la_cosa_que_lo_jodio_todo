import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';



//imprtacion de los metodos para loggeo
import '../auth_services.dart';



//paginas de loggeo
import 'base-loggeo.dart';
import 'sign-in.dart';



class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();
  TextEditingController controllerRepeatPassword = TextEditingController();
  String errorMessage = '';

  @override
  void dispose() {
    controllerEmail.dispose();
    controllerPassword.dispose();
    super.dispose();
  }

  void abrirNotificacion(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        opaque: false, // Evita que la pantalla de atrás se destruya o esconda
        pageBuilder: (context, animation, secondaryAnimation) {
          return const SignIn(); // 2. Llama a tu clase aquí
        },
      ),
    );
  }

  Future<bool> register() async {
    try {
      if (controllerPassword.text == controllerRepeatPassword.text) {
        await authService.value.createAccount(
          email: controllerEmail.text,
          password: controllerPassword.text,
        );
        return true;
      } else {
        setState(() {
          errorMessage = 'LAS CONTRASEÑAS NO SON IGUALES';
        });
        return false;
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message ?? 'EXISTE UN ERROR';
      });
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseLoggeo(
      extencion:  Column(
            spacing: 20,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'NUEVA CUENTA',
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
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  ),
                ),
              ),
              SizedBox(
                width: 250,
                child: TextField(
                  controller: controllerRepeatPassword,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Repetir el Password',
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
                  abrirNotificacion(context);
                },
                child: const Text(
                  'YA TENGO UNA CUENTA',
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
                        onPressed: () async {
               
                            final registrado = await register();
                            if (registrado && context.mounted) {
                              Navigator.pop(context);
                            }
                          
                        },
                        child: const Text('REGISTRARSE'),
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











