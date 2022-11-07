import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import 'g2408_score_widget.dart';

class G2048Score {
  final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm');

  Future<void> showWin(BuildContext context, int score, int seconds) async {
    var name = '';
    await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('¡Ganaste! 🥳🎉'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Tu puntuanión fue de: $score'),
            const SizedBox(height: 5),
            Text('El en tiempo: ${_strTime(seconds)}'),
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
                await _saveScore(value, score, seconds);
              },
            ),
          ],
        ),
        actions: <Widget>[
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondary),
            onPressed: () => Navigator.pop(context, 'CANCEL'),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context, 'OK');
              await _saveScore(name, score, seconds);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> showScore(BuildContext context) async {
    await showGeneralDialog(
      context: context,
      pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
      ) {
        return const G2048ScoreWidget();
      },
    );
  }

  Future<void> showLose(BuildContext context, int score, int seconds) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("¡Perdiste! 😝"),
          content: Text('Tu puntuanión fue de: $score / ${_strTime(seconds)}'),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context, 'OK');
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  String _strTime(int seconds) =>
      '${'${seconds ~/ 60}'.padLeft(2, '0')}:${'${seconds - (seconds ~/ 60) * 60}'.padLeft(2, '0')}';

  Future<void> _saveScore(String name, int score, int seconds) async {
    await FirebaseFirestore.instance.collection('g2048-score').add({
      'name': name.isEmpty
          ? 'Anónimo'
          : name.substring(0, name.length > 20 ? 20 : null),
      'date': DateTime.now(),
      'score': score,
      'seconds': seconds
    }).then((value) {
      //debugDumpApp();
    }, onError: (error) {
      //print(error);
      //debugDumpApp();
    });
  }
}
