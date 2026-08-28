import 'package:flutter/material.dart';

import '../../../../app/router.dart';
import '../../../../core/app_services.dart';
import 'login_page.dart';
import 'register_page.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  var _hasToken = false;
  var _showRegister = false;
  var _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final token = await AppServices.tokenStorage.readAccessToken();
    if (!mounted) return;
    setState(() {
      _hasToken = token != null && token.isNotEmpty;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (!_hasToken) {
      if (_showRegister) {
        return RegisterPage(
          onSwitchToLogin: () => setState(() => _showRegister = false),
          onRegisterSuccess: () {
            setState(() {
              _showRegister = false;
              _hasToken = true;
            });
          },
        );
      }
      return LoginPage(
        onSwitchToRegister: () => setState(() => _showRegister = true),
        onLoginSuccess: () => setState(() => _hasToken = true),
      );
    }

    return const MainShell();
  }
}
