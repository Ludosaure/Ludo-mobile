import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ludo_mobile/firebase/model/conversation.dart';
import 'package:ludo_mobile/firebase/model/user_firebase.dart';
import 'package:ludo_mobile/utils/local_storage_helper.dart';
import 'package:rxdart/rxdart.dart';

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
        'email': email,
        'profilePicture': profilePicture,
        'conversations': [],
        'isAdmin': isAdmin,
        'uid': uid,
      });
    }
  }

  Future<void> updateUserProfilePicture(String profilePicture) async {
    final userDoc = userCollection.doc(uid);
    return userDoc.set({
      'profilePicture': profilePicture,
    }, SetOptions(merge: true));
  }

  UserFirebase userFirebaseFromDocumentSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    var data = snapshot.data();
    if (data == null) {
      throw Exception("User not found");
    }
    return UserFirebase.fromMap(data);
  }

  List<UserFirebase> userFirebaseListFromQuerySnapshot(
      QuerySnapshot<Object?> snapshot) {
    return snapshot.docs
        .map((doc) => userFirebaseFromDocumentSnapshot(
            doc as DocumentSnapshot<Map<String, dynamic>>))
        .toList();
  }

  Conversation conversationFromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    var data = snapshot.data();
    if (data == null) {
      throw Exception("Conversation not found");
    }
    return Conversation.fromMap(data);
  }

  Future<UserFirebase?> getUserDataByEmail(String email) async {
    QuerySnapshot<Object?> usersQuerySnapshot =
        await userCollection.where('email', isEqualTo: email).limit(1).get();
    List<UserFirebase> users = userFirebaseListFromQuerySnapshot(usersQuerySnapshot);
    return users.isNotEmpty ? users.first : null;
  }

  Future<DocumentSnapshot<Object?>> getUserDataById(String id) async {
    return await userCollection.doc(id).get();
  }

  Future<DocumentSnapshot<Object?>> getTargetUserDataByConversationId(
      String id) async {
    final conversationDoc = await conversationsCollection.doc(id).get();
    final targetUserId = conversationDoc['targetUserId'] as String;
    return await userCollection.doc(targetUserId).get();
  }

  Stream<List<String>> getConversationIds() {
    final userSnapshotStream = userCollection.doc(uid).snapshots();

    return userSnapshotStream.map((userSnapshot) {
      final userMap = userSnapshot.data()! as Map<String, dynamic>;
      final conversations = userMap['conversations'] as List<dynamic>;
      return initConversationIdsList(conversations);
    });
  }

  List<String> initConversationIdsList(List<dynamic> conversations) {
    final List<String> conversationIds = [];
    for (final conversation in conversations) {
      conversationIds.add(conversation['conversationId'] as String);
    }
    return conversationIds;
  }

  Future<List<dynamic>> sortConversationsByRecentMessage(
      List<dynamic> conversationsIdsNotSorted) async {
    final conversations = [];
    for (final conversationId in conversationsIdsNotSorted) {
      final conversationSnapshot =
          await conversationsCollection.doc(conversationId).get();
      final conversationData =
          conversationSnapshot.data()! as Map<String, dynamic>;

      conversations.add({
        'conversationId': conversationData['conversationId'],
        'time': conversationData['recentMessageTime'] as Timestamp,
      });
    }
    conversations.sort((a, b) => b['time'].compareTo(a['time']));
    final sortedConversations = [];
    for (final conversation in conversations) {
      sortedConversations.add(conversation['conversationId']);
    }
    return sortedConversations;
  }

  Stream<List<Map<String, dynamic>>> getUserConversations() {
    final userSnapshotStream = userCollection.doc(uid).snapshots();

    return userSnapshotStream.asyncMap((userSnapshot) async {
      final conversations = userSnapshot['conversations'] as List<dynamic>;
      final conversationIds = await sortConversationsByRecentMessage(
          initConversationIdsList(conversations));

      final conversationStreams = conversationIds.map((conversationId) {
        final conversationStream = conversationsCollection
            .doc(conversationId)
            .snapshots() as Stream<DocumentSnapshot<Map<String, dynamic>>>;
        final membersStream = userCollection
            .where('conversations.conversationId', isEqualTo: conversationId)
            .snapshots() as Stream<QuerySnapshot<Map<String, dynamic>>>;

        // rx permet de combiner 2 streams
        return Rx.combineLatest2<DocumentSnapshot<Map<String, dynamic>>,
            QuerySnapshot<Map<String, dynamic>>, Map<String, dynamic>>(
          conversationStream,
          membersStream,
          (conversationSnapshot, membersSnapshot) {
            final conversationData = conversationSnapshot.data()!;
            final membersData =
                membersSnapshot.docs.map((doc) => doc.data()).toList();
            final recentMessage =
                conversationData['recentMessage'] as String? ?? '';

            return {
              'conversation': conversationData,
              'members': membersData,
              'recentMessage': recentMessage,
            };
          },
        );
      });

      final combinedStream = Rx.combineLatestList(conversationStreams);

      return await combinedStream.first;
    });
  }

  Future<Stream<DocumentSnapshot<Object?>>> getConversationById(
      String id) async {
    return conversationsCollection.doc(id).snapshots();
  }

  Future<List<dynamic>> getConversationMembers(String conversationId) async {
    DocumentSnapshot<Object?> conversationSnapshot =
        await conversationsCollection.doc(conversationId).get();
    final data = conversationSnapshot.data()! as Map<String, dynamic>;
    final memberIds = data['members'] as List<dynamic>;
    final memberList = [];
    for (final member in memberIds) {
      final memberSnapshot = await userCollection.doc(member).get();
      final memberData = memberSnapshot.data()! as Map<String, dynamic>;
      memberList.add(memberData);
    }
    return memberList;
  }

  Future<List<Object?>> getAdmins() async {
    QuerySnapshot<Object?> adminSnapshots =
        await userCollection.where('isAdmin', isEqualTo: true).get();
    return adminSnapshots.docs
        .map((adminSnapshot) => adminSnapshot.data())
        .toList();
  }

  Future<List<Object?>> getConversationByMemberId(String memberId) async {
    QuerySnapshot<Object?> conversationSnapshot = await conversationsCollection
        .where('members', arrayContains: memberId)
        .get();
    return conversationSnapshot.docs
        .map((conversation) => conversation.data())
        .toList();
  }

  Future<void> createConversation(String targetUserEmail,
      {String message = ""}) async {
    List<Object?> admins = await getAdmins();
    UserFirebase targetUser = (await getUserDataByEmail(targetUserEmail))!;
    var targetUserId = targetUser.uid;

    saveConversationData(targetUserId, admins, message: message);
  }

  Future<void> saveConversationData(String targetUserId, List<Object?> admins,
      {String message = ""}) async {
    List<Object?> existingConversation =
        await getConversationByMemberId(targetUserId);

    List<String> members = initConversationMembers(targetUserId, admins);
    String? senderId =
        await LocalStorageHelper.getFirebaseUserIdFromLocalStorage();
    if (senderId == null) {
      throw Exception("Sender id not found");
    }

    if (existingConversation.isEmpty) {
      DocumentReference conversationDocumentReference =
          await conversationsCollection.add({
        'members': members,
        'targetUserId': targetUserId,
        'messages': [],
      });
      // ajout de l'id de la conversation qui vient d'être créée
      await conversationDocumentReference.update({
        "conversationId": conversationDocumentReference.id,
      });
      if (message.isNotEmpty) {
        sendMessage(conversationDocumentReference.id, senderId, message);
      }
      // ajout de la conversation dans la liste des conversations de chaque membre
      for (var memberId in members) {
        DocumentReference userDocumentReference = userCollection.doc(memberId);
        await userDocumentReference.update({
          'conversations': FieldValue.arrayUnion([
            {
              'conversationId': conversationDocumentReference.id,
              'isSeen': false
            }
          ])
        });
      }
    } else {
      var conversationMap = existingConversation[0] as Map<String, dynamic>;
      sendMessage(conversationMap["conversationId"], senderId, message);
    }
  }

  void setConversationToSeen(String conversationId) async {
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentSnapshot userSnapshot = await userDocumentReference.get();
    final conversationsMap = userSnapshot.data()! as Map<String, dynamic>;
    List<dynamic> conversations = conversationsMap['conversations'];

    for (var conversation in conversations) {
      if (conversation['conversationId'] == conversationId) {
        conversation['isSeen'] = true;
        break;
      }
    }

    await userDocumentReference.update({
      'conversations': conversations,
    });
  }

  void setConversationUnseenForOtherMembers(
      String conversationId, String senderId) async {
    final conversationSnapshot =
        await conversationsCollection.doc(conversationId).get();

    if (conversationSnapshot.exists) {
      final conversationData =
          conversationSnapshot.data() as Map<String, dynamic>;
      final members = conversationData['members'] as List<dynamic>;

      final userSnapshots = await userCollection
          .where(FieldPath.documentId, whereIn: members)
          .get();
      for (final userSnapshot in userSnapshots.docs) {
        final userSnapshotMap = userSnapshot.data()! as Map<String, dynamic>;
        final conversations = userSnapshotMap['conversations'] as List<dynamic>;

        if (userSnapshot.id != senderId) {
          for (var conversation in conversations) {
            if (conversation['conversationId'] == conversationId) {
              conversation['isSeen'] = false;
              break;
            }
          }

          await userCollection.doc(userSnapshot.id).update({
            'conversations': conversations,
          });
        }
      }
    }
  }

  Stream<bool> hasUnseenConversationsStream() {
    final userSnapshotStream = userCollection.doc(uid).snapshots();

    return userSnapshotStream.map((userSnapshot) {
      final userMap = userSnapshot.data()! as Map<String, dynamic>;
      final conversations = userMap['conversations'] as List<dynamic>;
      bool hasUnreadConversations = false;

      for (final conversation in conversations) {
        final isSeen = conversation['isSeen'] as bool? ?? true;
        if (!isSeen) {
          hasUnreadConversations = true;
          break;
        }
      }

      return hasUnreadConversations;
    });
  }

  Future<bool> isConversationSeen(String conversationId) async {
    DocumentSnapshot userSnapshot = await userCollection.doc(uid).get();
    final conversationsMap = userSnapshot.data()! as Map<String, dynamic>;
    List<dynamic> conversations = conversationsMap['conversations'];

    for (var conversation in conversations) {
      if (conversation['conversationId'] == conversationId) {
        return conversation['isSeen'] ?? false;
      }
    }

    return false;
  }

  Future<void> sendMessage(
      String conversationId, String senderId, String message) async {
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

  List<String> initConversationMembers(
      String targetUserId, List<Object?> admins) {
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
