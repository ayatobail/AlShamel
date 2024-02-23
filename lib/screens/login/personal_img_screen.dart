import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PersonalImageScreen extends StatefulWidget {
  final Function? updateImage;

  const PersonalImageScreen({this.updateImage});
  @override
  _PersonalImageScreenState createState() => _PersonalImageScreenState();
}

class _PersonalImageScreenState extends State<PersonalImageScreen> {
  FilePickerResult? result;
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
        result = value;
      });
    });
    if (result != null) {
      File fileForUpload = File(result!.files[0].path??"");
      List<int> fileInByte = fileForUpload.readAsBytesSync();
      String fileInBase64 = base64Encode(fileInByte);
      image = fileInBase64;
    }
  }

  Widget _nextButton() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(
        horizontal: 30,
      ),
      child: TextButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            Theme.of(context).primaryColor,
          ),
        ),
        child: Text(
          'تم',
          style: Theme.of(context)
              .textTheme
              .bodyText2!
              .copyWith(color: Colors.white, fontSize: 20),
        ),
        onPressed: () async {
          Navigator.pop(context);
          SharedPreferences prefs = await SharedPreferences.getInstance();
          if (result != null) {
            File fileForUpload = File(result!.files[0].path??"");
            final appDir = await getApplicationDocumentsDirectory();
            final fileName = p.basename(fileForUpload.path);
            final savedImage =
                await fileForUpload.copy('${appDir.path}/$fileName');

            prefs.setString('personalImage', savedImage.path);
            print('personal ${savedImage.path}');
          } else {
            prefs.setString('personalImage', '');
          }
          widget.updateImage!();
        },
      ),
    );
  }

  Widget _takePersonalImage(containerHeight) {
    return InkWell(
      onTap: () => _selectImages(),
      child: Container(
        height: containerHeight * .4,
        margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: Colors.white,
            image: DecorationImage(
              fit: result != null ? BoxFit.contain : BoxFit.none,
              image: result != null
                  ? FileImage(
                      File(result!.files[0].path??""),
                    )
                  : AssetImage('assets/images/face.png') as ImageProvider,
              alignment: Alignment.center,
              //width: ,
            )),
      ),
    );
  }

  Widget _header() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'الصورة الشخصية',
          style: Theme.of(context).textTheme.bodyText1!.copyWith(
              color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
        ),
        Text(
          'أضف صورتك الشخصية لاستكمال حسابك',
          style: Theme.of(context)
              .textTheme
              .bodyText2!
              .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final topPadding = MediaQuery.of(context).padding.top;
    final bottomPading = MediaQuery.of(context).padding.bottom;
    final containerHeight = deviceHeight - topPadding - bottomPading;

    return Scaffold(
      body: Container(
          margin: EdgeInsets.only(top: topPadding, bottom: bottomPading),
          alignment: Alignment.center,
          color: Theme.of(context).accentColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _header(),
              _takePersonalImage(containerHeight),
              _nextButton()
            ],
          )),
    );
  }
}
