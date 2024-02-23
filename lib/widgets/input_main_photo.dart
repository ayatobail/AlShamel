import 'dart:convert';
import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class InputMainPhoto extends StatefulWidget {
  final Function? setMainPhotoFunc;
  final String? title;

  InputMainPhoto({this.setMainPhotoFunc, this.title});
  @override
  _InputMainPhotoState createState() => _InputMainPhotoState();
}

class _InputMainPhotoState extends State<InputMainPhoto> {
  File? fileForUpload;
  String? image;

  void _selectImages() async {
    final ImagePicker _picker = ImagePicker();
    await _picker
        .pickImage(maxWidth: 800, maxHeight: 600, source: ImageSource.gallery)
        .then((value) {
      setState(() {
        if (value != null) {
          fileForUpload = File(value.path);
          List<int> fileInByte = fileForUpload!.readAsBytesSync();
          String fileInBase64 = base64Encode(fileInByte);
          image = fileInBase64;

          widget.setMainPhotoFunc!(image);
        }
      });
    });
  }

  void _pickImagesFromCamera() async {
    final ImagePicker _picker = ImagePicker();
    await _picker
        .pickImage(
      source: ImageSource.camera,
      maxWidth: 800,
      maxHeight: 600,
    )
        .then((value) {
      setState(() {
        if (value != null) {
          fileForUpload = File(value.path);
          List<int> fileInByte = fileForUpload!.readAsBytesSync();
          String fileInBase64 = base64Encode(fileInByte);
          image = fileInBase64;

          widget.setMainPhotoFunc!(image);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FittedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextButton.icon(
                onPressed: _pickImagesFromCamera,
                icon: Icon(
                  Icons.add_a_photo_outlined,
                  color: Theme.of(context).accentColor,
                ),
                label: AutoSizeText(
                  'التقاط صورة رئيسية',
                  overflow: TextOverflow.ellipsis,
                  textScaleFactor: MediaQuery.of(context).textScaleFactor,
                  minFontSize: 9,
                  style: Theme.of(context).textTheme.bodyText2!.copyWith(
                      color: Theme.of(context).accentColor,
                      fontWeight: FontWeight.bold),
                ),
              ),
              TextButton.icon(
                onPressed: _selectImages,
                icon: Icon(
                  Icons.photo_album_outlined,
                  color: Theme.of(context).primaryColorLight,
                ),
                label: AutoSizeText(
                  '${widget.title}',
                  overflow: TextOverflow.ellipsis,
                  textScaleFactor: MediaQuery.of(context).textScaleFactor,
                  minFontSize: 9,
                  style: Theme.of(context).textTheme.bodyText2!.copyWith(
                      color: Theme.of(context).primaryColorLight,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        if (fileForUpload != null)
          Expanded(
              child: Image.file(
            fileForUpload!,
            fit: BoxFit.cover,
          ))
        else
          Container()
      ],
    );
  }
}
