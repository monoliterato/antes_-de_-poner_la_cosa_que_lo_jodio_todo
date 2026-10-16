import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:multi_image_picker_view/multi_image_picker_view.dart';

final FirebaseStorage storage = FirebaseStorage.instance;

//clase para manejar la subida de imagenes a Firebase Storage

Future<String> uploadImageToFirebaseStorage(XFile image, String postId) async {
  final Reference storageRef = storage.ref().child(
    'post_images/$postId-${image.name}',
  );
  await storageRef.putFile(File(image.path));
  return storageRef.getDownloadURL();
}

//clase para manejar la seleccion de imagenes desde la galeria del dispositivo

Future<XFile?> getImage() async {
  final ImagePicker picker = ImagePicker();
  final XFile? image = await picker.pickImage(source: ImageSource.gallery);
  if (image != null) {
    // Aquí puedes manejar la imagen seleccionada, por ejemplo, subirla a Firebase Storage
    return image;
  } else {
    print('No se seleccionó ninguna imagen.');
  }
}

//clase para manejar la conexion con firestore y realizar las operaciones CRUD

class firestoreService {
  //get
  final CollectionReference posts = FirebaseFirestore.instance.collection(
    'posts',
  );
  //Create
  Future<void> addPost(
    String titulo,
    String descripcionCorta,
    String descripcionCompleta,
    String imageUrl,
  ) async {
    await posts.add({
      'titulo': titulo,
      'descripcionCorta': descripcionCorta,
      'descripcionCompleta': descripcionCompleta,
      'imagenUrl': imageUrl,
      'timestamp': Timestamp.now(),
    });
  }

  //Read
  Stream<QuerySnapshot> getPostsStream() {
    final postsStream = posts
        .orderBy('timestamp', descending: true)
        .snapshots();
    return postsStream;
  }

  //Update
  Future<void> updatePost(
    String docId,
    String newTitulo,
    String newDescripcionCorta,
    String newDescripcionCompleta,
    String newImageUrl,
  ) {
    return posts.doc(docId).update({
      'titulo': newTitulo,
      'descripcionCorta': newDescripcionCorta,
      'descripcionCompleta': newDescripcionCompleta,
      'imageUrl':newImageUrl,
      'timestamp': Timestamp.now(),
    });
  }

  //Delete
  Future<void> deletePost(String docId) {
    return posts.doc(docId).delete();
  }
}
