import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseDatabaseService {
  final String? uid;

  FirebaseDatabaseService({this.uid});

  final CollectionReference userCollection = FirebaseFirestore.instance.collection("users");
  final CollectionReference conversationsCollection = FirebaseFirestore.instance.collection("conversations");

  Future saveUserData(String name, String firstname, String email, String profilePicture) async {
    final userDoc = userCollection.doc(uid);

    final existingUserDoc = await getUserData(email);

    if (existingUserDoc.docs.isNotEmpty) {
      return userDoc.set({
        'name': name,
        'firstname': firstname,
        'profilePicture': profilePicture,
        'conversations': [],
      }, SetOptions(merge: true));
    } else {
      return userDoc.set({
        'name': name,
        'firstname': firstname,
        'email': email,
        'profilePicture': profilePicture,
        'conversations': [],
        'uid': uid,
      });
    }
  }

  Future getUserData(String email) async {
    return await userCollection.where('email', isEqualTo: email).get();
  }

  Future getUserConversations() async {
    return userCollection.doc(uid).snapshots();
  }
}