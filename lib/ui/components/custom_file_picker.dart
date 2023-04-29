import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

//WIP Ne pas faire le code review
class CustomFilePicker extends StatelessWidget {
  File? _selectedPicture;
  CustomFilePicker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ThemeData.from(
          colorScheme: const ColorScheme.light(),
        ).cardColor,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Column(children: [
        if (_selectedPicture != null)
          Image.file(_selectedPicture!, height: 200, width: 200),
        Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_selectedPicture != null)
                IconButton(
                  onPressed: () {
                    // setState(() {
                      _selectedPicture = null;
                    // });
                  },
                  icon: const Icon(Icons.delete),
                ),
              IconButton(
                onPressed: () {
                  _selectAvatar();
                },
                icon: const Icon(Icons.camera_alt),
              ),
            ])
      ]),
    );
  }

  void _selectAvatar() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      _selectedPicture = File(pickedFile.path);
    }
  }
}
