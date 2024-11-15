import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  AuthService._();

  static AuthService? _instance;

  static AuthService get instance => _instance ??= AuthService._();


  bool isSignedIn() => FirebaseAuth.instance.currentUser != null;

  /// mevcut kullanıcının id si ni döndürür
  String? get uid => FirebaseAuth.instance.currentUser?.uid;

  Future<void> singIn({required String email, required String password}) async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .catchError((e) => throw e);
  }

   Future<UserCredential> singUp(
      {required String email, required String password}) async {
    return FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .catchError((e) => throw e);
  }

  Future<void> singOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<void> resetPassword({required String email}) async {
    await FirebaseAuth.instance
        .sendPasswordResetEmail(email: email)
        .catchError((e) => throw e);
  }




  String? getUserId() => FirebaseAuth.instance.currentUser?.uid;

}
