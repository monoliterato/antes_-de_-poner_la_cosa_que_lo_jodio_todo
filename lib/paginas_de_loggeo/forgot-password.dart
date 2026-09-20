import 'package:flutter/material.dart';

//paginas de loggeo
import 'base-loggeo.dart';
import 'sign-in.dart';





class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});

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



  @override
  Widget build(BuildContext context) {
    return BaseLoggeo(
    
    extencion:
     Column(
            spacing: 15,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('OLVIDE MI CONTRASEÑA',
              style: TextStyle(
              
                fontSize: 30,
                color: Colors.black,
                fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                width: 250,
                child: TextField(
                  obscureText: false,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                  ),
                ),
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
                                                onPressed: () => Navigator.pop(context),
                                                child: const Text('ENVIAR'),
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
              )
            ],
          ),
        );
      
  }
}


