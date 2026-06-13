import 'dart:io';
import 'package:flutter/foundation.dart';

class AppConstants {

  static const bool usePhysical = false;
  static const String physicalDeviceIp = '192.168.1.45';

  static String get baseUrl {
    if (!kDebugMode) {
      return 'https://admin.savioursfinance.com';
    }
    if (usePhysical) {
      return 'http://$physicalDeviceIp:8000';
    }
    if (kIsWeb) {
      return 'http://localhost:8000';
    }
    try {
      if (Platform.isAndroid) {
        return 'http://10.0.2.2:8000';
      }
    } catch (_) {}
    return 'http://127.0.0.1:8000';
  }

  static String get apiBaseUrl => '$baseUrl/api';
}