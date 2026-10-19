import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

import 'metodos-modelo.dart';

class AnadirModelo extends StatefulWidget {
  const AnadirModelo({super.key});

  @override
  State<AnadirModelo> createState() => _AnadirModeloState();
}

class _AnadirModeloState extends State<AnadirModelo> {
  XFile? _imageToUpload;
  Uint8List? _imageBytes;
  String? _imageUrl;
  bool _estaSubiendoImagen = false;

  final TextEditingController controllerTitulo = TextEditingController();
  final TextEditingController _controllerDescripcionCorta =
      TextEditingController();
  final TextEditingController _controllerDescripcionCompleta =
      TextEditingController();
  final ModeloFirestoreService _modeloFirestoreService =
      ModeloFirestoreService();
  PlatformFile? _modeloSeleccionado;
  bool _estaSubiendoModelo = false;

  @override
  void dispose() {
    controllerTitulo.dispose();
    _controllerDescripcionCorta.dispose();
    _controllerDescripcionCompleta.dispose();
    super.dispose();
  }

  Future<void> _cargarModelo3D() async {
    final modelo = _modeloSeleccionado;
    if (modelo == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Primero selecciona un modelo 3D.')),
      );
      return;
    }

    final titulo = controllerTitulo.text.trim();
    if (titulo.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Escribe el título del modelo.')),
      );
      return;
    }
    final modelImageUrl = _imageUrl;
    if (modelImageUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Primero sube la imagen de presentación.'),
        ),
      );
      return;
    }

    setState(() => _estaSubiendoModelo = true);
    try {
      final modelId = DateTime.now().microsecondsSinceEpoch.toString();
      final modeloUrl = await subirModelo3DAFirebase(modelo, modelId);
      await _modeloFirestoreService.agregarModelo(
        titulo: titulo,
        descripcionCorta: _controllerDescripcionCorta.text.trim(),
        descripcionCompleta: _controllerDescripcionCompleta.text.trim(),
        modelImageUrl: modelImageUrl,
        modeloUrl: modeloUrl,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Modelo cargado correctamente.')),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo cargar el modelo: $error')),
      );
    } finally {
      if (mounted) {
        setState(() => _estaSubiendoModelo = false);
      }
    }
  }

  Future<void> _subirImagenModelo() async {
    final imagen = _imageToUpload;
    if (imagen == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Primero selecciona una imagen.')),
      );
      return;
    }

    setState(() => _estaSubiendoImagen = true);
    try {
      final imageUrl = await uploadImageToFirebaseStorage(
        imagen,
        DateTime.now().microsecondsSinceEpoch.toString(),
      );
      if (!mounted) return;
      setState(() => _imageUrl = imageUrl);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Imagen subida correctamente.')),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo subir la imagen: $error')),
      );
    } finally {
      if (mounted) {
        setState(() => _estaSubiendoImagen = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(left: 40.0, right: 40.0),
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 20.0, bottom: 40.0),
            child: Text(
              'AÑADIR NUEVO MODELO',
              style: TextStyle(color: Colors.white, fontSize: 45.0),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 30.0),
            child: Text(
              'TITULO DEL MODELO',
              style: TextStyle(color: Colors.white, fontSize: 30.0),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 70.0),
            width: 250,
            child: TextField(
              controller: controllerTitulo,
              obscureText: false,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
                labelText: 'TITULO',
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 30.0),
            child: Text(
              'DESCRIPCION CORTA DEL MODELO',
              style: TextStyle(color: Colors.white, fontSize: 30.0),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 70.0),
            child: TextFormField(
              controller: _controllerDescripcionCorta,
              maxLines: 3, // Número máximo de líneas visibles
              keyboardType: TextInputType
                  .multiline, // Habilita múltiples líneas en el teclado
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0, // Tamaño de la letra que escribe el usuario
              ),
              decoration: InputDecoration(
                labelText: 'Describe brevemente el objeto',
                labelStyle: TextStyle(color: Colors.white),
                hintStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Text(
            'SUBIR EL ARCHIVO EN FORMATO GLB',
            style: TextStyle(color: Colors.white, fontSize: 30.0),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 10.0),
                child: SvgPicture.asset(
                  'assets/images/subir-dos.svg',
                  width: 350,
                  height: 350,
                ),
              ),
              if (_modeloSeleccionado != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    'Modelo seleccionado: ${_modeloSeleccionado!.name}',
                    style: const TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FloatingActionButton.extended(
                    heroTag: 'subir-modelo',
                    onPressed: () async {
                      try {
                        final modelo = await seleccionarModelo3D();
                        if (!mounted || modelo == null) return;
                        setState(() => _modeloSeleccionado = modelo);
                      } catch (error) {
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'No se pudo seleccionar el modelo 3D: $error',
                            ),
                          ),
                        );
                      }
                    },
                    label: const Text('ELEGIR MODELO 3D'),
                  ),
                  FloatingActionButton.extended(
                    heroTag: 'cargar-modelo',
                    onPressed: _estaSubiendoModelo ? null : _cargarModelo3D,
                    label: Text(
                      _estaSubiendoModelo ? 'CARGANDO...' : 'CARGAR MODELO 3D',
                    ),
                  ),
                ],
              ),
            ],
          ),
          Text(
            'SUBIR UNA IMAGEN PARA LA PRESENTACION',
            style: TextStyle(color: Colors.white, fontSize: 30.0),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _imageBytes != null
                  ? Image.memory(_imageBytes!, width: 350, height: 350)
                  : SvgPicture.asset(
                      'assets/images/subir-dos.svg',
                      width: 350,
                      height: 350,
                    ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FloatingActionButton.extended(
                    heroTag: 'seleccionar-imagen',
                    onPressed: () async {
                      final imagenSeleccionada = await getImage();
                      if (imagenSeleccionada == null || !mounted) return;
                      final imageBytes = await imagenSeleccionada.readAsBytes();
                      if (!mounted) return;
                      setState(() {
                        _imageToUpload = imagenSeleccionada;
                        _imageBytes = imageBytes;
                        _imageUrl = null;
                      });
                    },
                    label: const Text('SELECCIONAR IMAGEN'),
                  ),
                  FloatingActionButton.extended(
                    heroTag: 'cargar-imagen',
                    onPressed: _estaSubiendoImagen ? null : _subirImagenModelo,
                    label: Text(
                      _estaSubiendoImagen ? 'SUBIENDO...' : 'SUBIR IMAGEN',
                    ),
                  ),
                ],
              ),
            ],
          ),
          Text(
            'DESCRIPCION COMPLETA DEL MODELO',
            style: TextStyle(color: Colors.white, fontSize: 30.0),
          ),
          TextFormField(
            controller: _controllerDescripcionCompleta,
            maxLines: 8, // Número máximo de líneas visibles
            keyboardType: TextInputType
                .multiline, // Habilita múltiples líneas en el teclado
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0, // Tamaño de la letra que escribe el usuario
            ),
            decoration: InputDecoration(
              labelText: 'Escribe las caracteristicas del modelo aquí',
              labelStyle: TextStyle(color: Colors.white),
              hintStyle: TextStyle(color: Colors.white),
              border: OutlineInputBorder(),
            ),
          ),

          FloatingActionButton.extended(
            heroTag: 'guardar-modelo',
            onPressed: _estaSubiendoModelo ? null : _cargarModelo3D,
            label: Text(_estaSubiendoModelo ? 'CARGANDO...' : 'CARGAR MODELO'),
          ),

          Container(height: 100),
        ],
      ),
    );
  }
}
