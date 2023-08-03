import 'package:firebase_auth/firebase_auth.dart';

import 'package:google_sign_in/google_sign_in.dart';

//aun no lo implemento me dio cuco 21/07/2023
class ServiciosGoogle {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Realizar el inicio de sesión con Google
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      // Obtener las credenciales de acceso de Google
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await googleSignIn.signOut();

      // Iniciar sesión con las credenciales de Google en Firebase
      final UserCredential userCredential =
          await auth.signInWithCredential(credential);

      // Retornar las credenciales de usuario
      return userCredential;
    } catch (e) {
      // Manejar cualquier error durante el inicio de sesión
      print('Error en inicio de sesión con Google: $e');
      return null;
    }
  }
}
