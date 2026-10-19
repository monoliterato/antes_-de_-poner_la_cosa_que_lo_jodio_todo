import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';

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








//datos literales




class ModeloFirestoreService {
  final CollectionReference<Map<String, dynamic>> modelos = FirebaseFirestore
      .instance
      .collection('modelos');

  Future<DocumentReference<Map<String, dynamic>>> agregarModelo({
    required String titulo,
    required String descripcionCorta,
    required String descripcionCompleta,
    required String modeloUrl,
  }) {
    return modelos.add({
      'titulo': titulo,
      'descripcionCorta': descripcionCorta,
      'descripcionCompleta': descripcionCompleta,
      'modeloUrl': modeloUrl,
      'timestamp': Timestamp.now(),
    });
  }
}
