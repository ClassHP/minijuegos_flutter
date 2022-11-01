import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:minijuegos_flutter/otelo/otelo_logic.dart';

class OteloStore {
  final CollectionReference<OteloRoom?> _collectionRooms = FirebaseFirestore
      .instance
      .collection('otelo-rooms')
      .withConverter<OteloRoom?>(
        fromFirestore: (snapshot, _) => OteloRoom.fromJson(snapshot.data()!),
        toFirestore: (obj, _) => obj!.toJson(),
      );
  final int _playerId = Random().nextInt(99999);
  DocumentReference<OteloRoom?>? _room;

  int get playerId => _playerId;

  Future<Stream<OteloRoom?>?> joinRoom(List<Box> boxes) async {
    try {
      var doc = await _collectionRooms
          .where('status', isEqualTo: 0)
          .where('dateC',
              isGreaterThan: DateTime.now().add(const Duration(minutes: -5)))
          .limit(1)
          .get();
      if (doc.docs.isNotEmpty) {
        await doc.docs[0].reference.update({
          'player2': _playerId,
          'status': 1,
        });
        _room = doc.docs[0].reference;
      } else {
        _room = await _collectionRooms
            .add(OteloRoom(player1: _playerId, boxes: boxes));
      }
      return getStreamRoom();
    } catch (error) {
      return null;
    }
  }

  Future<bool> updateRoom(List<Box> boxes, bool end, int turn) async {
    try {
      if (_room != null) {
        await _room?.update({
          'boxes': boxes.map<int>((e) => e.selected ? e.player! : -1).toList(),
          'status': end ? 2 : 1,
          'turn': turn,
        });
        return true;
      }
      return false;
    } catch (error) {
      return false;
    }
  }

  Future<bool> endRoom() async {
    try {
      if (_room != null) {
        await _room?.update({
          'status': 2,
        });
        return true;
      }
      return false;
    } catch (error) {
      return false;
    }
  }

  Stream<OteloRoom?>? getStreamRoom() {
    try {
      if (_room != null) {
        return _room?.snapshots().map<OteloRoom?>((doc) {
          return doc.exists ? doc.data() : null;
        });
      }
      return null;
    } catch (error) {
      return null;
    }
  }
}

class OteloRoom {
  int id = Random().nextInt(900) + 100;
  int player1 = -1;
  int player2 = -1;
  int status = 0; //0 = created, 1 = started, 2 = ended
  List<int> boxes = [];
  DateTime dateC = DateTime.now();
  int turn = 0;

  OteloRoom({required this.player1, required List<Box> boxes}) {
    this.boxes = boxes.map<int>((e) => e.selected ? e.player! : -1).toList();
  }

  OteloRoom.data(
      {required this.id,
      required this.player1,
      required this.player2,
      required this.status,
      required this.boxes,
      required this.dateC,
      required this.turn});

  OteloRoom.fromJson(Map<String, Object?> json)
      : this.data(
          id: json['id']! as int,
          player1: json['player1']! as int,
          player2: json['player2']! as int,
          status: json['status']! as int,
          boxes: (json['boxes']! as List<dynamic>)
              .map((e) => int.parse(e.toString()))
              .toList(),
          dateC: (json['dateC']! as Timestamp).toDate(),
          turn: json['turn']! as int,
        );

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'player1': player1,
      'player2': player2,
      'status': status,
      'boxes': boxes,
      'dateC': dateC,
      'turn': turn,
    };
  }
}
