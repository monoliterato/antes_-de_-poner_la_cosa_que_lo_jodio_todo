import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DatosModelo extends StatefulWidget {
  const DatosModelo({super.key});

  @override
  State<DatosModelo> createState() => _DatosModeloState();
}

class _DatosModeloState extends State<DatosModelo> {
  late final LayerLink ancla = LayerLink();
  final String markdownContent = '''
  # Título del Documento
  Este es un ejemplo de **texto enriquecido**.
  
  ### Requisitos:
  * Flutter SDK configurado
  * Dependencia agregada al archivo `pubspec.yaml`
  * Dependencia agregada al archivo `pubspec.yaml`
  * Dependencia agregada al archivo `pubspec.yaml`
  * Dependencia agregada al archivo `pubspec.yaml`
  * Dependencia agregada al archivo `pubspec.yaml`
  * Dependencia agregada al archivo `pubspec.yaml`
  * Dependencia agregada al archivo `pubspec.yaml`
  * Dependencia agregada al archivo `pubspec.yaml`
  * Dependencia agregada al archivo `pubspec.yaml`
  * Dependencia agregada al archivo `pubspec.yaml`
  * Dependencia agregada al archivo `pubspec.yaml`
  * Dependencia agregada al archivo `pubspec.yaml`
  * Dependencia agregada al archivo `pubspec.yaml`
  * Dependencia agregada al archivo `pubspec.yaml`
  * Dependencia agregada al archivo `pubspec.yaml`
  * Dependencia agregada al archivo `pubspec.yaml`
  * Flutter SDK configurado
  * Flutter SDK configurado
  * Flutter SDK configurado
  * Flutter SDK configurado
  * Flutter SDK configurado
  * Flutter SDK configurado
  * Flutter SDK configurado
  * Flutter SDK configurado
  * Flutter SDK configurado
  ------- Flutter SDK configurado
  - Flutter SDK configurado
  
  
  Visita la documentación en [Flutter Pub](https://pub.dev).
  ''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withValues(alpha: 0.45),
      body: Center(
        child: Stack(
          children: [
            CompositedTransformTarget(
              link: ancla,
              child: Container(
                color: Colors.transparent,
                height: MediaQuery.of(context).size.height * 0.8,
                width: MediaQuery.of(context).size.width * 0.85,

                padding: const EdgeInsetsDirectional.symmetric(),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: SvgPicture.asset(
                        'assets/images/fondo.svg',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.12,
                        left: 10,
                        right: MediaQuery.of(context).size.height * 0.05,
                        bottom: MediaQuery.of(context).size.height * 0.07,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: ListView(
                              children: [
                                ListTile(
                                  title: MarkdownBody(
                                    data: markdownContent,
                                    selectable: true,
                                    styleSheet:
                                        MarkdownStyleSheet.fromTheme(
                                          Theme.of(context),
                                        ).copyWith(
                                          h1: const TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue,
                                          ),
                                          p: const TextStyle(
                                            fontSize: 16,
                                            height: 1.5,
                                          ),
                                        ),
                                    onTapLink: (text, href, title) {
                                      if (href != null) {
                                        debugPrint('Abriendo enlace: ');
                                      }
                                    },
                                  ),
                                  
                                ),

                                ListTile(
                                  title: Container(
                                    child: FloatingActionButton.extended(
                                      heroTag: 'close-data',
                                      shape: const StadiumBorder(),
                                      onPressed: () => context.pop(),
                                      icon: const Icon(Icons.person),
                                      label: const Text('Salir'),
                                    ),
                                  ),
                                  onTap: () {},
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
