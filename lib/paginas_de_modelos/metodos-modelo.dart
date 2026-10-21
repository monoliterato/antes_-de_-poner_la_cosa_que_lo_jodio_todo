import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

final FirebaseStorage _storage = FirebaseStorage.instance;

Future<PlatformFile?> seleccionarModelo3D() async {
  final files = await FilePicker.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['glb'],
  );

  if (files.isEmpty) {
    return null;
  }

  final model = files.single;
  if (model.extension?.toLowerCase() != 'glb') {
    throw const FormatException('El modelo debe estar en formato GLB.');
  }

  return model;
}

Future<String> subirModelo3DAFirebase(
  PlatformFile model,
  String modelId,
) async {
  if (modelId.trim().isEmpty) {
    throw ArgumentError.value(modelId, 'modelId', 'No puede estar vacío.');
  }
  if (model.extension?.toLowerCase() != 'glb') {
    throw const FormatException('El modelo debe estar en formato GLB.');
  }

  final bytes = await model.readAsBytes();
  if (bytes.isEmpty) {
    throw ArgumentError.value(
      model.name,
      'model',
      'El archivo no contiene datos para subir.',
    );
  }

  final modelRef = _storage.ref().child('modelos/$modelId/${model.name}');
  await modelRef.putData(
    bytes,
    SettableMetadata(contentType: 'model/gltf-binary'),
  );
  return modelRef.getDownloadURL();
}

//fin de los metodos para subir el elemento 3d

//inicio para subir los metodos de imagen

//clase para manejar la subida de imagenes a Firebase Storage

Future<String> uploadImageToFirebaseStorage(
  XFile image,
  String imageModeloId,
) async {
  final Reference storageRef = _storage.ref().child(
    'modelo_images/$imageModeloId-${image.name}',
  );
  await storageRef.putData(
    await image.readAsBytes(),
    SettableMetadata(contentType: image.mimeType),
  );
  return storageRef.getDownloadURL();
}

//clase para manejar la seleccion de imagenes desde la galeria del dispositivo

Future<XFile?> getImage() async {
  final ImagePicker picker = ImagePicker();
  return picker.pickImage(source: ImageSource.gallery);
}

//fin metodos para imagen

//datos literales

class ModeloFirestoreService {
  final CollectionReference<Map<String, dynamic>> modelos = FirebaseFirestore
      .instance
      .collection('modelos');

  Future<void> agregarModelo({
    required String titulo,
    required String descripcionCorta,
    required String descripcionCompleta,
    required String modeloUrl,
    required String modelImageUrl,
  }) async {
    await modelos.add({
      'titulo': titulo,
      'descripcionCorta': descripcionCorta,
      'descripcionCompleta': descripcionCompleta,
      'modeloUrl': modeloUrl,
      'modelImageUrl': modelImageUrl,
      'timestamp': Timestamp.now(),
    });
  }


//obtener los datos


  Stream<QuerySnapshot<Map<String, dynamic>>> getModeloStream() {
    return modelos.orderBy('timestamp', descending: true).snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getModeloById(String id) {
    return modelos.doc(id).snapshots();
  }

  //Update
  Future<void> updatePost(
    String docId,
    String newTitulo,
    String newDescripcionCorta,
    String newDescripcionCompleta,
    String newModelImageUrl,
  ) {
    return modelos.doc(docId).update({
      'titulo': newTitulo,
      'descripcionCorta': newDescripcionCorta,
      'descripcionCompleta': newDescripcionCompleta,
      'modelImageUrl': newModelImageUrl,
      'timestamp': Timestamp.now(),
    });
  }

  //Delete
  Future<void> deletePost(String docId) {
    return modelos.doc(docId).delete();
  }
}
