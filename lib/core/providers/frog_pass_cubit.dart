import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class FrogPassCubit extends Cubit<FrogPassState> {
  FrogPassCubit() : super(FrogPassInitial());
  TextEditingController? emailController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey();

  bool isFrogPassFail = false;

  void frogPass() async {
    emit(FrogPassLoading());
    try {
      if (formKey.currentState!.validate()) {
        final authRepositories = FirebaseAuth.instance;
        await authRepositories.sendPasswordResetEmail(
          email: emailController!.text,
        );
        emit(FrogPassSuccess(message: "Şifre Sıfırlama Maili Gönderildi"));
      } else {
        isFrogPassFail = true;
        emit(FrogPassValidate(isFrogPassFail: isFrogPassFail));
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == "inivalid-email") {
        emit(FrogPassError(message: "Geçersiz Email"));
      } else if (e.code == "email-already-in-use") {
        emit(FrogPassError(message: "Email Kullanımda"));
      } else if (e.code == "weak-password") {
        emit(FrogPassError(message: "Şifre Zayıf"));
      } else {
        emit(FrogPassError(message: "Başarısız"));
      }
    }
  }
}


@immutable
abstract class FrogPassState {}

class FrogPassInitial extends FrogPassState {}

class FrogPassValidate extends FrogPassState {
  final bool isFrogPassFail;
  FrogPassValidate({required this.isFrogPassFail});
}

class FrogPassLoading extends FrogPassState {}

class FrogPassSuccess extends FrogPassState {
  String? message;
  FrogPassSuccess({required this.message});
}

class FrogPassError extends FrogPassState {
  final String message;
  FrogPassError({required this.message});
}

