import 'dart:convert';
import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

class CarInputMainPhoto extends StatefulWidget {
  final Function setMainPhoto;

  CarInputMainPhoto(this.setMainPhoto);
  @override
  _CarInputMainPhotoState createState() => _CarInputMainPhotoState();
}

class _CarInputMainPhotoState extends State<CarInputMainPhoto> {
  FilePickerResult? result;
  File? fileForUpload;
  String? image;

  void _selectImages() async {
    await FilePicker.platform
        .pickFiles(
      allowMultiple: false,
      type: FileType.image,
      allowCompression: true,
    )
        .then((value) {
      setState(() {
        if (value != null) {
          result = value;
          fileForUpload = File(result!.files[0].path??"");
          List<int> fileInByte = fileForUpload!.readAsBytesSync();
          String fileInBase64 = base64Encode(fileInByte);
          image = fileInBase64;

          widget.setMainPhoto(image);
        }
      });
    });
  }

  void _pickImagesFromCamera() async {
    final ImagePicker _picker = ImagePicker();
    await _picker.pickImage(source: ImageSource.camera).then((value) {
      setState(() {
        if (value != null) {
          fileForUpload = File(value.path);
          List<int> fileInByte = fileForUpload!.readAsBytesSync();
          String fileInBase64 = base64Encode(fileInByte);
          image = fileInBase64;

          widget.setMainPhoto(image);
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
                  'إضافة الصورة الرئيسية للمركبة',
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
