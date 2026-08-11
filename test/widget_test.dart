import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sewa_rent/app/app.dart';

void main() {
  testWidgets('app shows the home screen with bottom navigation', (
    tester,
  ) async {
    await tester.pumpWidget(const SewaRentApp());
    await tester.pumpAndSettle();

    expect(find.text('Find your next home'), findsOneWidget);
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Favourites'), findsOneWidget);
    expect(find.text('Requests'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
  });

  testWidgets('property card opens the property details screen', (
    tester,
  ) async {
    await tester.pumpWidget(const SewaRentApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Recommended for you'));
    await tester.pumpAndSettle();

    expect(
      find.text('Modern 2-Bedroom Apartment in Mont Kiara'),
      findsOneWidget,
    );

    await tester.tap(find.text('Modern 2-Bedroom Apartment in Mont Kiara'));
    await tester.pumpAndSettle();

    expect(find.text('Property Details'), findsOneWidget);
    expect(find.text('Request to Rent'), findsOneWidget);
  });
}
