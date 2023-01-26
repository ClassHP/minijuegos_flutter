import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BuscapalabrasScore extends StatefulWidget {
  const BuscapalabrasScore({Key? key}) : super(key: key);

  @override
  createState() => _BuscapalabrasScoreState();
}

class _BuscapalabrasScoreState extends State<BuscapalabrasScore> {
  final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Puntuaciones")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('buscapalabras-score')
            //.where('date', isGreaterThan: DateTime.now().add(const Duration(days: -30)))
            .orderBy('score', descending: true)
            //.orderBy('date', descending: true)
            .limit(25)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('$snapshot.error'));
          } else if (!snapshot.hasData) {
            return const Center(
              child: SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(),
              ),
            );
          }

          var docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: ExcludeSemantics(
                  child: CircleAvatar(child: Text('${index + 1}')),
                ),
                title: Text('${docs[index]['name']}'),
                subtitle: Text(
                    '${formatter.format(docs[index]['date'].toDate())} | ${docs[index]['longWord']}'),
                trailing: Text(
                  '${docs[index]['score']}',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
