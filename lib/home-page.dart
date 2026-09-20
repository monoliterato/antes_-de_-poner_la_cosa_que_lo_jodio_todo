//libreria generica
import 'package:flutter/material.dart';

//librerias de go router
import 'package:go_router/go_router.dart';


//librerias de firebase
import 'package:firebase_auth/firebase_auth.dart';

//libreria de esquemas de color
import 'app_colors.dart';

//librerias de las paginas anexadas
import 'package:aplicacion/paginas_de_loggeo/sign-in.dart';





class HomePage extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  
  
  const HomePage({super.key, 
  required this.navigationShell,
  
  });

  




  // Método para cambiar de pestaña usando GoRouter
  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      // Si el usuario toca la pestaña activa actual, vuelve a la ruta inicial de esa pestaña
      initialLocation: index == navigationShell.currentIndex,
    );
  }




// Metodo para lanzar la pestaña sobre otras
  void abrirNotificacion(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        opaque: false, // Evita que la pantalla de atrás se destruya o esconda
        pageBuilder: (context, animation, secondaryAnimation) {
          return const SignIn(); // 2. Llama a tu clase aquí
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // Opcional: Agrega una transición de aparición suave (Fade)
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      // El child ahora es el contenedor que maneja GoRouter internamente
      body: Container(
        decoration: BoxDecoration(gradient: AppColors.gradientColors),
        child: navigationShell,
      ),




      bottomNavigationBar: SafeArea(
        child: Container(
          padding: EdgeInsets.all(8.0),
          margin: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color:  Colors.transparent,
            borderRadius: const BorderRadius.all(Radius.circular(25.0)),
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(25.0)),
            child: BottomNavigationBar(
              currentIndex: navigationShell.currentIndex,
              onTap: _onTap,
              backgroundColor: AppColors.degradadoOscuro,
              unselectedItemColor: AppColors.blancoPrimario,
              selectedItemColor: AppColors.magentaClaro,

              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Inicio',
                ),

                BottomNavigationBarItem(
                  icon: Icon(Icons.smart_toy_outlined),
                  label: 'Modelos',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.assignment),
                  label: 'Post',
                ),
              ],
            ),
          ),
        ),
      ),

      floatingActionButton: StreamBuilder<dynamic>(
        stream: FirebaseAuth.instance.authStateChanges(), // Replace with your stream
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return FloatingActionButton(
              shape: const CircleBorder(),
              onPressed: () {
                abrirNotificacion(context);
              },
              child: Icon(Icons.data_array),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            return FloatingActionButton(
              shape: const CircleBorder(),
              onPressed: () {
                context.go('/homePage/porfile');
              },
              child: Icon(Icons.person),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
