import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:image_cropper/image_cropper.dart';



class UserImagePicker extends StatefulWidget {

  UserImagePicker(this.imageSubmitFn);

  final void Function(File pickedImge) imageSubmitFn;

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {

  File _userImage;

  void _pickImage() async
  {
    final pickedImage = await ImagePicker().getImage(
        source: ImageSource.gallery,
        imageQuality: 50,
        maxWidth: 150);

    File croppedFile = await ImageCropper.cropImage(
        sourcePath: pickedImage.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
    );

    setState(() {
      _userImage = croppedFile;
    });
    widget.imageSubmitFn(_userImage);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CircleAvatar(
          radius: 50,
          backgroundImage: _userImage==null ?
              NetworkImage('https://www.winhelponline.com/blog/wp-content/uploads/2017/12/user.png') :
              FileImage(_userImage),
        ),
        FlatButton.icon(
          label: Text("Pick your profile image"),
          icon: Icon(Icons.image),
          color:Theme.of(context).primaryColor,
          onPressed:_pickImage
        ),
      ],
    );
  }
}
