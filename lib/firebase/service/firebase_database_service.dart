import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseDatabaseService {
  final String? uid;

  FirebaseDatabaseService({this.uid});

  final CollectionReference userCollection = FirebaseFirestore.instance.collection("users");
  final CollectionReference conversationsCollection = FirebaseFirestore.instance.collection("conversations"); // TODO voir pour la modélisation dans Firebase plus tard

  Future saveUserData(String name, String firstname, String email, String profilePicture) async {
    final userDoc = userCollection.doc(uid);

    final existingUserDoc = await getUserData(email);

    if (existingUserDoc.docs.isNotEmpty) {
      return userDoc.set({
        'name': name,
        'firstname': firstname,
        'profilePicture': profilePicture,
      }, SetOptions(merge: true));
    } else {
      return userDoc.set({
        'name': name,
        'firstname': firstname,
        'email': email,
        'profilePicture': profilePicture,
        'uid': uid,
      });
    }
  }

  Future getUserData(String email) async {
    return await userCollection.where('email', isEqualTo: email).get();
  }
}