import 'package:aplicacion/paginas_de_modelos/datos-modelo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:model_viewer_plus/model_viewer_plus.dart';

class ModeloUnico extends StatefulWidget {
  const ModeloUnico({super.key});

  @override
  State<ModeloUnico> createState() => _ModeloUnicoState();
}

class _ModeloUnicoState extends State<ModeloUnico> {
  Future<void> _openData() async {
    await Navigator.push<void>(
      context,
      PageRouteBuilder<void>(
        opaque: false,
        pageBuilder: (context, animation, secondaryAnimation) {
          return const DatosModelo();
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: MediaQuery.sizeOf(context).width * 1,
          height: MediaQuery.sizeOf(context).height * 0.9,
          child: ModelViewer(
            src: kIsWeb
                ? 'assets/assets/3d/modelo.glb'
                : 'assets/3d/modelo.glb',
            alt: 'Modelo 3D',
            autoRotate: true,
            cameraControls: true,
            ar: true,
            shadowIntensity: 1.0,
          ),
        ),
        Positioned(
          bottom: 120,
          left: MediaQuery.of(context).size.width * 0.32,
          right: MediaQuery.of(context).size.width * 0.32,
          child: FloatingActionButton.extended(
            heroTag: 'models-profile',
            shape: const StadiumBorder(),
            onPressed: _openData,
            icon: const Icon(Icons.assessment_sharp),
            label: const Text('DESCRIPCION'),
          ),
        ),
      ],
    );
  }
}
