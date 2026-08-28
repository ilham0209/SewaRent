import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'app/app.dart';
import 'core/network/dev_http_overrides.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb && kDebugMode) {
    setupDevHttpOverrides();
  }

  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    if (kDebugMode) {
      debugPrint('FlutterError: ${details.exceptionAsString()}');
      debugPrint('${details.stack}');
    }
  };

  if (kDebugMode) debugPrint('Starting SewaRentApp...');
  runApp(const SewaRentApp());
}
