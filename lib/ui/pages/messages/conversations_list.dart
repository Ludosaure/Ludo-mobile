import 'package:flutter/material.dart';

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
            // TODO aller sur la page de la conv
            // onTap: () {
            //   context.go('${Routes.reservations.path}/${conversation.id}');
            // },
            title: Text(
              "${conversation.otherUser.firstname} ${conversation.otherUser.lastname}",
              style: _getTextStyle(conversation),
            ),
            subtitle: RichText(
              overflow: TextOverflow.ellipsis,
              strutStyle: const StrutStyle(fontSize: 12.0),
              text: TextSpan(
                style: _getTextStyle(conversation),
                text: conversation.lastMessage.content,
              ),
            ),
          ),
        );
      },
    );
  }

  TextStyle _getTextStyle(Conversation conversation) {
    return TextStyle(
        fontWeight: conversation.lastMessage.isRead
            ? FontWeight.normal
            : FontWeight.bold,
        color: Colors.black);
  }
}
