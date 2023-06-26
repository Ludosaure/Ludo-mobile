import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CustomMobileFilePicker extends StatefulWidget {
  final Function onFileSelected;
  final String? initialImage;

  const CustomMobileFilePicker({
    Key? key,
    required this.onFileSelected,
    this.initialImage,
  }) : super(key: key);

  @override
  State<CustomMobileFilePicker> createState() => _CustomMobileFilePickerState();
}

class _CustomMobileFilePickerState extends State<CustomMobileFilePicker> {
  File? _selectedPicture;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7),
      ),
      child: Column(
        children: [
          if (widget.initialImage != null &&
              widget.initialImage != "" &&
              _selectedPicture == null)
            Image.network(widget.initialImage!, height: 200, width: 200),
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
                    setState(() {
                      _selectedPicture = null;
                    });
                  },
                  icon: const Icon(Icons.delete),
                ),
              IconButton(
                onPressed: () {
                  _selectAvatar();
                },
                icon: const Icon(Icons.camera_alt),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _selectAvatar() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        _selectedPicture = File(pickedFile.path);
      });

      widget.onFileSelected(_selectedPicture);
    }
  }
}
