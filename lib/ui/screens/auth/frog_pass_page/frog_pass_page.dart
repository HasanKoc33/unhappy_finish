import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sleep/core/providers/frog_pass_cubit.dart';
import 'package:sleep/utils/bildiriler.dart';
import 'package:sleep/utils/extensions.dart';


class ForgotPassPage extends StatelessWidget {
  const ForgotPassPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: bodyWidget(size, context),
    );
  }

  Widget bodyWidget(Size size, BuildContext context) {
    return Center(
      child: Container(
        width: size.width > 800 ? 500 : size.width * .9,
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
        child: Builder(builder: (context) {
          var state = context.watch<FrogPassCubit>().state;
          return Form(
            key: context.read<FrogPassCubit>().formKey,
            autovalidateMode: state is FrogPassValidate
                ? state.isFrogPassFail
                    ? AutovalidateMode.always
                    : AutovalidateMode.disabled
                : AutovalidateMode.disabled,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: const [
                    BackButton(),
                    Padding(
                      padding: EdgeInsets.all(6.0),
                      child: Text(
                        "Şifremi Unuttum",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 15, left: 15, top: 50),
                  child: TextFormField(
                    controller: context.read<FrogPassCubit>().emailController,
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
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary),
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.tertiary),
                          borderRadius: BorderRadius.circular(5)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary),
                          borderRadius: BorderRadius.circular(5)),
                      labelText: "Email",
                      labelStyle: TextStyle(
                        color: context.colorScheme.secondary,
                      ),
                    ),
                    cursorColor: context.colorScheme.secondary,
                  ),
                ),
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
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      child: InkWell(
                        onTap: state is FrogPassLoading
                            ? null
                            : () => context.read<FrogPassCubit>().frogPass(),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.only(
                                left: 30, right: 30, top: 15, bottom: 15),
                            child: Text(
                              "Gönder",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
