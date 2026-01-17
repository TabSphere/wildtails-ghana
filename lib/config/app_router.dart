import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/splash_screen.dart';
import '../screens/home_screen.dart';
import '../screens/explore_screen.dart';
import '../screens/tours_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/park_detail_screen.dart';
import '../screens/map_screen.dart';
import '../screens/report_screen.dart';
import '../screens/education_screen.dart';
import '../screens/settings_screen.dart';

class AppRoutes {
  static const splash = '/';
  static const home = '/home';
  static const explore = '/explore';
  static const tours = '/tours';
  static const profile = '/profile';
  static const map = '/map';
  static const report = '/report';
  static const education = '/education';
  static const settings = '/settings';
}

final appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(path: AppRoutes.splash, builder: (_, __) => const SplashScreen()),
    
    ShellRoute(
      builder: (_, __, child) => MainShell(child: child),
      routes: [
        GoRoute(path: AppRoutes.home, pageBuilder: (_, __) => const NoTransitionPage(child: HomeScreen())),
        GoRoute(path: AppRoutes.explore, pageBuilder: (_, __) => const NoTransitionPage(child: ExploreScreen())),
        GoRoute(path: AppRoutes.tours, pageBuilder: (_, __) => const NoTransitionPage(child: ToursScreen())),
        GoRoute(path: AppRoutes.profile, pageBuilder: (_, __) => const NoTransitionPage(child: ProfileScreen())),
      ],
    ),
    
    GoRoute(path: '/park/:id', builder: (_, state) => ParkDetailScreen(parkId: state.pathParameters['id']!)),
    GoRoute(path: AppRoutes.map, builder: (_, __) => const MapScreen()),
    GoRoute(path: AppRoutes.report, builder: (_, __) => const ReportScreen()),
    GoRoute(path: AppRoutes.education, builder: (_, __) => const EducationScreen()),
    GoRoute(path: AppRoutes.settings, builder: (_, __) => const SettingsScreen()),
  ],
);

class MainShell extends StatelessWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: const MainBottomNav(),
    );
  }
}

class MainBottomNav extends StatelessWidget {
  const MainBottomNav({super.key});

  int _getCurrentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/explore')) return 1;
    if (location.startsWith('/tours')) return 2;
    if (location.startsWith('/profile')) return 3;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentIndex = _getCurrentIndex(context);

    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: (index) {
        switch (index) {
          case 0: context.go(AppRoutes.home); break;
          case 1: context.go(AppRoutes.explore); break;
          case 2: context.go(AppRoutes.tours); break;
          case 3: context.go(AppRoutes.profile); break;
        }
      },
      destinations: const [
        NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
        NavigationDestination(icon: Icon(Icons.explore_outlined), selectedIcon: Icon(Icons.explore), label: 'Explore'),
        NavigationDestination(icon: Icon(Icons.tour_outlined), selectedIcon: Icon(Icons.tour), label: 'Tours'),
        NavigationDestination(icon: Icon(Icons.person_outlined), selectedIcon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }
}
