import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app/app.dart';

void main() async {
  // Assicura l'inizializzazione di Flutter
  WidgetsFlutterBinding.ensureInitialized();
  
  // Gestisci errori Flutter
  FlutterError.onError = (FlutterErrorDetails details) {
    // Ignora l'errore specifico di ViewInsets su web
    if (details.exception.toString().contains('ViewInsets')) {
      return;
    }
    FlutterError.presentError(details);
  };
  
  // Configura orientamento (solo portrait)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Configura status bar
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  
  runApp(const EatWiseApp());
}