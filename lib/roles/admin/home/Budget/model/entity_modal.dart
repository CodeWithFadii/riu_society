import 'package:cloud_firestore/cloud_firestore.dart';

class EntityModal {
  final String title,id;
  final int price;

  EntityModal({
    required this.title,
    required this.id,
    required this.price,
  });

  factory EntityModal.fromFireStore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return EntityModal(
      id: doc.id,
      title: data['entity_title'],
      price: data['entity_price'],
    );
  }
}
