import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ludo_mobile/firebase/service/firebase_database_service.dart';
import 'package:ludo_mobile/ui/components/custom_back_button.dart';

class ConversationPage extends StatelessWidget {
  final String conversationId;

  const ConversationPage({Key? key, required this.conversationId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMessageList(),
          _buildMessageInput(context),
        ],
      ),
    );
  }

  Widget _buildMessageInput(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'type-message'.tr(),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
            ),
            child: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return Flexible(
      child: StreamBuilder(
        stream:
            FirebaseDatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                .getConversationById(conversationId)
                .asStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.exists) {
            final userData = snapshot.data!.data()! as Map<String, dynamic>;
            List<dynamic> messages =
                (userData['messages'] as List<dynamic>).reversed.toList();
            return ListView.builder(
              itemCount: messages.length,
              reverse: true,
              itemBuilder: (context, index) {
                return _buildMessage(context, messages[index]);
              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildMessage(BuildContext context, dynamic message) {
    var isCurrentUserMessage =
        message['sender'] == FirebaseAuth.instance.currentUser!.uid;
    return ListTile(
      title: FractionallySizedBox(
        alignment:
            isCurrentUserMessage ? Alignment.centerRight : Alignment.centerLeft,
        widthFactor: 0.7,
        child: Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: isCurrentUserMessage
                ? Theme.of(context).colorScheme.primary
                : Colors.grey,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                message['message'],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
              const SizedBox(height: 5.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    DateFormat('dd/MM/yyyy HH:mm')
                        .format((message['time'] as Timestamp).toDate()),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: const Padding(
        padding: EdgeInsets.all(8.0),
        child:
            CustomBackButton(), // TODO faire retourner sur la page des messages
      ),
      leadingWidth: MediaQuery.of(context).size.width * 0.20,
      title: StreamBuilder<DocumentSnapshot<Object?>>(
        stream: FirebaseDatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
            .getTargetUserDataByConversationId(conversationId)
            .asStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.exists) {
            final userData = snapshot.data!.data()! as Map<String, dynamic>;
            final userFirstName = userData['firstname'] as String;
            final userLastName = userData['name'] as String;
            final userProfilePicture = userData['profilePicture'] as String?;

            return Row(
              children: [
                if (userProfilePicture != null && userProfilePicture != "")
                  CircleAvatar(
                    backgroundColor: Colors.grey[300],
                    backgroundImage: NetworkImage(userProfilePicture),
                  ),
                const SizedBox(width: 10),
                Text(
                  '$userFirstName $userLastName',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
              ],
            );
          } else {
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
              ),
            );
          }
        },
      ),
    );
  }
}
