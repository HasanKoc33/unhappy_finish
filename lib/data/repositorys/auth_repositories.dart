import 'package:firebase_auth/firebase_auth.dart';
import 'package:sleep/data/services/auth_service.dart';

class AuthRepositories {

  login({required String email, required String password}) async {
    await AuthService.instance.singIn(email: email, password: password);
  }

  singOut() async {
    await AuthService.instance.singOut();
  }

  resetPassword({required String email}) async {
    await AuthService.instance.resetPassword(email: email);
  }
}
