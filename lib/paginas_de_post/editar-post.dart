import 'package:aplicacion/paginas_de_post/metodos-posts.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

import 'metodos-posts.dart';

import 'package:multi_image_picker_view/multi_image_picker_view.dart';

class EditarPost extends StatefulWidget {

final String oldIdentificador;
final String oldTitulo;
final String oldDescripcionCorta;
final String oldDescripcionCompleta;
final String oldImageUrl;



  const EditarPost({super.key,
  required this.oldIdentificador,
    required this.oldTitulo,
    required this.oldDescripcionCorta,
  required this.oldDescripcionCompleta,
  required this.oldImageUrl,});

  @override
  State<EditarPost> createState() => _EditarPostState();
}

class _EditarPostState extends State<EditarPost> {
  final firestoreService _firestoreService = firestoreService();

  //imagen a subir
  XFile? image_to_upload;
  Uint8List? _imageBytes;
  String? _imageUrl;
  bool _isSaving = false;

  //campos de texto
  TextEditingController controllerTitulo = TextEditingController();
  TextEditingController controllerDescripcionCorta = TextEditingController();
  TextEditingController controllerDescripcionCompleta = TextEditingController();

  Future<List<ImageFile>> pickImages({
    required bool allowMultiple,
    required int maxImages,
  }) async {
    final pickedFiles = await ImagePicker().pickMultiImage();

    return Future.wait(pickedFiles.take(maxImages).map((file) async {
      final String extension = file.path.split('.').last;
      return ImageFile(
        file.path,
        name: file.name,
        extension: extension,
        bytes: await file.readAsBytes(),
        path: kIsWeb ? null : file.path,
      );
    }));
  }

  late final MultiImagePickerController controller;

  @override
  void initState() {
    super.initState();

    controllerTitulo.text = widget.oldTitulo;
    controllerDescripcionCorta.text = widget.oldDescripcionCorta;
    controllerDescripcionCompleta.text = widget.oldDescripcionCompleta;
    
    controller = MultiImagePickerController(
      maxImages: 15,
      images: <ImageFile>[],
      picker: (int pickCount, Object? params) async {
        return await pickImages(allowMultiple: true, maxImages: pickCount);
      },
    );
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
              'EDITAR PUBLICACION',
              style: TextStyle(color: Colors.white, fontSize: 45.0),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 30.0),
            child: Text(
              'TITULO DE LA PUBLICACION',
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
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0, // Tamaño de la letra que escribe el usuario
              ),
              decoration: InputDecoration(
                labelStyle: TextStyle(color: Colors.white),
                hintStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
                labelText: 'TITULO',
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 30.0),
            child: Text(
              'DESCRIPCION CORTA DE LA PUBLICACION',
              style: TextStyle(color: Colors.white, fontSize: 30.0),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 70.0),
            child: TextFormField(
              controller: controllerDescripcionCorta,
              maxLines: 3, // Número máximo de líneas visibles
              keyboardType: TextInputType
                  .multiline, // Habilita múltiples líneas en el teclado
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0, // Tamaño de la letra que escribe el usuario
              ),
              decoration: InputDecoration(
                labelText: 'Escribe tus notas aquí',
                labelStyle: TextStyle(color: Colors.white),
                hintStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 20.0),
            child: Text(
              'SUBIR LA IMAGEN PRINCIPAL DE LA PUBLICACION',
              style: TextStyle(color: Colors.white, fontSize: 30.0),
            ),
          ),

          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 2.0),
              borderRadius: BorderRadius.circular(30.0),
            ),
            margin: EdgeInsets.only(bottom: 100.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (_imageBytes != null)
                  Image.memory(_imageBytes!, width: 350, height: 350)
                else if (widget.oldImageUrl.isNotEmpty)
                  Image.network(
                    widget.oldImageUrl,
                    width: 350,
                    height: 350,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        SvgPicture.asset(
                          'assets/images/subir-dos.svg',
                          width: 350,
                          height: 350,
                        ),
                  )
                else
                  SvgPicture.asset(
                    'assets/images/subir-dos.svg',
                    width: 350,
                    height: 350,
                  ),
                Container(
                  margin: const EdgeInsets.only(bottom: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          final imagenSeleccionada = await getImage();
                          if (imagenSeleccionada == null || !mounted) return;
                          final imageBytes =
                              await imagenSeleccionada.readAsBytes();
                          if (!mounted) return;
                          setState(() {
                            image_to_upload = imagenSeleccionada;
                            _imageBytes = imageBytes;
                            _imageUrl = null;
                          });
                        },
                        child: const Text('seleccionar imagen'),
                      ),
                      const SizedBox(width: 20.0),
                      ElevatedButton(
                        onPressed: () async {
                          if (image_to_upload == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Selecciona una imagen primero.'),
                              ),
                            );
                            return;
                          }
                          try {
                            final imageUrl = await uploadImageToFirebaseStorage(
                              image_to_upload!,
                              DateTime.now().microsecondsSinceEpoch.toString(),
                            );
                            if (!mounted) return;
                            setState(() => _imageUrl = imageUrl);
                          } catch (error) {
                            if (!mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('No se pudo subir la imagen: $error'),
                              ),
                            );
                          }
                        },
                        child: const Text('cargar imagen'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Container(
            margin: EdgeInsets.only(bottom: 20.0),
            child: Text(
              'DESCRIPCION COMPLETA DE LA PUBLICACION',
              style: TextStyle(color: Colors.white, fontSize: 30.0),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 70.0),
            child: TextFormField(
              controller: controllerDescripcionCompleta,
              maxLines: 8, // Número máximo de líneas visibles
              keyboardType: TextInputType
                  .multiline, // Habilita múltiples líneas en el teclado
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0, // Tamaño de la letra que escribe el usuario
              ),
              decoration: InputDecoration(
                labelText: 'Escribe tus notas aquí',
                labelStyle: TextStyle(color: Colors.white),
                hintStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Text(
            'SUBIR MAS IMAGENES PARA LA PUBLICACION',
            style: TextStyle(color: Colors.white, fontSize: 30.0),
          ),
          Container(
            padding: EdgeInsets.all(8.0),
            margin: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: MultiImagePickerView(
              controller: controller,
              padding: const EdgeInsets.all(10),
            ),
          ),
          ElevatedButton(
            onPressed: _isSaving
                ? null
                : () async {
                    setState(() => _isSaving = true);
                    try {
                      final imageUrl =
                          _imageUrl ??
                          (image_to_upload != null
                              ? await uploadImageToFirebaseStorage(
                                  image_to_upload!,
                                  DateTime.now().microsecondsSinceEpoch
                                      .toString(),
                                )
                              : widget.oldImageUrl);
                      await _firestoreService.updatePost(
                        widget.oldIdentificador,
                        controllerTitulo.text,
                        controllerDescripcionCorta.text,
                        controllerDescripcionCompleta.text,
                        imageUrl,
                      );
                      /*  controllerTitulo.text,
                        controllerDescripcionCorta.text,
                        controllerDescripcionCompleta.text,
                        imageUrl,
                      );*/
                    } catch (error) {
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('No se pudo editar la publicación: $error'),
                        ),
                      );
                    } finally {
                      if (mounted) setState(() => _isSaving = false);
                    }
                  },
            child: Text(
              'EDITAR POST',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            ),
          ),

          Container(height: 100),
        ],
      ),
    );
  }
}
