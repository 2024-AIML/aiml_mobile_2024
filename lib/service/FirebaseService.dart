import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  static FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<bool> login(String id, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: id,
        password: password,
      );
      return userCredential.user != null;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

// Implement other Firebase related functionalities here
}
