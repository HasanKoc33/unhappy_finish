import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sleep/core/providers/auth_provider.dart';
import 'package:sleep/data/repositorys/auth_repositories.dart';
import 'package:sleep/ui/screens/auth/login/login_screen.dart';
import 'package:sleep/ui/screens/home/home_screen.dart';
import 'package:sleep/utils/bildiriler.dart';

/// LoginScreen mixin sınıfı
mixin LoginScreenMixin on State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final AuthRepositories _authRepositories = AuthRepositories();
  final GlobalKey<FormState> loginFormKey = GlobalKey();

  bool wait = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.email != null) {
      emailController.text = widget.email!;
      passwordController.text = widget.password!;
      setState(() {
      });
    // logIn();
    }
  }


  void logIn() async {
    setState(() {
      wait = true;
    });
    try {
      if (loginFormKey.currentState!.validate()) {
        await _authRepositories.login(
            email: emailController.text, password: passwordController.text);
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('email', emailController.text);
        prefs.setString('password', passwordController.text);

        forward();
      } else {
        setState(() {
          wait = false;
        });
        hataBildiri(context,"Giriş Başarısız.");
      }
    } catch (e) {
      print('HATAA : $e');
      setState(() {
        wait = false;
      });
      hataBildiri(context,"Giriş Başarısız!");
    }
  }


  Future<void> forward() async {
   Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ),
   );
  }


}
