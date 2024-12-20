import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ludo_mobile/firebase/model/conversation.dart';
import 'package:ludo_mobile/firebase/model/user_conversation.dart';
import 'package:ludo_mobile/firebase/model/user_firebase.dart';
import 'package:ludo_mobile/firebase/service/firebase_database_utils.dart';
import 'package:ludo_mobile/utils/local_storage_helper.dart';
import 'package:rxdart/rxdart.dart';

class FirebaseDatabaseService {
  final String? uid;

  FirebaseDatabaseService({this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");
  final CollectionReference conversationsCollection =
      FirebaseFirestore.instance.collection("conversations");

  Future<void> saveUserData(
    String name,
    String firstname,
    String email, {
    String profilePicture = "",
    bool isAdmin = false,
  }) async {
    final userDoc = userCollection.doc(uid);

    final existingUser = await getUserDataByEmail(email);

    if (existingUser != null) {
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
        'email': email.toLowerCase(),
        'profilePicture': profilePicture,
        'conversations': [],
        'isAdmin': isAdmin,
        'uid': uid,
      });
    }
  }

  Future<void> saveToken(String token) async {
    final userDoc = userCollection.doc(uid);

    return userDoc.update({
      'token': token,
    });
  }

  Future<void> updateUserProfilePicture(String profilePicture) async {
    final userDoc = userCollection.doc(uid);
    return userDoc.set({
      'profilePicture': profilePicture,
    }, SetOptions(merge: true));
  }

  UserFirebase? userFirebaseFromDocumentSnapshot(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    var data = snapshot.data();
    if (data == null) {
      return null;
    }
    return UserFirebase.fromMap(data);
  }

  List<UserFirebase?> userFirebaseListFromQuerySnapshot(
    QuerySnapshot<Object?> snapshot,
  ) {
    return snapshot.docs
        .map((doc) => userFirebaseFromDocumentSnapshot(
            doc as DocumentSnapshot<Map<String, dynamic>>))
        .toList();
  }

  Conversation conversationFromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    var data = snapshot.data();
    if (data == null) {
      throw Exception("Conversation not found");
    }
    return Conversation.fromMap(data);
  }

  Future<UserFirebase?> getUserDataByEmail(String email) async {
    QuerySnapshot<Object?> usersQuerySnapshot =
        await userCollection.where('email', isEqualTo: email.toLowerCase()).limit(1).get();
    List<UserFirebase?> users =
        userFirebaseListFromQuerySnapshot(usersQuerySnapshot);
    return users.isNotEmpty ? users.first : null;
  }

  Future<UserFirebase?> getUserFirebaseById(String id) async {
    DocumentSnapshot<Object?> userDoc = await userCollection.doc(id).get();
    return userFirebaseFromDocumentSnapshot(
        userDoc as DocumentSnapshot<Map<String, dynamic>>);
  }

  Stream<UserFirebase> getUserData(String id) {
    return userCollection.doc(id).snapshots().map((userSnapshot) {
      return userFirebaseFromDocumentSnapshot(
          userSnapshot as DocumentSnapshot<Map<String, dynamic>>)!;
    });
  }

  Stream<List<UserFirebase>> getUsersData(List<String> ids) {
    return Rx.combineLatestList(
        ids.map((id) => getUserData(id)).toList(growable: false));
  }

  Stream<Conversation> getConversationData(String id) {
    return conversationsCollection
        .doc(id)
        .snapshots()
        .map((conversationSnapshot) {
      return conversationFromSnapshot(
          conversationSnapshot as DocumentSnapshot<Map<String, dynamic>>);
    });
  }

  // maintenant on récupère les conversations directement depuis la collection
  // des conversations via la liste de members. Par contre la liste des
  // conversations de l'utilisateur existe toujours car c'est elle qui gère
  // les isSeen. Cependant la liste est beuguée et devra être refacto pour
  // pouvoir la supprimer et voir pour gérer isSeen dans la collection des
  // conversations
  Stream<List<Conversation>> getConversationsDataOfCurrentUser() {
    return conversationsCollection
        .where('members', arrayContains: uid)
        .snapshots()
        .switchMap((snapshot) {
      final conversationIds = snapshot.docs.map((doc) => doc.id).toList();
      final conversations = conversationIds
          .map((id) => getConversationData(id))
          .toList();

      return Rx.combineLatestList(conversations);
    });
  }

  Future<UserFirebase?> getTargetUserDataByConversationId(String id) async {
    final conversationDoc = await conversationsCollection.doc(id).get();
    final targetUserId = conversationDoc['targetUserId'] as String;
    final userSnapshot = await userCollection.doc(targetUserId).get();
    return userFirebaseFromDocumentSnapshot(
        userSnapshot as DocumentSnapshot<Map<String, dynamic>>);
  }

  Stream<List<String>> getConversationIds() {
    return conversationsCollection
        .where('members', arrayContains: uid)
        .snapshots()
        .map((snapshot) {
      final conversationIds = snapshot.docs.map((doc) => doc.id).toList();
      return conversationIds;
    });
  }

  Future<Stream<Conversation>> getConversationById(String id) async {
    return getConversationData(id);
  }

  Future<List<UserFirebase>> getConversationMembers(
    String conversationId,
  ) async {
    final conversationSnapshot =
        await conversationsCollection.doc(conversationId).get();
    final conversation = conversationFromSnapshot(
        conversationSnapshot as DocumentSnapshot<Map<String, dynamic>>);
    final List<UserFirebase> memberList = [];
    for (final member in conversation.members) {
      final memberSnapshot = await userCollection.doc(member).get();
      final memberData = userFirebaseFromDocumentSnapshot(
          memberSnapshot as DocumentSnapshot<Map<String, dynamic>>);
      if (memberData != null) memberList.add(memberData);
    }
    return memberList;
  }

  Future<List<UserFirebase>> getAdmins() async {
    final adminSnapshots =
        await userCollection.where('isAdmin', isEqualTo: true).get();
    final List<UserFirebase> admins = [];
    for (final admin in adminSnapshots.docs) {
      admins.add(userFirebaseFromDocumentSnapshot(
          admin as DocumentSnapshot<Map<String, dynamic>>)!);
    }
    return admins;
  }

  Future<List<Conversation>> getConversationsByMemberId(String memberId) async {
    final conversationSnapshot = await conversationsCollection
        .where('members', arrayContains: memberId)
        .get();
    final List<Conversation> conversations = [];
    for (final conversation in conversationSnapshot.docs) {
      conversations.add(conversationFromSnapshot(
          conversation as DocumentSnapshot<Map<String, dynamic>>));
    }
    return conversations;
  }

  Future<void> createConversation(
    String targetUserEmail, {
    String message = "",
  }) async {
    String targetUserId = (await getUserDataByEmail(targetUserEmail))!.uid;

    List<Conversation> existingConversation =
        await getConversationsByMemberId(targetUserId);

    List<String> memberIds =
        FirebaseDatabaseUtils.initConversationMemberIds(targetUserId, await getAdmins());
    String? senderId =
        await LocalStorageHelper.getFirebaseUserIdFromLocalStorage();
    if (senderId == null) {
      throw Exception("Sender id not found");
    }

    if (existingConversation.isEmpty) {
      DocumentReference conversationDocumentReference =
          await conversationsCollection.add({
        'members': memberIds,
        'targetUserId': targetUserId,
        'messages': [],
      });
      String conversationId = conversationDocumentReference.id;
      // ajout de l'id de la conversation qui vient d'être créée
      await conversationDocumentReference.update({
        "conversationId": conversationId,
      });
      // ajout de la conversation dans la liste des conversations de chaque membre
      synchronizeMembersToUserConversationsList(conversationId);
      if (message.isNotEmpty) {
        sendMessage(conversationId, senderId, message);
      }
    } else {
      // peut arriver quand c'est un admin qui envoie un message à un client via
      // sa réservation (un client n'a qu'une seule conversation)
      sendMessage(existingConversation[0].conversationId, senderId, message);
    }
  }

  Future<void> synchronizeMembersToUserConversationsList(String conversationId) async {
    Conversation conversation = await getConversationData(conversationId).first;
    for (var memberId in conversation.members) {
      DocumentReference userDocumentReference = userCollection.doc(memberId);
      UserFirebase user = userFirebaseFromDocumentSnapshot(
          await userDocumentReference.get() as DocumentSnapshot<Map<String, dynamic>>)!;
      if(!user.conversations.any((userConversation) => userConversation.conversationId == conversationId)) {
        await userDocumentReference.update({
          'conversations': FieldValue.arrayUnion([
            {
              'conversationId': conversationId,
              'isSeen': true,
            }
          ])
        });
      }
    }
  }

  void setConversationToSeen(String conversationId) async {
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentSnapshot userSnapshot = await userDocumentReference.get();
    UserFirebase user = userFirebaseFromDocumentSnapshot(
        userSnapshot as DocumentSnapshot<Map<String, dynamic>>)!;
    List<UserConversation> userConversations = user.conversations;

    for (var userConversation in userConversations) {
      if (userConversation.conversationId == conversationId) {
        userConversation.isSeen = true;
        break;
      }
    }

    await userDocumentReference.update({
      'conversations': userConversations
          .map((userConversation) => userConversation.toMap())
          .toList(),
    });
  }

  void setConversationUnseenForOtherMembers(
    String conversationId,
    String senderId,
  ) async {
    final conversationSnapshot =
        await conversationsCollection.doc(conversationId).get();
    Conversation conversation = conversationFromSnapshot(
        conversationSnapshot as DocumentSnapshot<Map<String, dynamic>>);

    final memberSnapshots = await userCollection
        .where(FieldPath.documentId, whereIn: conversation.members)
        .get();

    List<UserFirebase?> members =
        userFirebaseListFromQuerySnapshot(memberSnapshots);
    for (final member in members) {
      if (member == null) continue;
      if (member.uid != senderId) {
        for (var userConversation in member.conversations) {
          if (userConversation.conversationId == conversationId) {
            userConversation.isSeen = false;
            break;
          }
        }
      }

      await userCollection.doc(member.uid).update({
        'conversations': member.conversations
            .map((userConversation) => userConversation.toMap())
            .toList(),
      });
    }
  }

  Stream<bool> hasUnseenConversationsStream() {
    Stream<UserFirebase> userStream = getUserData(uid!);

    return userStream.map((user) {
      final conversations = user.conversations;
      bool hasUnreadConversations = false;

      for (final conversation in conversations) {
        if (!conversation.isSeen) {
          hasUnreadConversations = true;
          break;
        }
      }

      return hasUnreadConversations;
    });
  }

  Future<bool> isConversationSeen(String conversationId) async {
    DocumentSnapshot userSnapshot = await userCollection.doc(uid).get();
    UserFirebase user = userFirebaseFromDocumentSnapshot(
        userSnapshot as DocumentSnapshot<Map<String, dynamic>>)!;

    for (var userConversation in user.conversations) {
      if (userConversation.conversationId == conversationId) {
        return userConversation.isSeen;
      }
    }

    return false;
  }

  Future<void> sendMessage(
      String conversationId, String senderId, String message) async {
    // la ligne suivante sert de sécurité pour maintenir la synchronisation
    // entre la liste des membres d'une conversation et la liste des
    // conversations d'un membre. Elle devra être supprimée quand la liste avec
    // isSeen sera gérée autrement sans beug
    synchronizeMembersToUserConversationsList(conversationId);
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
    setConversationUnseenForOtherMembers(conversationId, senderId);
  }
}
