/*
* Created by Connel Asikong on 10/01/2026
*
*/

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screens/home_screen.dart';
import '../screens/receive_screen.dart';
import '../screens/send_screen.dart';
import '../screens/settings_screen.dart';

/// Route paths
class Routes {
  static const home = '/';
  static const receive = '/receive';
  static const send = '/send';
  static const backup = '/backup';
  static const settings = '/settings';
}

/// Router configuration
final appRouter = GoRouter(
  initialLocation: Routes.home,
  routes: [
    GoRoute(
      path: Routes.home,
      name: 'home',
      // builder: (context, state) => const SendScreen(),
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: Routes.receive,
      name: 'receive',
      builder: (context, state) => const ReceiveScreen(),
    ),
    GoRoute(
      path: Routes.send,
      name: 'send',
      builder: (context, state) => const SendScreen(),
    ),
    GoRoute(
      path: Routes.settings,
      name: 'settings',
      builder: (context, state) => const SettingsScreen(),
    ),
  ],

  // Error handling
  errorBuilder: (context, state) =>
      Scaffold(body: Center(child: Text('Page not found: ${state.uri}'))),
);
