import 'package:flutter/material.dart';
import 'package:flutter_admin_template_frontend/routers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      routes: FatRouters.routers,
      initialRoute: FatRouters.loginScreen,
    );
  }
}
