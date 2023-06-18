import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ludo_mobile/domain/models/user.dart' as dbUser;
import 'package:ludo_mobile/firebase/service/firebase_database_service.dart';
import 'package:ludo_mobile/ui/components/circle-avatar.dart';
import 'package:ludo_mobile/ui/components/scaffold/admin_scaffold.dart';
import 'package:ludo_mobile/ui/components/scaffold/home_scaffold.dart';
import 'package:ludo_mobile/ui/router/routes.dart';
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

  // TODO gestion des messages non lus
  Widget _buildConversations() {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream:
          FirebaseDatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
              .getUserConversations(),
      builder: (context, snapshot) {
        final data = snapshot.data;
        if (!snapshot.hasData ||
            snapshot.connectionState == ConnectionState.waiting) {
          if (data == null || data.isEmpty) {
            return _buildNoConversations();
          }
          return CircularProgressIndicator(
            color: Theme.of(context).colorScheme.primary,
          );
        }

        return ListView.builder(
          itemCount: data!.length,
          itemBuilder: (context, index) {
            final conversationData =
                data[index]['conversation'] as Map<String, dynamic>;
            final recentMessage = data[index]['recentMessage'] as String;

            final targetUserId = conversationData['targetUserId'] as String;
            return _buildConversation(targetUserId, recentMessage, conversationData['conversationId']);
          },
        );
      },
    );
  }

  Widget _buildConversation(String targetUserId, String recentMessage, String conversationId) {
    return StreamBuilder<DocumentSnapshot<Object?>>(
      stream: FirebaseDatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
          .getUserDataById(targetUserId)
          .asStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.exists) {
          final userData = snapshot.data!.data()! as Map<String, dynamic>;
          final userFirstName = userData['firstname'] as String;
          final userLastName = userData['name'] as String;
          final userProfilePicture = userData['profilePicture'] as String?;

          return _buildConversationTile(
              userProfilePicture, userFirstName, userLastName, recentMessage, conversationId);
        } else if (snapshot.hasError) {
          return const ListTile(
            title: Text('errors.error-loading-user-data'),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.primary,
            ),
          );
        }
      },
    );
  }

  Widget _buildConversationTile(String? userProfilePicture, String firstname,
      String lastname, String recentMessage, String conversationId) {
    return ListTile(
      leading: CustomCircleAvatar(userProfilePicture: userProfilePicture),
      title: Text(
        '$firstname $lastname',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: RichText(
        overflow: TextOverflow.ellipsis,
        strutStyle: const StrutStyle(fontSize: 12.0),
        text: TextSpan(
          text: recentMessage,
          style: const TextStyle(color: Colors.black54),
        ),
      ),
      onTap: () {
        context.push(
          '${Routes.inbox.path}/$conversationId',
        );
      },
    );
  }

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
