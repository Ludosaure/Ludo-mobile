import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:intl/intl.dart';
import 'package:ludo_mobile/firebase/models/firebase_conversation.dart';
import 'package:ludo_mobile/firebase/service/firebase_database_service.dart';
import 'package:ludo_mobile/ui/components/circle-avatar.dart';
import 'package:ludo_mobile/ui/components/custom_back_button.dart';
import 'package:responsive_framework/responsive_wrapper.dart';

class ConversationPage extends StatefulWidget {
  final String conversationId;

  const ConversationPage({Key? key, required this.conversationId})
      : super(key: key);

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  Stream<DocumentSnapshot>? _conversation;
  final _newMessageFormKey = GlobalKey<FormState>();
  final _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initConversation();
  }

  void _initConversation() async {
    FirebaseDatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .setConversationToSeen(widget.conversationId);
    await FirebaseDatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getConversationStreamById(widget.conversationId)
        .then((snapshot) {
      setState(() {
        _conversation = snapshot;
      });
    });
  }

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

  Widget _buildMessageList() {
    return Flexible(
      child: StreamBuilder(
        stream: _conversation,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.exists) {
            final conversationData =
                snapshot.data!.data()! as Map<String, dynamic>;
            List<dynamic> messages =
                (conversationData['messages'] as List<dynamic>)
                    .reversed
                    .toList();
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

  Widget _buildMessageInput(BuildContext context) {
    return Form(
      key: _newMessageFormKey,
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: TextFormField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                controller: _messageController,
                validator: RequiredValidator(
                    errorText: 'form.field-required-msg'.tr()),
                autocorrect: false,
                decoration: InputDecoration(
                  hintText: 'type-message'.tr(),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                String currentUserId = FirebaseAuth.instance.currentUser!.uid;
                if (_newMessageFormKey.currentState!.validate()) {
                  FirebaseDatabaseService(uid: currentUserId)
                      .sendMessage(widget.conversationId, currentUserId,
                          _messageController.text)
                      .then((value) {
                    _messageController.text = "";
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
              ),
              child: const Icon(Icons.send),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessage(
    BuildContext context,
    dynamic message,
  ) {
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
              _buildSenderName(context, message['sender']),
              const SizedBox(height: 5.0),
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
                    DateFormat('dd/MM/yyyy HH:mm').format(
                      (message['time'] as Timestamp).toDate(),
                    ),
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

  Widget _buildSenderName(
    BuildContext context,
    String userId,
  ) {
    return StreamBuilder(
      stream:
          FirebaseDatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
              .getUserById(userId)
              .asStream(),
      builder: (context, snapshot) {
        final data = snapshot.data;
        if (!snapshot.hasData || snapshot.data == null ||
            snapshot.connectionState == ConnectionState.waiting) {
          if (data == null) {
            return Text(
              'errors.error-loading-user-data'.tr(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14.0,
              ),
            );
          }
          return Text(
            'loading-label'.tr(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14.0,
            ),
          );
        }

        final userFirebase = data!;
        return Text(
          '${userFirebase.firstname} ${userFirebase.name}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14.0,
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: const Padding(
        padding: EdgeInsets.all(8.0),
        child: CustomBackButton(),
      ),
      leadingWidth: MediaQuery.of(context).size.width * 0.20,
      title: StreamBuilder(
        stream:
            FirebaseDatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                .getTargetUserByConversationId(widget.conversationId)
                .asStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            final userFirebase = snapshot.data!;

            final fullName = '${userFirebase.firstname} ${userFirebase.name}';
            var maxCharName = 45;
            if (ResponsiveWrapper.of(context).isSmallerThan(DESKTOP)) {
              maxCharName = 15;
            }
            return Row(
              children: [
                CustomCircleAvatar(userProfilePicture: userFirebase.profilePicture),
                const SizedBox(width: 10),
                Text(
                  fullName.length > maxCharName
                      ? "${fullName.substring(0, maxCharName)}..."
                      : fullName,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    overflow: TextOverflow.ellipsis,
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
      actions: [
        Padding(
          padding:
              EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.05),
          child: IconButton(
            onPressed: () async {
              await _showGroupInfosDialog(context);
            },
            icon:
                const Icon(Icons.info_outline, color: Colors.black, size: 30.0),
          ),
        ),
      ],
    );
  }

  _buildGroupInformationsAlert(
    BuildContext context,
    List<dynamic> members,
  ) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.info_outline, color: Colors.black, size: 30.0),
          const SizedBox(width: 10.0),
          Text("infos".tr()),
        ],
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.5,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(Icons.group, color: Colors.black, size: 20.0),
                  const SizedBox(width: 10.0),
                  Text("conversation-members".tr()),
                ],
              ),
              const SizedBox(height: 10.0),
              ListView.builder(
                shrinkWrap: true,
                itemCount: members.length,
                itemBuilder: (context, index) {
                  final member = members[index];
                  return _buildConversationMember(
                    member['profilePicture'],
                    member['firstname'],
                    member['name'],
                    member['isAdmin'],
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  _showGroupInfosDialog(BuildContext parentContext) async {
    await FirebaseDatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getConversationMembers(widget.conversationId)
        .then((members) {
      showDialog(
        context: parentContext,
        builder: (BuildContext context) {
          return _buildGroupInformationsAlert(context, members);
        },
      );
    });
  }

  _buildConversationMember(
    String? userProfilePicture,
    String firstname,
    String lastname,
    bool isAdmin,
  ) {
    return ListTile(
      leading: CustomCircleAvatar(userProfilePicture: userProfilePicture),
      title: Text(
        '$firstname $lastname ${isAdmin ? ' (admin)' : ''}',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
