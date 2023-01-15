import 'package:flutter/material.dart';
//import 'package:go_router/go_router.dart';
import 'buscaminas/buscaminas.dart';
import 'buscapalabras/buscapalabras.dart';
import 'g2048/g2048.dart';
import 'otelo/otelo.dart';
import 'wordle/wordle.dart';
import 'colorbox/colorbox_score.dart';
import 'colorbox/colorbox_menu.dart';
import 'colorbox/colorbox_play.dart';
import 'home.dart';

class MainRouter {
  static Map<String, WidgetBuilder> routes = {
    '/': (context) => const Home(title: 'Minijuegos Flutter'),
    '/colorbox': (context) => const ColorboxMenu(),
    '/colorbox/play': (context) => const ColorboxPlay(),
    '/colorbox/score': (context) => const ColorboxScore(),
    '/otelo': (context) => const Otelo(),
    '/2048': (context) => const G2048(),
    '/buscaminas': (context) => const Buscaminas(),
    '/wordle': (context) => const Wordle(),
    '/buscapalabras': (context) => const Buscapalabras(),
  };
}
