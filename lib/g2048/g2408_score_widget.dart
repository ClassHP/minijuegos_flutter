import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class G2048ScoreWidget extends StatefulWidget {
  const G2048ScoreWidget({Key? key}) : super(key: key);

  @override
  createState() => _G2048ScoreWidgetState();
}

class _G2048ScoreWidgetState extends State<G2048ScoreWidget> {
  final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm');

  String _strTime(int seconds) =>
      '${'${seconds ~/ 60}'.padLeft(2, '0')}:${'${seconds - (seconds ~/ 60) * 60}'.padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("2048 Puntuaciones")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('g2048-score')
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
                  '${docs[index]['score']} / ${_strTime(docs[index]['seconds'])}',
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
