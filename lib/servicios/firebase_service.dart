import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

//funcion que nos trae la información de las salas que se crean en firebase

Future<List> getSalas() async {
  List salas = [];
  QuerySnapshot queryPersonas = await db
      .collection('salas')
      .get(); //esta linea trae toda la colección de salas contenidas en firebase

  for (var doc in queryPersonas.docs) {
    final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    final sala = {
      //se crea un objeto sala la cual puede tener mas propiedades y eso es lo que importa
      "nombre": data['nombre'],
      "uid": doc.id,
      "capacidad": data['capacidad'],
      "descripcion": data['descripcion'],
      "ubicacion": data['ubicacion'],
      "alto_sala": data['alto_sala'],
      "ancho_sala": data['ancho_sala'],
      "largo_sala": data['largo_sala'],
      "actividades_admitidas": data['actividades_admitidas'],
      //-----------------------------------
      // "estado": data['estado'],
      // "urlImagen": data['urlImagen']
    };
    salas.add(sala);
  }

  return salas;
}

//añadir salas a la base de datos
Future<void> addSalas(
  String name,
  int capacity,
  String description,
  String ubication,
  int large,
  int ancho,
  int alto,
  List<String> listaActividades,
  //--------------------------
  String estado,
  //String urlImagen,
  //--------------------------
) async {
  await db.collection('salas').add({
    "nombre": name,
    "capacidad": capacity,
    "descripcion": description,
    "ubicacion": ubication,
    "largo_sala": large,
    "ancho_sala": ancho,
    "alto_sala": alto,
    "actividades_admitidas": listaActividades,
//------------------------------------------------
    "estado": estado,
    //"url_imagen": urlImagen
  });
}

//actualizar el nombre de la persona en la base de datos
Future<void> updateSalas(
    String uid,
    String nuevoNombre,
    int nuevaCapacidad,
    String nuevaDescripcion,
    String nuevaUbicacion,
    int nuevoLargo,
    int nuevoAncho,
    int nuevoAlto,
    List<String> nuevasActividades) async {
  await db.collection('salas').doc(uid).set({
    'nombre': nuevoNombre,
    'descripcion': nuevaDescripcion,
    'capacidad': nuevaCapacidad,
    'ubicacion': nuevaUbicacion,
    'largo_sala': nuevoLargo,
    'ancho_sala': nuevoAncho,
    'alto_sala': nuevoAlto,
    'actividades_admitidas': nuevasActividades
  });
}

Future<void> deleteSalas(String uid) async {
  await db.collection('salas').doc(uid).delete();
}

//------------------------------------------------------------------
