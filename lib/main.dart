import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'color_box_menu.dart';
import 'color_box_play.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyAppState createState() => _MyAppState();

  // ignore: library_private_types_in_public_api
  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeData _theme(Brightness brightness) {
    const MaterialColor primary = Colors.purple;
    const MaterialColor secondary = Colors.blue;
    return ThemeData(
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: primary,
        accentColor: secondary,
        brightness: brightness,
        backgroundColor:
            brightness == Brightness.light ? Colors.white : Colors.grey[800],
      ).copyWith(
        secondary: secondary,
      ),
      appBarTheme: const AppBarTheme(color: primary),
    );
    /*return ThemeData(
      primarySwatch: Colors.purple,
      brightness: brightness,
    ).copyWith(
      primaryColor: Colors.purple,
      primaryColorDark: Colors.purple,     
    );*/
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Minijuegos Flutter',
      theme: _theme(Brightness.light),
      darkTheme: _theme(Brightness.dark), // standard dark theme
      themeMode: _themeMode, // device controls theme
      routerConfig: _router,
    );
  }

  bool _darkModeOn() {
    return Theme.of(context).brightness == Brightness.dark ||
        _themeMode == ThemeMode.dark;
    /*if(_themeMode == ThemeMode.system && MediaQuery.of(context).platformBrightness == Brightness.dark) {
      return true;
    }
    return _themeMode == ThemeMode.dark;*/
  }

  /// MyApp.of(context).toggleTheme();
  void toggleTheme() {
    setState(() {
      _themeMode = _darkModeOn() ? ThemeMode.light : ThemeMode.dark;
    });
  }

  final GoRouter _router = GoRouter(
    routes: <GoRoute>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return const MyHomePage(title: 'Minijuegos Flutter');
        },
        routes: [
          GoRoute(
            path: 'colorbox',
            builder: (BuildContext context, GoRouterState state) {
              return const ColorBoxMenuPage();
            },
            routes: [
              GoRoute(
                path: 'play',
                // Display on the root Navigator
                builder: (BuildContext context, GoRouterState state) {
                  return const ColorBoxPlayPage();
                },
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<_MenuItem> _menuItems = [
    _MenuItem(
        title: 'ColorBox',
        descrip: 'Juego de agilidad',
        assetName: 'images/colorbox.jpg'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: GridView.count(
        restorationId: 'grid_view_demo_grid_offset',
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        padding: const EdgeInsets.all(8),
        childAspectRatio: 1,
        children: _menuItems.map<Widget>((menuItem) {
          return InkResponse(
            onTap: () {
              GoRouter.of(context).go('/colorbox');
            },
            child: GridTile(
              footer: Material(
                color: Colors.transparent,
                shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(8)),
                ),
                clipBehavior: Clip.antiAlias,
                child: GridTileBar(
                  backgroundColor: Colors.black54,
                  title: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(menuItem.title),
                  ),
                  subtitle: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(menuItem.descrip),
                  ),
                ),
              ),
              child: Material(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                clipBehavior: Clip.antiAlias,
                child: Image.asset(
                  menuItem.assetName,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => MyApp.of(context).toggleTheme(),
        tooltip: 'Tema',
        child: const Icon(Icons.brightness_6),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        color: Theme.of(context).colorScheme.primary,
        child: Row(children: [
          TextButton.icon(
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
            ),
            icon: const Icon(Icons.bolt),
            label: const Text("by @ClassHP"),
            onPressed: () {},
          ),
        ]),
      ),
    );
  }
}

class _MenuItem {
  _MenuItem({
    required this.title,
    required this.descrip,
    required this.assetName,
  });

  final String title;
  final String descrip;
  final String assetName;
}
