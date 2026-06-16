import 'package:flutter/material.dart';

import '../../../core/widgets/app_scaffold.dart';
import '../../achievements/presentation/achievements_screen.dart';
import '../../home/presentation/home_screen.dart';
import '../../map/presentation/map_explorer_screen.dart';
import '../../profile/presentation/profile_screen.dart';
import '../../routes/presentation/routes_screen.dart';
import 'app_bottom_navigation.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  var index = 0;

  final pages = const [
    HomeScreen(),
    MapExplorerScreen(),
    RoutesScreen(),
    AchievementsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      bottomNavigationBar: AppBottomNavigation(
        currentIndex: index,
        onTap: (nextIndex) => setState(() => index = nextIndex),
      ),
      child: IndexedStack(index: index, children: pages),
    );
  }
}
