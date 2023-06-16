import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ludo_mobile/domain/models/conversation.dart';
import 'package:ludo_mobile/domain/models/message.dart';
import 'package:ludo_mobile/firebase/service/firebase_database_service.dart';
import 'package:ludo_mobile/ui/router/routes.dart';

class ConversationsList extends StatefulWidget {
  final List<Conversation> conversations;

  const ConversationsList({
    Key? key,
    required this.conversations,
  }) : super(key: key);

  @override
  State<ConversationsList> createState() => _ConversationsListState();
}

class _ConversationsListState extends State<ConversationsList> {
  Stream? conversations;

  @override
  void initState() {
    _getUserConversations();
    super.initState();
  }

  _getUserConversations() async {
    await FirebaseDatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getUserConversations()
        .then((snapshot) {
      setState(() {
        conversations = snapshot;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      verticalDirection: VerticalDirection.down,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          fit: FlexFit.loose,
          child: _buildConversationList(),
        ),
      ],
    );
  }

  // TODO rafraichir la page comme sur la page des jeux
  Widget _buildConversationsList(List<Conversation> conversations) {
    return ListView.builder(
      itemCount: conversations.length,
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        Conversation conversation = conversations[index];
        Message lastMessage = conversation.messages[0];
        return Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: ListTile(
            leading: conversation.otherUser.profilePicturePath != null
                ? CircleAvatar(
                    backgroundColor: Colors.grey[300],
                    backgroundImage: NetworkImage(
                        conversation.otherUser.profilePicturePath!),
                  )
                : const Icon(Icons.person),
            onTap: () {
              context.go('${Routes.inbox.path}/${conversation.otherUser.id}');
            },
            title: Text(
              "${conversation.otherUser.firstname} ${conversation.otherUser.lastname}",
              style: _getTextStyle(lastMessage),
            ),
            subtitle: RichText(
              overflow: TextOverflow.ellipsis,
              strutStyle: const StrutStyle(fontSize: 12.0),
              text: TextSpan(
                style: _getTextStyle(lastMessage),
                text: lastMessage.content,
              ),
            ),
          ),
        );
      },
    );
  }

  TextStyle _getTextStyle(Message lastMessage) {
    return TextStyle(
        fontWeight: lastMessage.isRead ? FontWeight.normal : FontWeight.bold,
        color: Colors.black);
  }

  Widget _buildConversationList() {
    return StreamBuilder(
      stream: conversations,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data['conversations'] != null &&
              snapshot.data['conversations'].length > 0) {
            return Text("HELLOOOO");
          } else {
            return _buildNoConversations();
          }
        } else {
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ),
          );
        }
      },
    );
  }

  _buildNoConversations() {
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
