import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:url_launcher/url_launcher.dart';

class DownloadAndroidBar extends StatelessWidget {
  const DownloadAndroidBar({Key? key}) : super(key: key);

  _openAndroid() {
    launchUrl(Uri.parse(
        'https://play.google.com/store/apps/details?id=com.classhp.minijuegosf'));
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: kIsWeb,
      child: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        color: Theme.of(context).colorScheme.primary,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
              ),
              icon: const Icon(Icons.android),
              label: const Text("Instala la app Android"),
              onPressed: _openAndroid,
            ),
          ],
        ),
      ),
    );
  }
}
