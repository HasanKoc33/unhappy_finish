import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:sleep/core/providers/auth_provider.dart';
import 'package:sleep/core/providers/frog_pass_cubit.dart';
import 'package:sleep/core/providers/porsonel_provider.dart';
import 'package:sleep/core/providers/sube_provider.dart';
import 'package:sleep/ui/screens/home/home_screen.dart';

/// App ekranı
@immutable
final class App extends StatelessWidget {
  /// App yapıcı methot
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (_) => SubeProvider()..listen()),
          ChangeNotifierProvider(create: (_) => PersonelProvider()..listen()),
          BlocProvider(create: (_) => FrogPassCubit()),
        ],
        child: MaterialApp(
          title: 'Sleep',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: Color(0xff285d63),
          ),
          home: const HomeScreen(),
        ));
  }
}
