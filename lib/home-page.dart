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

class HomePage extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const HomePage({super.key, required this.navigationShell});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isSignInOpen = false;

  void _onTap(int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  Future<void> _openSignIn() async {
    setState(() => _isSignInOpen = true);
    await WidgetsBinding.instance.endOfFrame;
    if (!mounted) return;

    try {
      await Navigator.push<void>(
        context,
        PageRouteBuilder<void>(
          opaque: false,
          pageBuilder: (context, animation, secondaryAnimation) {
            return const SignIn();
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSignInOpen = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold (
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(gradient: AppColors.gradientColors),
        child: TickerMode(
          enabled: !_isSignInOpen,
          child: widget.navigationShell,
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(8.0),
          margin: const EdgeInsets.all(8.0),
          decoration: const BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(25.0)),
            child: BottomNavigationBar(
              currentIndex: widget.navigationShell.currentIndex,
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
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: StreamBuilder<dynamic>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (!snapshot.hasData) {
            return FloatingActionButton.extended(
              heroTag: 'global-sign-in',
              shape: const StadiumBorder(),
              onPressed: _openSignIn,
              label: const Text('INGRESAR'),
              icon: const Icon(Icons.attribution_outlined),
            );
          }
          return FloatingActionButton.extended(
            heroTag: 'global-profile',
            shape: const StadiumBorder(),
            onPressed: () => context.go('/homePage/porfile'),
            icon: const Icon(Icons.person),
            label: const Text('PERFIL'),
          );
        },
      ),
    );
  }
}
