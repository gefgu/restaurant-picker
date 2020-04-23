import 'package:cloud_firestore/cloud_firestore.dart';

class Restaurant {
  final String name;
  final int votes;
  final DocumentReference reference;

  Restaurant.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        assert(map['votes'] != null),
        name = map['name'],
        votes = map['votes'];

  Restaurant.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);
}
