import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ColorboxScore extends StatefulWidget {
  const ColorboxScore({Key? key}) : super(key: key);

  @override
  createState() => _ColorboxScoreState();
}

class _ColorboxScoreState extends State<ColorboxScore> {
  final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("ColorBox Puntuaciones")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('colorbox-score')
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
                subtitle: Text(formatter.format(docs[index]['date'].toDate())),
                trailing: Text(
                  '${docs[index]['score']}',
                  style: Theme.of(context).textTheme.headline5,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
