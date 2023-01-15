import 'package:flutter/material.dart';
import 'package:minijuegos_flutter/tools.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'main.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.title});

  final String title;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<_MenuItem> _menuItems = [
    _MenuItem(
      title: 'Buscapalabras',
      descrip: 'Juego de palabras',
      assetName: 'assets/images/buscapalabras.jpg',
      location: '/buscapalabras',
    ),
    _MenuItem(
      title: 'Wordle (es)',
      descrip: 'Juego de palabras',
      assetName: 'assets/images/wordle.jpg',
      location: '/wordle',
    ),
    _MenuItem(
      title: 'ColorBox',
      descrip: 'Juego de agilidad',
      assetName: 'assets/images/colorbox.jpg',
      location: '/colorbox',
    ),
    _MenuItem(
      title: 'Buscaminas',
      descrip: 'Juego de lógica',
      assetName: 'assets/images/buscaminas.jpg',
      location: '/buscaminas',
    ),
    _MenuItem(
      title: 'Otelo / Reversi',
      descrip: 'Juego de tablero',
      assetName: 'assets/images/otelo.jpg',
      location: '/otelo',
    ),
    _MenuItem(
      title: '2048',
      descrip: 'Juego numérico',
      assetName: 'assets/images/2048.jpg',
      location: '/2048',
    ),
  ];

  _openClassHP() {
    launchUrl(
      Uri.parse('https://twitter.com/classhp'),
      mode: LaunchMode.externalApplication,
    );
  }

  _openAndroid() {
    launchUrl(
      Uri.parse('https://play.google.com/store/apps/details?id=com.classhp.minijuegosf'),
      mode: LaunchMode.externalApplication,
    );
  }

  _openRepository() {
    launchUrl(
      Uri.parse('https://github.com/ClassHP/minijuegos_flutter'),
      mode: LaunchMode.externalApplication,
    );
  }

  _share() {
    Share.share('¡Mira estos minijuegos! https://minijuegosf.web.app');
  }

  _goMenu(_MenuItem menuItem) {
    Navigator.pushNamed(context, menuItem.location);
  }

  @override
  Widget build(BuildContext context) {
    if (MyApp.of(context).themeMode == ThemeMode.system) {
      MyApp.of(context).setTheme(MediaQuery.of(context).platformBrightness == Brightness.dark
          ? ThemeMode.dark
          : ThemeMode.light);
    }
    var crossAxisCount = MediaQuery.of(context).orientation == Orientation.landscape ? 5 : 2;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: GridView.count(
        restorationId: 'grid_view_demo_grid_offset',
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        padding: const EdgeInsets.all(8),
        childAspectRatio: 1,
        children: _menuItems.map<Widget>((menuItem) {
          return InkResponse(
            onTap: () {
              _goMenu(menuItem);
            },
            child: GridTile(
              footer: Material(
                color: Colors.transparent,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(8)),
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
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
        heroTag: UniqueKey(),
        onPressed: () => MyApp.of(context).toggleTheme(),
        tooltip: 'Tema',
        child: const Icon(Icons.brightness_6),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        color: Theme.of(context).colorScheme.primary,
        child: Container(
          padding: const EdgeInsets.fromLTRB(5, 5, 70, 5),
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: 5,
            runSpacing: 5,
            children: [
              TextButton.icon(
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                ),
                icon: const Icon(Icons.bolt),
                label: const Text("by @ClassHP"),
                onPressed: _openClassHP,
              ),
              if (Tools.isWeb) ...[
                TextButton.icon(
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  ),
                  icon: const Icon(Icons.call_split),
                  label: const Text("GitHub"),
                  onPressed: _openRepository,
                ),
                TextButton.icon(
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  ),
                  icon: const Icon(Icons.android),
                  label: const Text("Instala la app Android"),
                  onPressed: _openAndroid,
                ),
              ],
              if (!Tools.isWeb)
                TextButton.icon(
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  ),
                  icon: const Icon(Icons.share),
                  label: const Text("Compartir"),
                  onPressed: _share,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuItem {
  _MenuItem({
    required this.title,
    required this.descrip,
    required this.assetName,
    required this.location,
  });

  final String title;
  final String descrip;
  final String assetName;
  final String location;
}
