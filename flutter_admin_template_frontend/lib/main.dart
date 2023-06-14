import 'package:flutter/material.dart';
import 'package:flutter_admin_template_frontend/routers.dart';
import 'package:provider/provider.dart';
import 'controllers/global_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WidgetAuthController()..init()),
        ChangeNotifierProvider(create: (_) => RouterAuthController()..init()),
        ChangeNotifierProvider(create: (_) => MenuAuthController()..init()),
      ],
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          routes: FatRouters.routers,
          initialRoute: FatRouters.loginScreen,
        );
      },
    );
  }
}
