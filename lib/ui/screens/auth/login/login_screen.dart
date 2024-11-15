import 'package:flutter/material.dart';
import 'package:sleep/utils/extensions.dart';

import '../frog_pass_page/frog_pass_page.dart';
import 'login_screen_mixin.dart';

/// LoginScreen ekranı
class LoginScreen extends StatefulWidget {
  /// LoginScreen ekranı
  const LoginScreen({this.password, this.email, super.key});

  final String? email;
  final String? password;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with LoginScreenMixin {
  bool isHidePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: bodyWidget(context),
    );
  }

  Widget bodyWidget(BuildContext context) {
    return Container(
      height: context.height,
      color: context.theme.scaffoldBackgroundColor,
      child: Container(
        width: context.width > 800 ? 500 : context.width,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: BorderRadius.circular(5),
          shape: BoxShape.rectangle,
          boxShadow: const [
            BoxShadow(
              color: Colors.black,
              blurRadius: 20.0,
              spreadRadius: 0.0,
              offset: Offset(0.0, 0.0), // shadow direction: bottom right
            )
          ],
        ),
        child: Center(
          child: Builder(builder: (context) {
            return Form(
              key: loginFormKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(6.0),
                    child: Text(
                      "Giriş Yap",
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 15, left: 15),
                    child: TextFormField(
                      controller: emailController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Email boş olamaz";
                        } else if (!value.contains("@")) {
                          return "Email geçersiz";
                        } else {
                          return null;
                        }
                      },
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
                        ),
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.tertiary), borderRadius: BorderRadius.circular(5)),
                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.primary), borderRadius: BorderRadius.circular(5)),
                        labelText: "Email",
                        labelStyle: const TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      cursorColor: Colors.black,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 15, left: 15, top: 20),
                    child: TextFormField(
                      controller: passwordController,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: isHidePassword,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Şifre boş olamaz";
                        } else if (value.length < 6) {
                          return "Şifre en az 6 karakter olmalıdır";
                        } else {
                          return null;
                        }
                      },
                      onFieldSubmitted: (value) {
                        logIn();
                      },
                      decoration: InputDecoration(
                        suffix: InkWell(
                          onTap: () {
                            setState(() {
                              isHidePassword = !isHidePassword;
                            });
                          },
                          child: Icon(
                            isHidePassword ? Icons.visibility : Icons.visibility_off,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
                        ),
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.tertiary), borderRadius: BorderRadius.circular(5)),
                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.primary), borderRadius: BorderRadius.circular(5)),
                        labelText: "Şifre",
                        labelStyle: const TextStyle(
                          color: Colors.black,
                        ),
                        alignLabelWithHint: true,
                      ),
                      cursorColor: Colors.black,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const ForgotPassPage()));
                          },
                          child: Text(
                            "Şifremi Unuttum...",
                            style: TextStyle(fontSize: 15, color: Theme.of(context).colorScheme.primary),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20.0),
                    child: InkWell(
                      onTap: wait ? null : () => logIn(),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 15.0),
                            child: wait
                                ? CircularProgressIndicator(
                                    color: context.colorScheme.background,
                                  )
                                : Text(
                                    "Giriş yap",
                                    style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                                  ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
