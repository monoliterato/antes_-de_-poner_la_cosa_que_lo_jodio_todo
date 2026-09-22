
import 'package:flutter/material.dart';
//librerias de firebase
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

//libreria de go router

import 'package:aplicacion/router.dart';


//cosa
import 'package:flutter_scene/build_hooks.dart';
import 'package:hooks/hooks.dart';



void main() async {


  
//integracion de flutter scene
/*await build(args, (input, output) async {
    buildScenes(buildInput: input, buildOutput: output);
    await buildMaterials(buildInput: input, buildOutput: output);
  });

*/

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
