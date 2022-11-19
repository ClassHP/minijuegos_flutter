import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:minijuegos_flutter/buscaminas/buscaminas_score.dart';

class BuscaminasService {
  
  final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm');

  Future<void> showWin(BuildContext context, int mines, int seconds) async {
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
            Text('Descubriste las $mines minas'),
            const SizedBox(height: 5),
            Text('en el en tiempo: ${_strTime(seconds)}'),
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
                await _saveScore(value, mines, seconds);
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
              await _saveScore(name, mines, seconds);
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
        return const BuscaminasScore();
      },
    );
  }

  String _strTime(int seconds) =>
      '${'${seconds ~/ 60}'.padLeft(2, '0')}:${'${seconds - (seconds ~/ 60) * 60}'.padLeft(2, '0')}';

  Future<void> _saveScore(String name, int mines, int seconds) async {
    await FirebaseFirestore.instance.collection('buscaminas-score').add({
      'name': name.isEmpty
          ? 'Anónimo'
          : name.substring(0, name.length > 20 ? 20 : null),
      'date': DateTime.now(),
      'mines': mines,
      'seconds': seconds
    }).then((value) {
      //debugDumpApp();
    }, onError: (error) {
      //print(error);
      //debugDumpApp();
    });
  }
}