
import 'package:flutter/material.dart';
//librerias de firebase
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

//ñibreria de go router

import 'package:aplicacion/router.dart';






void main() async {

//integracion de firebase

WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);

//termino de la integracion de firebase

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}); 

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router, // Conectamos GoRouter aquí
    );
  }
}
