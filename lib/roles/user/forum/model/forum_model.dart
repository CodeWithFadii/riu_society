import 'package:cloud_firestore/cloud_firestore.dart';

class ForumModel {
  final String name, communityName, dscription, title, id, image, userID;
  final List likes, dislikes;

  ForumModel(
      {required this.likes,
      required this.dislikes,
      required this.communityName,
      required this.dscription,
      required this.id,
      required this.name,
      required this.title,
      required this.image,
      required this.userID});

  factory ForumModel.fromFireStore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return ForumModel(
        likes: List.from(data['likes']),
        dislikes: List.from(data['dislikes']),
        communityName: data['community_name'],
        dscription: data['description'],
        id: doc.id,
        name: data['name'],
        title: data['title'],
        image: data['image'],
        userID: data['user_id']);
  }
}
