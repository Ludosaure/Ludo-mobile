import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ludo_mobile/domain/models/user.dart' as db_user;
import 'package:ludo_mobile/firebase/model/conversation.dart';
import 'package:ludo_mobile/firebase/service/firebase_database_service.dart';
import 'package:ludo_mobile/firebase/service/firebase_database_utils.dart';
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
  StreamSubscription<List<String>>? subscription;

  @override
  void initState() {
    super.initState();
    _initConversationIds();
  }

  void _initConversationIds() {
    final databaseService =
        FirebaseDatabaseService(uid: FirebaseAuth.instance.currentUser!.uid);
    subscription = databaseService.getConversationIds().listen((snapshot) {
      conversationIds = snapshot;
      if (conversationIds.isNotEmpty && !widget.user.isAdmin()) {
        context.go('${Routes.inbox.path}/${conversationIds.first}');
      }
    });
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
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
    return StreamBuilder(
      stream:
          FirebaseDatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
              .getConversationsDataOfCurrentUser(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final conversations =
              FirebaseDatabaseUtils.sortConversationsByRecentMessageTime(
            snapshot.data!,
          );
          if (conversations.isEmpty) {
            return _buildNoConversations();
          }
          return _buildConversationList(conversations);
        }

        if (snapshot.hasError) {
          return ListTile(
            title: const Text('errors.error-loading-user-data').tr(),
            subtitle: Text(snapshot.error.toString()),
          );
        }

        return CircularProgressIndicator(
          color: Theme.of(context).colorScheme.primary,
        );
      },
    );
  }

  Widget _buildConversationList(List<Conversation> conversations) {
    return ListView.builder(
      itemCount: conversations.length,
      itemBuilder: (context, index) {
        final conversation = conversations[index];
        return FutureBuilder<bool>(
          future: FirebaseDatabaseService(
                  uid: FirebaseAuth.instance.currentUser!.uid)
              .isConversationSeen(conversation.conversationId),
          builder: (context, snapshot) {
            final isSeen = snapshot.data ?? false;
            return _buildConversation(
              conversation.targetUserId,
              conversation.recentMessage,
              isSeen,
              conversation.conversationId,
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
    return StreamBuilder(
      stream:
          FirebaseDatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
              .getUserData(targetUserId),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final userFirebase = snapshot.data!;

          return _buildConversationTile(
            userFirebase.profilePicture,
            userFirebase.firstname,
            userFirebase.name,
            isSeen,
            recentMessage,
            conversationId,
          );
        }

        if (snapshot.hasError) {
          return ListTile(
            title: const Text('errors.error-loading-user-data').tr(),
            subtitle: Text(snapshot.error.toString()),
          );
        }

        return Center(
          child: CircularProgressIndicator(
            color: Theme.of(context).colorScheme.primary,
          ),
        );
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
