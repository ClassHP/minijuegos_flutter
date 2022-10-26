import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'colorbox/colorbox_score.dart';
import 'colorbox/colorbox_menu.dart';
import 'colorbox/colorbox_play.dart';
import 'home.dart';

class MainRouter {
  static GoRouter router = GoRouter(
    routes: <GoRoute>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return const Home(title: 'Minijuegos Flutter');
        },
        routes: [
          GoRoute(
            path: 'colorbox',
            builder: (BuildContext context, GoRouterState state) {
              return const ColorboxMenu();
            },
            routes: [
              GoRoute(
                path: 'play',
                // Display on the root Navigator
                builder: (BuildContext context, GoRouterState state) {
                  return const ColorboxPlay();
                },
              ),
              GoRoute(
                path: 'score',
                // Display on the root Navigator
                builder: (BuildContext context, GoRouterState state) {
                  return const ColorboxScore();
                },
              ),
            ],
          ),
        ],
      ),
    ],
  );
}