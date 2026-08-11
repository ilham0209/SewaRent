import 'package:flutter/material.dart';

import '../features/property/domain/entities/property.dart';
import '../features/property/presentation/pages/property_detail_page.dart';
import 'main_shell.dart';

abstract final class AppRoutes {
  static const home = '/';
  static const propertyDetail = '/property/:id';
}

abstract final class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.propertyDetail:
        final property = settings.arguments as Property;
        return MaterialPageRoute<void>(
          builder: (_) => PropertyDetailPage(property: property),
          settings: settings,
        );
      case AppRoutes.home:
      default:
        return MaterialPageRoute<void>(
          builder: (_) => const MainShell(),
          settings: settings,
        );
    }
  }
}
