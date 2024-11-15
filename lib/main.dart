import 'package:flutter/material.dart';
import 'package:sleep/core/app/app.dart';
import 'package:sleep/core/app/app_init.dart';

Future<void> main() async{
  await AppInit.instance.init();
  runApp(const App());
}

