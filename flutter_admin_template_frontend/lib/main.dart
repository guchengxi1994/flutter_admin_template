import 'package:flutter/material.dart';
import 'package:flutter_admin_template_frontend/routers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:i18n_extension/i18n_widget.dart';

void main() {
  runApp(ProviderScope(child: I18n(child: const MyApp())));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', "US"),
        Locale('zh', "CN"),
      ],
      debugShowCheckedModeBanner: false,
      navigatorObservers: [FlutterSmartDialog.observer],
      builder: FlutterSmartDialog.init(),
      initialRoute: FatRouters.loginScreen,
      navigatorKey: FatRouters.navigatorKey,
      theme: ThemeData(useMaterial3: true),
      onGenerateRoute: (settings) {
        if (settings.name == null) {
          return null;
        }
        final uri = Uri.parse(settings.name!);
        final page = FatRouters.routers[uri.path];

        if (page != null) {
          return PageRouteBuilder(
              settings: settings,
              pageBuilder: (_, __, ___) => page.call(context),
              transitionsBuilder: (_, anim, __, child) {
                return FadeTransition(
                  opacity: anim,
                  child: child,
                );
              });
        }

        return null;
      },
    );
  }
}
