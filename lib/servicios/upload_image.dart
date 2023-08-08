import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

final FirebaseStorage storage = FirebaseStorage.instance;
FirebaseFirestore db = FirebaseFirestore.instance;

Future<bool> uploadImagen(File image) async {
  print(image.path);
  final String namefile = image.path.split("/").last;
  Reference ref = storage.ref().child('imagenes').child(namefile);
  final UploadTask uploadTask = ref.putFile(image);
  print(uploadTask);
  final TaskSnapshot snapshot = await uploadTask.whenComplete(() => true);
  print(snapshot);
  final String url = await snapshot.ref.getDownloadURL();

  print(url);

  await db.collection('salas').add(({"url_imagen": url}));

  if (snapshot.state == TaskState.success) {
    return true;
  } else {
    return false;
  }
}
