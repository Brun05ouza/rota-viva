import 'package:flutter/material.dart';

import '../features/points/presentation/point_details_screen.dart';
import '../features/routes/presentation/route_details_screen.dart';
import '../features/splash/presentation/splash_screen.dart';

class AppRoutes {
  static const splash = '/';
  static const onboarding = '/onboarding';
  static const main = '/main';
  static const routeDetails = '/route-details';
  static const pointDetails = '/point-details';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
          settings: settings,
        );
      case routeDetails:
        return MaterialPageRoute(
          builder: (_) =>
              RouteDetailsScreen(routeId: settings.arguments! as String),
          settings: settings,
        );
      case pointDetails:
        return MaterialPageRoute(
          builder: (_) =>
              PointDetailsScreen(pointId: settings.arguments! as String),
          settings: settings,
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
          settings: settings,
        );
    }
  }
}
