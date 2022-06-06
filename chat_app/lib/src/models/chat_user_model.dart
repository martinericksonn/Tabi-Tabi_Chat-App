import 'package:cloud_firestore/cloud_firestore.dart';

class ChatUser {
  final String uid, username, email, image, age, gender;
  Timestamp created, updated;
  List<String> chatrooms;

  ChatUser(this.uid, this.username, this.email, this.age, this.gender, this.image, this.created,
      this.updated, this.chatrooms);

  static ChatUser fromDocumentSnap(DocumentSnapshot snap) {
    Map<String, dynamic> json = snap.data() as Map<String, dynamic>;
    return ChatUser(
      snap.id,
      json['username'] ?? '',
      json['email'] ?? '',
      json['age'] ?? '',
      json['gender'] ?? '',
      json['image'] ?? '',
      json['created'] ?? Timestamp.now(),
      json['updated'] ?? Timestamp.now(),
      json['chatrooms'] != null
          ? List<String>.from(json['chatrooms'])
          : <String>[],
    );
  }

  static Future<ChatUser> fromUid({required String uid}) async {
    DocumentSnapshot snap =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    return ChatUser.fromDocumentSnap(snap);
  }

  static Future<List<ChatUser>> getUsers() async {
    print("SOME ONE CALLED ME");
    List<ChatUser> users = [];
    await FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        users.add(ChatUser.fromDocumentSnap(doc));
      }
    });

    return users;
  }

  static Stream<ChatUser> fromUidStream({required String uid}) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .snapshots()
        .map(ChatUser.fromDocumentSnap);
  }

  Map<String, dynamic> get json => {
        'uid': uid,
        'username': username,
        'email': email,
        'age': age,
        'gender': gender,
        'image': image,
        'created': created,
        'updated': updated
      };
}
