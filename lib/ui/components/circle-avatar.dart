import 'package:flutter/material.dart';

class CustomCircleAvatar extends StatelessWidget {
  final String? userProfilePicture;
  final double? height;
  final Color color;

  const CustomCircleAvatar({
    Key? key,
    this.userProfilePicture = "",
    this.height,
    this.color = Colors.grey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (userProfilePicture == null || userProfilePicture == "") {
      return Icon(
        Icons.person,
        color: color,
        size: height != null ? height! : null,
      );
    }
    return CircleAvatar(
      backgroundColor: Colors.grey[300],
      backgroundImage: NetworkImage(userProfilePicture!),
      radius: height != null ? height! : null,
    );
  }
}
