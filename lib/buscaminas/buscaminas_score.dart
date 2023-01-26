import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class BuscaminasScore extends StatefulWidget {
  const BuscaminasScore({Key? key}) : super(key: key);

  @override
  createState() => _BuscaminasScoreState();
}

class _BuscaminasScoreState extends State<BuscaminasScore>
    with SingleTickerProviderStateMixin, RestorationMixin {
  final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm');
  final tabs = [
    {'label': 'Fácil', 'mines': 10},
    {'label': 'Medio', 'mines': 20},
    {'label': 'Difícil', 'mines': 40},
  ];
  late TabController _tabController;
  final RestorableInt tabIndex = RestorableInt(0);

  String _strTime(int seconds) =>
      '${'${seconds ~/ 60}'.padLeft(2, '0')}:${'${seconds - (seconds ~/ 60) * 60}'.padLeft(2, '0')}';

  @override
  String get restorationId => 'tab_non_scrollable_demo';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(tabIndex, 'tab_index');
    _tabController.index = tabIndex.value;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      initialIndex: 0,
      length: 3,
      vsync: this,
    );
    _tabController.addListener(() {
      // When the tab controller's value is updated, make sure to update the
      // tab index value, which is state restorable.
      setState(() {
        tabIndex.value = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    tabIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Buscaminas Puntuaciones"),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: false,
          tabs: [
            for (final tab in tabs) Tab(text: tab['label'].toString()),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          for (final tab in tabs)
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('buscaminas-score')
                  .where('mines', isEqualTo: tab['mines'])
                  .orderBy('seconds', descending: false)
                  .limit(25)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: SelectableText('$snapshot.error'));
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
                      trailing: FittedBox(
                        fit: BoxFit.fill,
                        child: Row(
                          children: [
                            const Icon(Icons.access_time),
                            Text(
                              _strTime(docs[index]['seconds']),
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
        ],
      ),
    );
  }
}
