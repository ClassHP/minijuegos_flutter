import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
      title: 'ColorBox',
      descrip: 'Juego de agilidad',
      assetName: 'images/colorbox.jpg',
      location: '/colorbox',
    ),
    _MenuItem(
      title: 'Otelo / Reversi',
      descrip: 'Juego de tablero',
      assetName: 'images/otelo.jpg',
      location: '/otelo',
    ),
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
              GoRouter.of(context).go(menuItem.location);
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
        heroTag: UniqueKey(),
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
    required this.location,
  });

  final String title;
  final String descrip;
  final String assetName;
  final String location;
}
