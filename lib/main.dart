import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:minijuegos_flutter/main_router.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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

  ThemeMode get themeMode => _themeMode;

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
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Minijuegos Flutter',
      theme: _theme(Brightness.light),
      darkTheme: _theme(Brightness.dark), // standard dark theme
      themeMode: _themeMode, // device controls theme
      routerConfig: MainRouter.router,
      debugShowCheckedModeBanner: false,
    );
  }

  bool _darkModeOn() {
    return Theme.of(context).brightness == Brightness.dark ||
        _themeMode == ThemeMode.dark;
  }

  /// MyApp.of(context).toggleTheme();
  void toggleTheme() {
    setState(() {
      _themeMode = _darkModeOn() ? ThemeMode.light : ThemeMode.dark;
    });
  }

  void setTheme(ThemeMode mode) {
    _themeMode = mode;
  }
}
