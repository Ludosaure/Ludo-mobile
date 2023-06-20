import 'package:flutter/material.dart';

class CustomCircleAvatar extends StatelessWidget {
  final String? userProfilePicture;
  final double? height;

  const CustomCircleAvatar({Key? key, this.userProfilePicture = "", this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (userProfilePicture == null || userProfilePicture == "") {
      return Icon(
        Icons.person,
        color: Colors.grey,
        size: height != null ? height! : null,
      );
    }
    return CircleAvatar(
      backgroundColor: Colors.grey[300],
      backgroundImage: NetworkImage(userProfilePicture!),
      radius: height != null ? height! / 2 : null,
    );
  }
}
