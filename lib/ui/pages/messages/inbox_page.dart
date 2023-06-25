import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ludo_mobile/domain/models/user.dart' as db_user;
import 'package:ludo_mobile/firebase/service/firebase_database_service.dart';
import 'package:ludo_mobile/ui/components/circle-avatar.dart';
import 'package:ludo_mobile/ui/components/new_conversation_alert.dart';
import 'package:ludo_mobile/ui/components/scaffold/admin_scaffold.dart';
import 'package:ludo_mobile/ui/components/scaffold/home_scaffold.dart';
import 'package:ludo_mobile/ui/router/routes.dart';
import 'package:ludo_mobile/utils/local_storage_helper.dart';
import 'package:ludo_mobile/utils/menu_items.dart';

class InboxPage extends StatefulWidget {
  final db_user.User user;

  const InboxPage({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<InboxPage> createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage> {
  List<String> conversationIds = [];

  @override
  void initState() {
    super.initState();
    _initConversationIds();
  }

  void _initConversationIds() {
    FirebaseDatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getConversationIds()
        .listen((snapshot) {
      conversationIds = snapshot;
      if (conversationIds.isNotEmpty && !widget.user.isAdmin()) {
        context.go('${Routes.inbox.path}/${conversationIds.first}');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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

    return HomeScaffold(
      body: Center(
        child: _buildClientNewConversationButton(),
      ),
      user: widget.user,
      navBarIndex: MenuItems.Messages.index,
    );
  }

  Widget _buildClientNewConversationButton() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () async {
          await _showNewMessageDialog(context);
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.add_circle,
                color: Colors.white,
              ),
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  "start-conv-with-admins".tr(),
                  overflow: TextOverflow.visible,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _showNewMessageDialog(BuildContext parentContext) async {
    db_user.User currentUser =
        (await LocalStorageHelper.getUserFromLocalStorage())!;
    showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return NewConversationAlert(userTargetMail: currentUser.email);
      },
    );
  }

  Widget _buildConversations() {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: FirebaseDatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).getUserConversations(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(
            color: Theme.of(context).colorScheme.primary,
          );
        }

        final data = snapshot.data;
        if (!snapshot.hasData || data == null || data.isEmpty) {
          return _buildNoConversations();
        }

        return ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            final conversationData = data[index]['conversation'] as Map<String, dynamic>;
            final recentMessage = data[index]['recentMessage'] as String;

            final targetUserId = conversationData['targetUserId'] as String;
            final conversationId = conversationData['conversationId'] as String;

            return FutureBuilder<bool>(
              future: FirebaseDatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).isConversationSeen(conversationId),
              builder: (context, snapshot) {
                final isSeen = snapshot.data ?? false;
                return _buildConversation(
                  targetUserId,
                  recentMessage,
                  isSeen,
                  conversationId,
                );
              },
            );
          },
        );
      },
    );
  }


  Widget _buildConversation(
    String targetUserId,
    String recentMessage,
    bool isSeen,
    String conversationId,
  ) {
    return StreamBuilder<DocumentSnapshot<Object?>>(
      stream:
          FirebaseDatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
              .getUserDataById(targetUserId)
              .asStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.exists) {
          final userData = snapshot.data!.data()! as Map<String, dynamic>;
          final userFirstName = userData['firstname'] as String;
          final userLastName = userData['name'] as String;
          final userProfilePicture = userData['profilePicture'] as String?;

          return _buildConversationTile(
            userProfilePicture,
            userFirstName,
            userLastName,
            isSeen,
            recentMessage,
            conversationId,
          );
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

  Widget _buildConversationTile(
    String? userProfilePicture,
    String firstname,
    String lastname,
    bool isSeen,
    String recentMessage,
    String conversationId,
  ) {
    return ListTile(
      leading: CustomCircleAvatar(userProfilePicture: userProfilePicture),
      title: Text(
        '$firstname $lastname',
        style:
            TextStyle(fontWeight: isSeen ? FontWeight.normal : FontWeight.bold),
      ),
      subtitle: RichText(
        overflow: TextOverflow.ellipsis,
        strutStyle: const StrutStyle(fontSize: 12.0),
        text: TextSpan(
          text: recentMessage,
          style: TextStyle(
            color: Colors.black54,
            fontWeight: isSeen ? FontWeight.normal : FontWeight.bold,
          ),
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
