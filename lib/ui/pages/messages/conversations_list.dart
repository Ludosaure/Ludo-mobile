import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ludo_mobile/domain/models/message.dart';
import 'package:ludo_mobile/ui/router/routes.dart';

import '../../../domain/models/conversation.dart';

class ConversationsList extends StatelessWidget {
  final List<Conversation> conversations;

  const ConversationsList({
    Key? key,
    required this.conversations,
  }) : super(key: key);

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
          child: _buildConversationsList(
            conversations,
          ),
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
        fontWeight: lastMessage.isRead
            ? FontWeight.normal
            : FontWeight.bold,
        color: Colors.black);
  }
}
