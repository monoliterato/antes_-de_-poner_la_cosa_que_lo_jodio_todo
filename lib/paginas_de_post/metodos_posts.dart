import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';


final FirebaseStorage storage = FirebaseStorage.instance;

Future<bool> uploadImageToFirebaseStorage(XFile image, String postId) async {
  try {
    // Crear una referencia al archivo en Firebase Storage
    Reference storageRef = storage.ref().child('post_images/$postId/${image.name}');

    // Subir la imagen a Firebase Storage
    UploadTask uploadTask = storageRef.putFile(File(image.path));

    // Esperar a que la subida se complete
    await uploadTask;

    // Obtener la URL de descarga de la imagen
    String downloadUrl = await storageRef.getDownloadURL();

    // Aquí puedes guardar la URL de descarga en Firestore si lo deseas
    print('Imagen subida con éxito. URL de descarga: $downloadUrl');
    return true;
  } catch (e) {
    print('Error al subir la imagen: $e');
    return false;
  }
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

class fireStoreService{


//get
final CollectionReference posts = FirebaseFirestore.instance.collection('posts');
//Create
Future<void> addPost(String titulo, String descripcionCorta, String descripcionCompleta) async {
  await posts.add({
    'titulo': titulo,
    'descripcionCorta': descripcionCorta,
    'descripcionCompleta': descripcionCompleta,
    'timestamp': Timestamp.now(),
  });
}

//Read
Stream<QuerySnapshot> getPostsStream(){
  final postsStream =
  posts.orderBy('timestamp',descending: true).snapshots();
return postsStream;
}
//Update
Future<void> updatePost(String docId,String newTitulo, String newDescripcionCorta, String newDescripcionCompleta) {
  return posts.doc(docId).update({
    'titulo': newTitulo,
    'descripcionCorta': newDescripcionCorta,
    'descripcionCompleta': newDescripcionCompleta,
    'timestamp':Timestamp.now(),
  });
}

//Delete
Future<void> deletePost(String docId) {
  return posts.doc(docId).delete();


}}