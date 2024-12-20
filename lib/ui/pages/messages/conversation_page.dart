import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:ludo_mobile/firebase/model/conversation.dart';
import 'package:ludo_mobile/firebase/model/message.dart';
import 'package:ludo_mobile/firebase/model/user_firebase.dart';
import 'package:ludo_mobile/firebase/service/firebase_database_service.dart';
import 'package:ludo_mobile/ui/components/circle-avatar.dart';
import 'package:ludo_mobile/ui/components/custom_back_button.dart';
import 'package:responsive_framework/responsive_framework.dart';

class ConversationPage extends StatefulWidget {
  final String conversationId;

  const ConversationPage({Key? key, required this.conversationId})
      : super(key: key);

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  Stream<Conversation>? _conversation;
  final _newMessageFormKey = GlobalKey<FormState>();
  final _messageController = TextEditingController();
  String get _conversationId => widget.conversationId;

  @override
  void initState() {
    super.initState();
    _initConversation();
  }

  void _initConversation() async {
    FirebaseDatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .setConversationToSeen(_conversationId);
    await FirebaseDatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getConversationById(_conversationId)
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
      body: Center(
        child: SizedBox(
          width: ResponsiveWrapper.of(context).isSmallerThan(MOBILE)
              ? double.infinity
              : MediaQuery.of(context).size.width * 0.6,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMessageList(),
              _buildMessageInput(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageList() {
    return Flexible(
      child: StreamBuilder(
          stream: _conversation,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final conversation = snapshot.data!;
              return ListView.builder(
                itemCount: conversation.messages.length,
                reverse: true,
                itemBuilder: (context, index) {
                  return _buildMessage(context, conversation.messages[index]);
                },
              );
            }

            if (snapshot.hasError) {
              return ListTile(
                title:
                    const Text('errors.error-loading-conversation-data').tr(),
                subtitle: Text(snapshot.error.toString()),
                dense: true,
              );
            }

            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
              ),
            );
          }),
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
                  errorText: 'form.field-required-msg'.tr(),
                ),
                autocorrect: false,
                decoration: InputDecoration(
                  hintText: 'type-message'.tr(),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  isDense: true,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                String currentUserId = FirebaseAuth.instance.currentUser!.uid;

                if (_newMessageFormKey.currentState!.validate()) {
                  FirebaseDatabaseService(uid: currentUserId)
                      .sendMessage(
                    _conversationId,
                    currentUserId,
                    _messageController.text,
                  )
                      .then(
                    (value) {
                      _messageController.text = "";
                    },
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(15),
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
    Message message,
  ) {
    var isCurrentUserMessage =
        message.sender == FirebaseAuth.instance.currentUser!.uid;
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
              _buildSenderName(context, message.sender),
              const SizedBox(height: 5.0),
              Text(
                message.message,
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
                    DateFormat('dd/MM/yyyy HH:mm').format(message.time),
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
              .getUserData(userId),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final userFirebase = snapshot.data!;
          return Text(
            '${userFirebase.firstname} ${userFirebase.name}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14.0,
            ),
          );
        }

        if (snapshot.hasError) {
          return const Text(
            'errors.error-loading-user-data',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.0,
            ),
          ).tr();
        }

        return const Text(
          'loading-label',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.0,
          ),
        ).tr();
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
                .getTargetUserDataByConversationId(_conversationId)
                .asStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final targetUser = snapshot.data!;

            var title = 'administrators'.tr();

            if (FirebaseAuth.instance.currentUser!.uid != targetUser.uid) {
              var fullName = '${targetUser.firstname} ${targetUser.name}';
              var maxCharName = 45;
              if (ResponsiveWrapper.of(context).isSmallerThan(DESKTOP)) {
                maxCharName = 15;
              }
              title = fullName.length > maxCharName
                  ? "${fullName.substring(0, maxCharName)}..."
                  : fullName;
            }
            return Row(
              children: [
                if (FirebaseAuth.instance.currentUser!.uid != targetUser.uid)
                  CustomCircleAvatar(
                      userProfilePicture: targetUser.profilePicture),
                const SizedBox(width: 10),
                Text(
                  title,
                  softWrap: true,
                  overflow: TextOverflow.visible,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: ResponsiveValue(
                      context,
                      defaultValue: 20.0,
                      valueWhen: [
                        const Condition.smallerThan(name: MOBILE, value: 18.0),
                      ],
                    ).value,
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
    List<UserFirebase> members,
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
                    member.profilePicture,
                    member.firstname,
                    member.name,
                    member.isAdmin,
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
        .getConversationMembers(_conversationId)
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
