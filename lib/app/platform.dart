// lib/app/platform.dart

import 'dart:io';

/// Utility class per rilevare la piattaforma su cui gira l'app
class AppPlatform {
  AppPlatform._();

  static bool get isIOS => Platform.isIOS;
  static bool get isAndroid => Platform.isAndroid;
  static bool get isMacOS => Platform.isMacOS;
  static bool get isWindows => Platform.isWindows;
  static bool get isLinux => Platform.isLinux;
  
  static bool get isDesktop =>
      Platform.isMacOS || Platform.isWindows || Platform.isLinux;
  
  static bool get isMobile => Platform.isIOS || Platform.isAndroid;
}