import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ludo_mobile/firebase/model/conversation.dart';
import 'package:ludo_mobile/firebase/model/user_conversation.dart';
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

  UserFirebase? userFirebaseFromDocumentSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    var data = snapshot.data();
    if (data == null) {
      return null;
    }
    return UserFirebase.fromMap(data);
  }

  List<UserFirebase?> userFirebaseListFromQuerySnapshot(
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

  Stream<Conversation> getConversationData(String id) {
    return conversationsCollection
        .doc(id)
        .snapshots()
        .map((conversationSnapshot) {
      return conversationFromSnapshot(
          conversationSnapshot as DocumentSnapshot<Map<String, dynamic>>);
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
    return userCollection.doc(uid).snapshots().map((userSnapshot) {
      final userFirebase = userFirebaseFromDocumentSnapshot(
          userSnapshot as DocumentSnapshot<Map<String, dynamic>>)!;

      final conversationIds = userFirebase.conversations.map((conversation) {
        return conversation.conversationId;
      }).toList();
      return conversationIds;
    });
  }

  // TODO corriger l'ajout de la conversation dans la liste des conversations de l'utilisateur (admin ?)
  // TODO faire cette méthode à la fin
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

  List<String> initConversationIdsList(List<dynamic> conversations) {
    final List<String> conversationIds = [];
    for (final conversation in conversations) {
      conversationIds.add(conversation['conversationId'] as String);
    }
    return conversationIds;
  }

  Future<Stream<Conversation>> getConversationById(String id) async {
    return getConversationData(id);
  }

  Future<List<UserFirebase>> getConversationMembers(
      String conversationId) async {
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

  Future<void> createConversation(String targetUserEmail,
      {String message = ""}) async {
    List<UserFirebase> admins = await getAdmins();
    UserFirebase targetUser = (await getUserDataByEmail(targetUserEmail))!;
    var targetUserId = targetUser.uid;

    saveConversationData(targetUserId, admins, message: message);
  }

  Future<void> saveConversationData(
      String targetUserId, List<UserFirebase> admins,
      {String message = ""}) async {
    List<Conversation> existingConversation =
        await getConversationsByMemberId(targetUserId);

    List<String> memberIds = initConversationMemberIds(targetUserId, admins);
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
      // ajout de l'id de la conversation qui vient d'être créée
      await conversationDocumentReference.update({
        "conversationId": conversationDocumentReference.id,
      });
      if (message.isNotEmpty) {
        sendMessage(conversationDocumentReference.id, senderId, message);
      }
      // ajout de la conversation dans la liste des conversations de chaque membre
      for (var memberId in memberIds) {
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
      // peut arriver quand c'est un admin qui envoie un message à un client via
      // sa réservation (un client n'a qu'une seule conversation)
      sendMessage(existingConversation[0].conversationId, senderId, message);
    }
  }

  void setConversationToSeen(String conversationId) async {
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentSnapshot userSnapshot = await userDocumentReference.get();
    UserFirebase user = userFirebaseFromDocumentSnapshot(
        userSnapshot as DocumentSnapshot<Map<String, dynamic>>)!;
    print(user);
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

  List<String> initConversationMemberIds(
      String targetUserId, List<UserFirebase> admins) {
    List<String> members = admins.map((admin) => admin.uid).toList();
    members.add(targetUserId);
    return members;
  }
}
