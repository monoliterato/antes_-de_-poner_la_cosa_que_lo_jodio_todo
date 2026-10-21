import 'package:aplicacion/paginas_de_modelos/datos-modelo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb;
import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

import 'modelo_source.dart';
import 'metodos-modelo.dart';

class ModeloUnico extends StatefulWidget {
  const ModeloUnico({super.key, this.modeloId});

  final String? modeloId;

  @override
  State<ModeloUnico> createState() => _ModeloUnicoState();
}

class _ModeloUnicoState extends State<ModeloUnico> {
  final ModeloFirestoreService _modeloFirestoreService =
      ModeloFirestoreService();
  String? _cachedModelUrl;
  Future<String>? _cachedModelSource;

  Future<void> _openData() async {
    try {
      Map<String, dynamic> modelo = {};
      final modeloId = widget.modeloId;
      if (modeloId != null && modeloId.trim().isNotEmpty) {
        final snapshot = await _modeloFirestoreService
            .getModeloById(modeloId)
            .first;
        if (!snapshot.exists) {
          throw StateError('No se encontró el modelo seleccionado.');
        }
        modelo = snapshot.data() ?? {};
      }

      if (!mounted) return;
      await Navigator.push<void>(
        context,
        PageRouteBuilder<void>(
          opaque: false,
          pageBuilder: (context, animation, secondaryAnimation) {
            return DatosModelo(
              titulo: modelo['titulo']?.toString() ?? 'Modelo 3D',
              descripcionCorta:
                  modelo['descripcionCorta']?.toString() ?? '',
              descripcionCompleta:
                  modelo['descripcionCompleta']?.toString() ?? '',
            );
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudieron cargar los datos: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: MediaQuery.sizeOf(context).width * 1,
          height: MediaQuery.sizeOf(context).height * 0.9,
          child: widget.modeloId == null || widget.modeloId!.trim().isEmpty
              ? _buildModelViewer('assets/3d/modelo.glb')
              : StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  stream: _modeloFirestoreService.getModeloById(
                    widget.modeloId!,
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'No se pudo cargar el modelo: ${snapshot.error}',
                        ),
                      );
                    }
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.data!.exists) {
                      return const Center(
                        child: Text('No se encontró el modelo.'),
                      );
                    }

                    final modelo = snapshot.data!.data()!;
                    final modelUrl = modelo['modeloUrl']?.toString() ?? '';
                    final modelImageUrl =
                        modelo['modelImageUrl']?.toString() ?? '';
                    if (modelUrl.isEmpty) {
                      return const Center(
                        child: Text('El modelo no tiene una URL disponible.'),
                      );
                    }
                    final poster = modelImageUrl.isEmpty ? null : modelImageUrl;
                    if (!_shouldCacheModelOnDevice) {
                      return _buildModelViewer(modelUrl, poster: poster);
                    }

                    return FutureBuilder<String>(
                      future: _getCachedModelSource(modelUrl),
                      builder: (context, modelSnapshot) {
                        if (modelSnapshot.hasError) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: Text(
                                'No se pudo descargar el modelo: '
                                '${modelSnapshot.error}',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        }
                        if (!modelSnapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return _buildModelViewer(
                          modelSnapshot.data!,
                          poster: poster,
                        );
                      },
                    );
                  },
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

  Widget _buildModelViewer(String modelUrl, {String? poster}) {
    return ModelViewer(
      src: modelUrl,
      poster: poster,
      alt: 'Modelo 3D',
      autoRotate: true,
      cameraControls: true,
      ar: true,
      shadowIntensity: 1.0,
    );
  }

  bool get _shouldCacheModelOnDevice =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  Future<String> _getCachedModelSource(String modelUrl) {
    if (_cachedModelUrl != modelUrl || _cachedModelSource == null) {
      _cachedModelUrl = modelUrl;
      _cachedModelSource = downloadModelToCache(
        modelUrl,
        widget.modeloId!,
      );
    }
    return _cachedModelSource!;
  }
}
