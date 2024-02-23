import 'dart:io';

import 'package:alshamel_new/providers/owner.dart';
import 'package:alshamel_new/screens/profile/edit_profile.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PersonalInfoScreen extends StatefulWidget {
  static String routeName = '/personal_info';

  @override
  _PersonalInfoScreenState createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  SharedPreferences? prefs;
  String? photo;
  @override
  void initState() {
    getPersonalImage();
    super.initState();
  }

  void getPersonalImage() async {
    try {
      /// Checks if shared preference exist
      Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
      prefs = await _prefs;
    } catch (err) {
      /// setMockInitialValues initiates shared preference
      /// Adds app-name
      //SharedPreferences.setMockInitialValues({});
      Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
      prefs = await _prefs;
    }
    setState(() {
      if (prefs!.containsKey('personalImage') &&
          prefs!.getString('personalImage') != '')
        photo = prefs!.getString('personalImage');
    });
  }

  @override
  Widget build(BuildContext context) {
    final ownerData = Provider.of<Owner>(context, listen: false);
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
          child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Stack(children: <Widget>[
              Ink(
                height: height * .3,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                ),
              ),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 190),
                child: Column(
                  children: <Widget>[
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      color: Colors.grey.shade500,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: Colors.white,
                            width: 3.0,
                          ),
                        ),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: photo != null
                                ? Image(
                                    fit: BoxFit.cover,
                                    image: FileImage(
                                      File(prefs!.getString('personalImage')??""),
                                    ))
                                : Icon(
                                    Icons.person,
                                    size: 70,
                                    color: Theme.of(context).accentColor,
                                  )),
                      ),
                    ),
                  ],
                ),
              )
            ]),
            SizedBox(height: 10.0),
            _buildMainInfo(context, ownerData),
            _buildInfo(context, ownerData),
            SizedBox(height: 20.0),
            TextButton.icon(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => EditProfile())),
              icon: Icon(
                Icons.edit,
                color: Theme.of(context).accentColor,
              ),
              label: Text(
                "تعديل",
                style: TextStyle(
                  color: Theme.of(context).primaryColorLight,
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}

Widget _buildMainInfo(context, Owner ownerData) {
  return Container(
    margin: const EdgeInsets.all(8),
    alignment: AlignmentDirectional.center,
    child: Column(
      children: <Widget>[
        AutoSizeText(
          '${ownerData.currentUser!.firstname} ${ownerData.currentUser!.lastname??""}',
          textDirection: TextDirection.rtl,
          overflow: TextOverflow.ellipsis,
          textScaleFactor: MediaQuery.of(context).textScaleFactor,
          minFontSize: 9,
          style: Theme.of(context).textTheme.bodyText1!.copyWith(
                color: Theme.of(context).primaryColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
        ),
        // SizedBox(height: 10),
      ],
    ),
  );
}

Widget _buildInfo(BuildContext context, Owner ownerData) {
  return Container(
    padding: EdgeInsets.all(10),
    child: Container(
      alignment: Alignment.topLeft,
      padding: EdgeInsets.all(15),
      child: Column(
        children: <Widget>[
          Column(
            children: <Widget>[
              makeListTile(
                context,
                'اسم المستخدم',
                '${ownerData.currentUser!.firstname} ${ownerData.currentUser!.lastname??""}',
                Icons.person,
              ),
              makeListTile(
                context,
                'الهاتف',
                ownerData.currentUser!.phone??"",
                Icons.phone_android,
              ),
              makeListTile(
                context,
                'الايميل',
                ownerData.currentUser!.email??"",
                Icons.email,
              ),
            ],
          )
        ],
      ),
    ),
  );
}

Widget makeListTile(context, String title, String subTitle, IconData trailing) {
  return Card(
    elevation: 2,
    shadowColor: Theme.of(context).accentColor,
    child: ListTile(
      //leading: Icon(Icons.arrow_back_ios),
      title: AutoSizeText(
        title,
        textDirection: TextDirection.rtl,
        overflow: TextOverflow.ellipsis,
        textScaleFactor: MediaQuery.of(context).textScaleFactor,
        minFontSize: 9,
        style: Theme.of(context).textTheme.bodyText1!.copyWith(
              color: Theme.of(context).primaryColor,
            ),
      ),
      subtitle: AutoSizeText(
        subTitle,
        textDirection: TextDirection.rtl,
        overflow: TextOverflow.ellipsis,
        textScaleFactor: MediaQuery.of(context).textScaleFactor,
        minFontSize: 9,
        style: Theme.of(context).textTheme.bodyText2!.copyWith(
              color: Theme.of(context).primaryColorLight,
              fontWeight: FontWeight.bold,
            ),
      ),
      trailing: Icon(
        trailing,
        color: Theme.of(context).accentColor,
      ),
    ),
  );
}
