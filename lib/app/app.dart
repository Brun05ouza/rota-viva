import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/config/app_identity.dart';
import '../core/theme/app_theme.dart';
import '../features/navigation/presentation/main_navigation.dart';
import '../features/onboarding/presentation/onboarding_screen.dart';
import 'routes.dart';

class RotaVivaApp extends ConsumerWidget {
  const RotaVivaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppIdentity.name,
      theme: AppTheme.dark(),
      initialRoute: AppRoutes.splash,
      onGenerateRoute: AppRoutes.onGenerateRoute,
      routes: {
        AppRoutes.onboarding: (_) => const OnboardingScreen(),
        AppRoutes.main: (_) => const MainNavigation(),
      },
    );
  }
}