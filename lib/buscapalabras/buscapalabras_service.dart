import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'buscapalabras_score.dart';

class BuscapalabrasService {
  Future<void> showWin(BuildContext context, int score, String longWord) async {
    var name = '';
    await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('¡Final del juego! 🏆'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Tu puntuación fue de: $score'),
            const SizedBox(height: 5),
            Text('Palabra mas larga: $longWord'),
            const SizedBox(height: 16),
            TextField(
              maxLength: 20,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Ingresa tu nombre...',
              ),
              onChanged: (String text) => name = text,
              onSubmitted: (String value) async {
                Navigator.pop(context, 'OK');
                await _saveScore(value, score, longWord);
              },
            ),
          ],
        ),
        actions: <Widget>[
          ElevatedButton(
            style:
                ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.secondary),
            onPressed: () => Navigator.pop(context, 'CANCEL'),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context, 'OK');
              await _saveScore(name, score, longWord);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<bool> showConfirm(BuildContext context) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Confirmar 🤔'),
        content: const Text('¿Seguro quiere reiniciar el tablero?'),
        actions: <Widget>[
          ElevatedButton(
            style:
                ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.secondary),
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No, continuar jugando'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Si, reiniciar'),
          ),
        ],
      ),
    ).then<bool>((value) => value ?? false);
  }

  Future<void> showScore(BuildContext context) async {
    await showGeneralDialog(
      context: context,
      pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
      ) {
        return const BuscapalabrasScore();
      },
    );
  }

  Future<void> _saveScore(String name, int score, String longWord) async {
    await FirebaseFirestore.instance.collection('buscapalabras-score').add({
      'name': name.isEmpty ? 'Anónimo' : name.substring(0, name.length > 20 ? 20 : null),
      'date': DateTime.now(),
      'score': score,
      'longWord': longWord
    }).then((value) {
      //debugDumpApp();
    }, onError: (error) {
      //print(error);
      //debugDumpApp();
    });
  }
}
