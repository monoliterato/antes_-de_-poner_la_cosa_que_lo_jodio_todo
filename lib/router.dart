import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';



//importaciones de paginas generales
import 'home.dart';
import 'home-page.dart';
import 'post-unico.dart';
import 'posts-page.dart';
import 'modelo-unico.dart';
import 'modelos.dart';
import 'porfile.dart';



//importacion de rutas referidas a loggeo


import 'paginas_de_loggeo/sign-in.dart';
import 'paginas_de_loggeo/sign-up.dart';
import 'paginas_de_loggeo/forgot-password.dart';
import 'paginas_de_loggeo/change-password.dart';






final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

final GoRouter router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/homePage',
  routes: [
    StatefulShellRoute.indexedStack(
      // El navigationShell contiene el estado de la pestaña actual y maneja el cambio de ramas
      builder: (context, state, navigationShell) =>
          HomePage(navigationShell: navigationShell),
      branches: [
        // Rama 1: Inicio
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/homePage',
              builder: (context, state) => const Home(),
              routes: [
                GoRoute(
                  path: 'modelo-unico',
                  builder: (context, state) => const ModeloUnico(),
                ),
                GoRoute(
                  path: 'porfile',
                  builder: (context, state) => const Porfile(),
                ),
              ],
            ),
          ],
        ),
        // Rama 2: Modelos
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/modelos',
              builder: (context, state) => const Modelos(),
              routes: [
                GoRoute(
                  path: 'modelo-unico',
                  builder: (context, state) => const ModeloUnico(),
                ),
              ],
            ),
          ],
        ),
        // Rama 3: Publicaciones
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/post-page',
              builder: (context, state) => const PostPage(),
              routes: [
                GoRoute(
                  path: 'post-unico',
                  builder: (context, state) => const PostUnico(),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
    // Las pantallas de autenticación no necesitan la barra persistente.
    GoRoute(
      path: '/sign-in',
      builder: (context, state) => const SignIn(),
    ),
    GoRoute(
      path: '/sign-up',
      builder: (context, state) => const SignUp(),
    ),
    GoRoute(
      path: '/forgot-password',
      builder: (context, state) => const ForgotPassword(),
    ),
    GoRoute(
      path: '/change-password',
      builder: (context, state) => const ChangePassword(),
    ),
  ],
);
