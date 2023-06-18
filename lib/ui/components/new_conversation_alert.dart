import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:ludo_mobile/firebase/service/firebase_database_service.dart';

import 'form_field_decoration.dart';

class NewConversationAlert extends StatelessWidget {
  final _newMessageFormKey = GlobalKey<FormState>();
  final _messageController = TextEditingController();

  final String userTargetMail;

  NewConversationAlert({Key? key, required this.userTargetMail}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("new-message".tr()),
      content: Form(
        key: _newMessageFormKey,
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                controller: _messageController,
                validator: RequiredValidator(
                    errorText: 'form.field-required-msg'.tr()),
                autocorrect: false,
                decoration: FormFieldDecoration.textField("message".tr()),
              ),
            ],
          ),
        ),
      ),
      actions: [
        ElevatedButton(
          child: Text("send-label".tr()),
          onPressed: () {
            if (_newMessageFormKey.currentState!.validate()) {
              FirebaseDatabaseService(
                  uid: FirebaseAuth.instance.currentUser!.uid)
                  .createConversation(userTargetMail,
                  message: _messageController.text)
                  .then((value) {
                _messageController.text = "";
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text("message-sent").tr(),
                    duration: const Duration(seconds: 3),
                    backgroundColor: Colors.green,
                  ),
                );
              });
            }
          },
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey,
          ),
          child: Text("cancel-label".tr()),
        ),
      ],
    );
  }
}
