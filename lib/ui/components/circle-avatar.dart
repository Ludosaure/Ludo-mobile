import 'package:flutter/material.dart';

class CustomCircleAvatar extends StatelessWidget {
  final String? userProfilePicture;

  const CustomCircleAvatar({Key? key, this.userProfilePicture = ""})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (userProfilePicture == null || userProfilePicture == "") {
      return const Icon(
        Icons.person,
        color: Colors.grey,
      );
    }
    return CircleAvatar(
      backgroundColor: Colors.grey[300],
      backgroundImage: NetworkImage(userProfilePicture!),
    );
  }
}
