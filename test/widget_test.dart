import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:rota_viva/app/app.dart';

void main() {
  Future<void> pumpApp(WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: RotaVivaApp()));
  }

  Future<void> skipSplash(WidgetTester tester) async {
    await tester.pump(const Duration(milliseconds: 2100));
    await tester.pump(const Duration(milliseconds: 100));
  }

  Future<void> pumpTransition(WidgetTester tester) async {
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump(const Duration(milliseconds: 100));
  }

  testWidgets('renders splash shell', (tester) async {
    SharedPreferences.setMockInitialValues({});

    await pumpApp(tester);

    expect(find.text('Rota Viva'), findsOneWidget);
  });

  testWidgets('completes onboarding and opens the main navigation', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});

    await pumpApp(tester);
    await skipSplash(tester);

    expect(find.text('Descubra rotas incríveis'), findsOneWidget);

    await tester.tap(find.text('Continuar'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continuar'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Começar exploração'));
    await pumpTransition(tester);

    expect(find.text('Explore sua próxima rota'), findsOneWidget);
    expect(find.text('Mapa'), findsOneWidget);
    expect(find.text('Rotas'), findsOneWidget);
    expect(find.text('Conquistas'), findsOneWidget);
    expect(find.text('Perfil'), findsOneWidget);
  });

  testWidgets('navigates through the main app sections', (tester) async {
    SharedPreferences.setMockInitialValues({
      'user_progress': jsonEncode({'onboardingSeen': true}),
    });

    await pumpApp(tester);
    await skipSplash(tester);

    await tester.tap(find.byKey(const ValueKey('nav-routes')));
    await pumpTransition(tester);
    expect(find.byKey(const ValueKey('routes-screen')), findsOneWidget);
    expect(find.text('Buscar rota'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('nav-map')));
    await pumpTransition(tester);
    expect(find.byKey(const ValueKey('map-screen')), findsOneWidget);
    expect(find.text('Centralizar localização'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('nav-achievements')));
    await pumpTransition(tester);
    expect(find.byKey(const ValueKey('achievements-screen')), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('nav-profile')));
    await pumpTransition(tester);
    expect(find.byKey(const ValueKey('profile-screen')), findsOneWidget);
    expect(find.text('Viajante Anônimo'), findsOneWidget);
  });

  testWidgets('main shell fits a compact phone viewport', (tester) async {
    SharedPreferences.setMockInitialValues({
      'user_progress': jsonEncode({'onboardingSeen': true}),
    });
    tester.view.physicalSize = const Size(360, 780);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await pumpApp(tester);
    await skipSplash(tester);

    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.text('Explore sua próxima rota'), findsOneWidget);
  });
}
