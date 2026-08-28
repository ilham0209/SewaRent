import 'package:flutter/foundation.dart';

abstract final class AppConstants {
  static const appName = 'SewaRent';

  static const defaultPageSize = 20;

  static String get apiBaseUrl {
    // When running on Android emulator, 10.0.2.2 points to host machine (127.0.0.1)
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      return 'https://10.0.2.2:7062/api';
    }
    return 'https://localhost:7062/api';
  }
}
