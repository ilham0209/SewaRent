import 'dart:io';

void setupDevHttpOverrides() {
  HttpOverrides.global = DevHttpOverrides();
}

class DevHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (cert, host, port) => true;
  }
}
