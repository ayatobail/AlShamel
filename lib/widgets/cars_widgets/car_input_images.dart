import 'dart:convert';
import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class CarImageInput extends StatefulWidget {
  final Function setUploadedImages;

  CarImageInput(this.setUploadedImages);
  @override
  _CarImageInputState createState() => _CarImageInputState();
}

class _CarImageInputState extends State<CarImageInput> {
  FilePickerResult? result;
  List<String> images = [];

  void _selectImages() async {
    await FilePicker.platform
        .pickFiles(
      allowMultiple: true,
      type: FileType.image,
      allowCompression: true,
    )
        .then((value) {
      setState(() {
        result = value;
      });
    });
    if (result != null) {
      for (var e in result!.files) {
        File fileForUpload = File(e.path??"");
        List<int> fileInByte = fileForUpload.readAsBytesSync();
        String fileInBase64 = base64Encode(fileInByte);
        images.add(fileInBase64);
      }
      widget.setUploadedImages(images);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton.icon(
          onPressed: _selectImages,
          icon: Icon(
            Icons.add_a_photo_outlined,
            color: Theme.of(context).accentColor,
          ),
          label: AutoSizeText(
            'إضافة صور',
            overflow: TextOverflow.ellipsis,
            textScaleFactor: MediaQuery.of(context).textScaleFactor,
            minFontSize: 9,
            style: Theme.of(context).textTheme.bodyText2!.copyWith(
                color: Theme.of(context).accentColor,
                fontWeight: FontWeight.bold),
          ),
        ),
        if (result != null)
          Expanded(
            child: GridView.builder(
                itemCount: result!.files.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, crossAxisSpacing: 2),
                itemBuilder: (BuildContext context, int index) {
                  PlatformFile file = result!.files[index];
                  File fileForUpload = File(file.path??"");
                  return Image.file(
                    fileForUpload,
                    fit: BoxFit.cover,
                  );
                }),
          )
        else
          Container()
      ],
    );
  }
}
