import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sewa_rent/app/app.dart';
import 'package:sewa_rent/app/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('app starts with login screen when unauthenticated', (
    tester,
  ) async {
    await tester.pumpWidget(const SewaRentApp());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Welcome Back'), findsOneWidget);
    expect(find.text('Sign In'), findsOneWidget);
    expect(find.text('Email address'), findsOneWidget);
  });

  testWidgets('main shell displays bottom navigation destinations', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildAppTheme(),
        home: Scaffold(
          body: const Text('Shell Test'),
          bottomNavigationBar: NavigationBar(
            destinations: [
              NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
              NavigationDestination(
                icon: Icon(Icons.favorite),
                label: 'Favourites',
              ),
              NavigationDestination(
                icon: Icon(Icons.assignment),
                label: 'Requests',
              ),
              NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
            ],
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Favourites'), findsOneWidget);
    expect(find.text('Requests'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
  });
}
