import 'package:flutter/material.dart';
import 'package:solar_cell_monitoring_app/pages/splash_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MaterialApp(
    home: SplashPage(),
    debugShowCheckedModeBanner: false,
    localizationsDelegates: [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: [
      Locale('en', 'US'),
      Locale('th'),
    ],
  ));
}
