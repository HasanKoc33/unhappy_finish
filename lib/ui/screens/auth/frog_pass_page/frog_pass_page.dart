import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sleep/core/providers/frog_pass_cubit.dart';
import 'package:sleep/utils/bildiriler.dart';
import 'package:sleep/utils/extensions.dart';

class ForgotPassPage extends StatelessWidget {
  const ForgotPassPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xff285d63)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Şifremi Unuttum',
          style: TextStyle(
            color: Color(0xff285d63),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // İkon ve Açıklama
                Icon(
                  Icons.lock_reset,
                  size: 80,
                  color: Color(0xff285d63),
                ),
                SizedBox(height: 24),
                Text(
                  'Şifre Sıfırlama',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff285d63),
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'E-posta adresinizi girin, size şifre sıfırlama bağlantısı gönderelim.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 48),

                // Form
                Builder(builder: (context) {
                  var state = context.watch<FrogPassCubit>().state;
                  return Form(
                    key: context.read<FrogPassCubit>().formKey,
                    autovalidateMode: state is FrogPassValidate
                        ? state.isFrogPassFail
                            ? AutovalidateMode.always
                            : AutovalidateMode.disabled
                        : AutovalidateMode.disabled,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // E-posta alanı
                        TextFormField(
                          controller:
                              context.read<FrogPassCubit>().emailController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "E-posta boş olamaz";
                            } else if (!value.contains("@")) {
                              return "Geçerli bir e-posta adresi giriniz";
                            }
                            return null;
                          },
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(color: Color(0xff285d63)),
                          decoration: InputDecoration(
                            labelText: "E-posta",
                            prefixIcon: Icon(Icons.email_outlined,
                                color: Color(0xff285d63)),
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
                        ),
                        SizedBox(height: 24),

                        // Gönder butonu
                        BlocConsumer<FrogPassCubit, FrogPassState>(
                          listener: (context, state) {
                            if (state is FrogPassError) {
                              bildiri(context, state.message);
                            } else if (state is FrogPassSuccess) {
                              mesaj(state.message!);
                              Navigator.pop(context);
                            }
                          },
                          builder: (context, state) {
                            return ElevatedButton(
                              onPressed: state is FrogPassLoading
                                  ? null
                                  : () =>
                                      context.read<FrogPassCubit>().frogPass(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xff285d63),
                                padding: EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 2,
                              ),
                              child: state is FrogPassLoading
                                  ? SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                      ),
                                    )
                                  : Text(
                                      'Gönder',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
