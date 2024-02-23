import 'dart:io';
import 'package:alshamel_new/providers/car_providers/car_item.dart';
import 'package:alshamel_new/providers/property_providers/property_item.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

class CarImagesInput extends StatefulWidget {
  @override
  _CarImagesInputState createState() => _CarImagesInputState();
}

class _CarImagesInputState extends State<CarImagesInput> {
  List<File>? imgsFiles;
  void _selectImages() async {
    imgsFiles = Provider.of<PropertyItem>(context, listen: false).getimgsForUpload;
    final ImagePicker _picker = ImagePicker();
    await _picker
        .pickMultiImage(
      maxWidth: 800,
      maxHeight: 600,
    )
        .then((value) {
      setState(() {
        if (value != null) {
          for (var e in value) {
            File fileForUpload = File(e.path);
            imgsFiles!.add(fileForUpload);
          }
          Provider.of<PropertyItem>(context, listen: false).setImgs(imgsFiles!);
        }
      });
    });
  }

  void _pickImagesFromCamera() async {
    imgsFiles = Provider.of<PropertyItem>(context, listen: false).getimgsForUpload;
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
          File fileForUpload = File(value.path);
          imgsFiles!.add(fileForUpload);

          Provider.of<PropertyItem>(context, listen: false).setImgs(imgsFiles!);
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
                  'التقاط',
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
                  'إضافة صور',
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
        Expanded(
          child: GridView.builder(
              itemCount: Provider.of<PropertyItem>(context, listen: false)
                  .getimgsForUpload
                  .length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, crossAxisSpacing: 2),
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onLongPress: () => {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: Text('حذف الصورة؟'),
                          actions: <Widget>[
                            TextButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                  Colors.red,
                                ),
                              ),
                              child: Text(
                                'إلغاء',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () => Navigator.pop(context),
                            ),
                            TextButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                  Theme.of(context).accentColor,
                                ),
                              ),
                              child: Text(
                                'نعم',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () => setState(() {
                                Provider.of<PropertyItem>(context, listen: false)
                                    .getimgsForUpload
                                    .removeAt(index);
                                Navigator.pop(context);
                              }),
                            ),
                          ],
                        );
                      },
                    )
                  },
                  child: Image.file(
                    Provider.of<PropertyItem>(context, listen: false)
                        .getimgsForUpload[index],
                    fit: BoxFit.cover,
                  ),
                );
              }),
        )
      ],
    );
  }
}
