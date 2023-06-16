import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ludo_mobile/domain/models/user.dart' as dbUser;
import 'package:ludo_mobile/firebase/service/firebase_database_service.dart';
import 'package:ludo_mobile/ui/components/scaffold/admin_scaffold.dart';
import 'package:ludo_mobile/ui/components/scaffold/home_scaffold.dart';
import 'package:ludo_mobile/utils/menu_items.dart';

class InboxPage extends StatefulWidget {
  final dbUser.User user;

  const InboxPage({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<InboxPage> createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage> {
  @override
  Widget build(BuildContext context) {
    return _getScaffold();
  }

  Widget _getScaffold() {
    // TODO si admin liste des convs
    if (widget.user.isAdmin()) {
      return AdminScaffold(
        body: Center(
          child: _buildConversations(),
        ),
        user: widget.user,
        onSearch: null,
        onSortPressed: null,
        navBarIndex: MenuItems.Messages.index,
      );
    }

    // TODO si client proposer de créer une nouvelle conv avec les admins
    return HomeScaffold(
      body: Center(
        child: _buildConversations(),
      ),
      user: widget.user,
      navBarIndex: MenuItems.Messages.index,
    );
  }

  Widget _buildConversations() {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream:
          FirebaseDatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
              .getUserConversations(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          // TODO trad
          return Text('Erreur: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        final data = snapshot.data;
        if (data == null || data.isEmpty) {
          return const Text('Aucune conversation trouvée');
        }

        return ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            final conversationData =
                data[index]['conversation'] as Map<String, dynamic>;
            final membersData =
                data[index]['members'] as List<Map<String, dynamic>>;

            // Extract relevant information from the conversationData and membersData
            final lastMessage = conversationData['recentMessage'] as String;
            final targetUserId = conversationData['targetUserId'] as String;
            final profilePictures = membersData
                .map((member) => member['profilePicture'] as String?)
                .toList();
            final names = membersData
                .map((member) => '${member['firstname']} ${member['name']}')
                .toList();

            return StreamBuilder<DocumentSnapshot<Object?>>(
              stream: FirebaseDatabaseService(uid: targetUserId)
                  .getUserDataById(targetUserId)
                  .asStream(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data!.exists) {
                  final userData =
                      snapshot.data!.data()! as Map<String, dynamic>;
                  final userFirstName = userData['firstname'] as String;
                  final userLastName = userData['name'] as String;
                  final userProfilePicture =
                      userData['profilePicture'] as String?;

                  return ListTile(
                    leading: (userProfilePicture != null &&
                            userProfilePicture != "")
                        ? CircleAvatar(
                            backgroundColor: Colors.grey[300],
                            backgroundImage: NetworkImage(userProfilePicture!),
                          )
                        : const Icon(Icons.person),
                    title: Text(
                      '$userFirstName $userLastName',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(lastMessage),
                    onTap: () {
                      // Handle conversation item tap
                    },
                  );
                } else if (snapshot.hasError) {
                  return ListTile(
                    title: Text('Error loading user data'),
                  );
                } else {
                  return ListTile(
                    title: Text('Loading user data...'),
                  );
                }
              },
            );
          },
        );
        ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            final conversationData =
                data[index]['conversation'] as Map<String, dynamic>;
            final membersData =
                data[index]['members'] as List<Map<String, dynamic>>;

            return ListTile(
              title: Text(
                  'Conversation ID: ${conversationData['conversationId']}'),
              subtitle: Text('Nombre de membres: ${membersData.length}'),
            );
          },
        );
      },
    );
    // StreamBuilder(
    //   stream: conversations,
    //   builder: (context, AsyncSnapshot snapshot) {
    //     if (snapshot.hasData) {
    //       if (snapshot.data['conversations'] != null &&
    //           snapshot.data['conversations'].length > 0) {
    //         return _buildConversationsList(snapshot.data['conversations']);
    //       } else {
    //         return _buildNoConversations();
    //       }
    //     } else {
    //       return Center(
    //         child: CircularProgressIndicator(
    //           color: Theme.of(context).primaryColor,
    //         ),
    //       );
    //     }
    //   },
    // );
  }

  // TODO voir comment gérer le fait d'avoir vu les messages
  Widget _buildConversationsList(dynamic conversations) {
    for (var conversation in conversations) {
      // print(conversation);
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        verticalDirection: VerticalDirection.down,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [],
      ),
    );
  }

  // Widget _buildConversationsListOld() {
  //   return Flexible(
  //     fit: FlexFit.loose,
  //     child: ListView.builder(
  //       itemCount: conversations.length,
  //       scrollDirection: Axis.vertical,
  //       itemBuilder: (context, index) {
  //         Conversation conversation = conversations[index];
  //         Message lastMessage = conversation.messages[0];
  //         return Card(
  //           color: Colors.white,
  //           shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.circular(10.0),
  //           ),
  //           child: ListTile(
  //             leading: conversation.otherUser.profilePicturePath != null
  //                 ? CircleAvatar(
  //                     backgroundColor: Colors.grey[300],
  //                     backgroundImage: NetworkImage(
  //                         conversation.otherUser.profilePicturePath!),
  //                   )
  //                 : const Icon(Icons.person),
  //             onTap: () {
  //               context.push(
  //                 '${Routes.inbox.path}/${conversation.otherUser.id}',
  //               );
  //             },
  //             title: Text(
  //               "${conversation.otherUser.firstname} ${conversation.otherUser.lastname}",
  //               style: _getTextStyle(lastMessage),
  //             ),
  //             subtitle: RichText(
  //               overflow: TextOverflow.ellipsis,
  //               strutStyle: const StrutStyle(fontSize: 12.0),
  //               text: TextSpan(
  //                 style: _getTextStyle(lastMessage),
  //                 text: lastMessage.content,
  //               ),
  //             ),
  //           ),
  //         );
  //       },
  //     ),
  //   );
  // }

  Widget _buildNoConversations() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("no-conversation".tr()),
          const SizedBox(
            height: 25,
          ),
          Text(
            "how-contact-user".tr(),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
