import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ludo_mobile/utils/local_storage_helper.dart';

class FirebaseDatabaseService {
  final String? uid;

  FirebaseDatabaseService({this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");
  final CollectionReference conversationsCollection =
      FirebaseFirestore.instance.collection("conversations");

  Future<void> saveUserData(String name, String firstname, String email,
      {String profilePicture = "", bool isAdmin = false}) async {
    final userDoc = userCollection.doc(uid);

    final existingUserDoc = await getUserDataByEmail(email);

    if (existingUserDoc.docs.isNotEmpty) {
      return userDoc.set({
        'name': name,
        'firstname': firstname,
        'profilePicture': profilePicture,
        'conversations': [],
        'isAdmin': isAdmin,
      }, SetOptions(merge: true));
    } else {
      return userDoc.set({
        'name': name,
        'firstname': firstname,
        'email': email,
        'profilePicture': profilePicture,
        'conversations': [],
        'isAdmin': isAdmin,
        'uid': uid,
      });
    }
  }

  Future<QuerySnapshot<Object?>> getUserDataByEmail(String email) async {
    return await userCollection.where('email', isEqualTo: email).limit(1).get();
  }

  Future<DocumentSnapshot<Object?>> getUserDataById(String id) async {
    return await userCollection.doc(id).get();
  }

  Future<Stream<DocumentSnapshot<Object?>>> getUserConversations() async {
    return userCollection.doc(uid).snapshots();
  }

  Future<List<Object?>> getAdmins() async {
    QuerySnapshot<Object?> adminSnapshots =
        await userCollection.where('isAdmin', isEqualTo: true).get();
    return adminSnapshots.docs
        .map((adminSnapshot) => adminSnapshot.data())
        .toList();
  }

  Future<List<Object?>> getConversationByTargetUserId(String targetUserId) async {
    QuerySnapshot<Object?> conversationSnapshot = await conversationsCollection
        .where('members', arrayContains: targetUserId)
        .limit(1)
        .get();
    return conversationSnapshot.docs
        .map((conversation) => conversation.data())
        .toList();
  }

  Future<void> createConversationWithClient(String targetUserEmail, String message) async {
    List<Object?> admins = await getAdmins();
    QuerySnapshot<Object?> targetUser = await getUserDataByEmail(targetUserEmail);
    if (targetUser.docs.isEmpty) {
      throw Exception("Target user not found");
    }
    var targetUserId = targetUser.docs[0]["uid"];

    saveConversationData(targetUserId, admins, message);
  }

  Future<void> saveConversationData(String targetUserId, List<Object?> admins, String message) async {
    List<Object?> existingConversation =
        await getConversationByTargetUserId(targetUserId);

    List<String> members = initGroupMembers(targetUserId, admins);
    String? senderId = await LocalStorageHelper.getFirebaseUserIdFromLocalStorage();
    if(senderId == null) {
      throw Exception("Sender id not found");
    }
    if(senderId == targetUserId) {
      throw Exception("Sender id and target id are the same");
    }

    // TODO notif
    if (existingConversation.isEmpty) {
      DocumentReference conversationDocumentReference =
          await conversationsCollection.add({
        'members': members,
        'messages': [],
      });
      // ajout de l'id de la conversation qui vient d'être créée
      await conversationDocumentReference.update({
        "conversationId": conversationDocumentReference.id,
      });
      sendMessage(conversationDocumentReference.id, senderId, message);
      // ajout de la conversation dans la liste des conversations de chaque membre
      for (var memberId in members) {
        DocumentReference userDocumentReference = userCollection.doc(memberId);
        await userDocumentReference.update({
          "conversations":
              FieldValue.arrayUnion([conversationDocumentReference.id])
        });
      }
    } else {
      print(existingConversation);
      var conversationMap = existingConversation[0] as Map<String, dynamic>;
      sendMessage(conversationMap["conversationId"], senderId, message);
    }
  }

  Future<void> sendMessage(String conversationId, String senderId, String message) async {
    conversationsCollection.doc(conversationId).update({
      'messages': FieldValue.arrayUnion([
        {
          'sender': senderId,
          'message': message,
          'time': DateTime.now(),
        }
      ]),
      'recentMessage': message,
      'recentMessageSender': senderId,
      'recentMessageTime': DateTime.now(),
    });
  }

  List<String> initGroupMembers(String targetUserId, List<Object?> admins) {
    List<String> members = [targetUserId];
    admins.forEach((admin) {
      var adminMap = admin as Map<String, dynamic>;
      var uid = adminMap['uid'];
      if (!members.contains(uid)) {
        members.add(uid);
      }
    });
    return members;
  }
}
