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
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: context.height - MediaQuery.of(context).padding.top,
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo ve Başlık
                Icon(
                  Icons.spa,
                  size: 80,
                  color: Color(0xff285d63),
                ),
                SizedBox(height: 24),
                Text(
                  "Mutsuz Son",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff285d63),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Giriş Yap",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 48),

                // Giriş Formu
                Form(
                  key: loginFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildTextField(
                        controller: emailController,
                        label: "E-posta",
                        icon: Icons.email_outlined,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "E-posta boş olamaz";
                          } else if (!value.contains("@")) {
                            return "Geçerli bir e-posta adresi giriniz";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      _buildTextField(
                        controller: passwordController,
                        label: "Şifre",
                        icon: Icons.lock_outline,
                        isPassword: true,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Şifre boş olamaz";
                          } else if (value.length < 6) {
                            return "Şifre en az 6 karakter olmalıdır";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 12),

                      // Şifremi Unuttum
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ForgotPassPage(),
                              ),
                            );
                          },
                          child: Text(
                            "Şifremi Unuttum",
                            style: TextStyle(
                              color: Color(0xff285d63),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 24),

                      // Giriş Yap Butonu
                      ElevatedButton(
                        onPressed: wait ? null : () => logIn(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff285d63),
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                        child: wait
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : Text(
                                "Giriş Yap",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword && isHidePassword,
      validator: validator,
      style: TextStyle(color: Color(0xff285d63)),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Color(0xff285d63)),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  isHidePassword ? Icons.visibility : Icons.visibility_off,
                  color: Color(0xff285d63),
                ),
                onPressed: () =>
                    setState(() => isHidePassword = !isHidePassword),
              )
            : null,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xff285d63)),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red),
        ),
        labelStyle: TextStyle(color: Colors.grey[600]),
      ),
    );
  }
}
