import 'package:universal_html/html.dart';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CustomWebFilePicker extends StatefulWidget {
  final Function onFileSelected;
  final String? initialImage;

  const CustomWebFilePicker({
    Key? key,
    required this.onFileSelected,
    this.initialImage,
  }) : super(key: key);

  @override
  State<CustomWebFilePicker> createState() => _CustomWebFilePickerState();
}

class _CustomWebFilePickerState extends State<CustomWebFilePicker> {
  File? _selectedPicture;
  Uint8List? _selectedPictureBytes;

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
            Image.memory(_selectedPictureBytes!, height: 200, width: 200),
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

    if(pickedFile == null) {
      return;
    }

    Uint8List image = await pickedFile.readAsBytes();

    setState(() {
      _selectedPictureBytes = image;
      _selectedPicture = File([image], pickedFile.name);
    });

    widget.onFileSelected(_selectedPicture);
  }
}
