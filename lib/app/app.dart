import 'package:flutter/material.dart';

import '../core/constants/app_constants.dart';
import 'router.dart';
import 'theme.dart';

class SewaRentApp extends StatelessWidget {
  const SewaRentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      theme: buildAppTheme(),
      initialRoute: AppRoutes.home,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}
