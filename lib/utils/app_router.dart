import 'package:flutter/material.dart';
import 'package:map_prototype/presentation/home_screen.dart';

import '../presentation/splash_screen.dart';
import '../presentation/map_screen.dart';

class AppRouter {
  static const String splash = '/splash';
  static const String home = '/home';
  static const String map = '/map';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      //Authentication----------------------------------------------------------
      case splash:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
          settings: const RouteSettings(name: splash),
        );
      case home:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
          settings: const RouteSettings(name: home),
        );
      case map:
        return MaterialPageRoute(
          builder: (_) => const MapScreen(),
          settings: const RouteSettings(name: map),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const MapScreen(),
          settings: const RouteSettings(name: map),
        );
    }
  }

  // static void clearStackAndShowLogin(BuildContext context) {
  //   Navigator.of(context).pushNamedAndRemoveUntil(login, (route) => false);
  // }
}
