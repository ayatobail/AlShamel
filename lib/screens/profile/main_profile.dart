import 'dart:io';

import 'package:alshamel_new/home_page.dart';
import 'package:alshamel_new/providers/auth.dart';
import 'package:alshamel_new/providers/owner.dart';
import 'package:alshamel_new/screens/login/personal_img_screen.dart';
import 'package:alshamel_new/screens/profile/about_us.dart';
import 'package:alshamel_new/screens/profile/change_password.dart';
import 'package:alshamel_new/screens/profile/my_cars.dart';
import 'package:alshamel_new/screens/profile/my_property.dart';
import 'package:alshamel_new/screens/profile/my_usedItems.dart';
import 'package:alshamel_new/screens/profile/personal_info.dart';
import 'package:alshamel_new/screens/profile/send_message.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:file_picker/file_picker.dart';

class MainProfileScreen extends StatefulWidget {
  static const routeName = '/Profile';

  @override
  _MainProfileScreenState createState() => _MainProfileScreenState();
}

class _MainProfileScreenState extends State<MainProfileScreen> {
  late SharedPreferences prefs;
  late FilePickerResult result;
  void setImageFromSelection() {
    setState(() {
      // result = r;
    });
  }

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
  }

  void showAlertDialog(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text("تأكيد تسجيل الخروج؟"),
            actions: [
              TextButton(
                child: Text("إلغاء"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text("متابعة"),
                onPressed: () {
                  Provider.of<Auth>(context, listen: false).logout();
                  Navigator.pop(context, true);
                  Navigator.of(context).pushReplacementNamed(HomePage.routName);
                },
              )
            ],
          );
        });
  }

  Widget _buildHeader(context, height, Owner ownerData) {
    return Stack(
      children: <Widget>[
        Ink(
          height: height * .3,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
          ),
        ),
        InkWell(
          onTap: () => {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PersonalImageScreen(
                          updateImage: setImageFromSelection,
                        ))),
          },
          child: Container(
            width: double.infinity,
            margin: EdgeInsets.only(top: height * .22),
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
                      child: prefs.containsKey('personalImage') &&
                              prefs.getString('personalImage') != ''
                          ? Image(
                              fit: BoxFit.cover,
                              image: FileImage(
                                File(prefs.getString('personalImage')!),
                              ))
                          : Icon(
                              Icons.person,
                              size: 70,
                              color: Theme.of(context).accentColor,
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _buildMainInfo(context, Owner ownerData) {
    return Container(
      margin: const EdgeInsets.all(8),
      alignment: AlignmentDirectional.center,
      child: Column(
        children: <Widget>[
          AutoSizeText(
            '${ownerData.currentUser!.firstname} ${ownerData.currentUser!.lastname??""}' ,
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
                  'الملف الشخصي',
                  Icons.person,
                  () => Navigator.of(context).pushNamed(
                    PersonalInfoScreen.routeName,
                  ),
                ),
                makeListTile(
                  context,
                  'عقاراتي',
                  Icons.home_filled,
                  () => Navigator.of(context).pushNamed(
                    MyPropertyScreen.routeName,
                  ),
                ),
                makeListTile(
                  context,
                  'سياراتي',
                  Icons.car_repair,
                  () => Navigator.of(context).pushNamed(
                    MyCarsScreen.routeName,
                  ),
                ),
                makeListTile(
                  context,
                  'أدواتي المستعملة',
                  Icons.shopping_bag_sharp,
                  () => Navigator.of(context).pushNamed(
                    MyUsedItemsScreen.routeName,
                  ),
                ),
                makeListTile(
                  context,
                  'تواصل معنا',
                  Icons.messenger_sharp,
                  () => Navigator.of(context).pushNamed(
                    AboutUsScreen.routName,
                  ),
                ),
                makeListTile(
                  context,
                  'إرسال رسالة إلى الإدارة',
                  Icons.message,
                  () => Navigator.pushNamed(
                    context,
                    SendMessageScreen.routeName,
                  ),
                ),
                makeListTile(
                  context,
                  'تغيير كلمة السر',
                  Icons.lock_outline,
                  () => Navigator.of(context).pushNamed(
                    ChangePasswordScreen.routeName,
                  ),
                ),
                makeListTile(
                  context,
                  'تسجيل الخروج',
                  Icons.settings_power,
                  () => showAlertDialog(context),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget makeListTile(context, String title, IconData trailing, ontap) {
    return InkWell(
      onTap: ontap,
      child: Card(
        //color: Theme.of(context).backgroundColor,
        elevation: 2,
        shadowColor: Theme.of(context).accentColor,
        child: ListTile(
          leading: Icon(Icons.arrow_back_ios),
          title: AutoSizeText(
            title,
            textDirection: TextDirection.rtl,
            overflow: TextOverflow.ellipsis,
            textScaleFactor: MediaQuery.of(context).textScaleFactor,
            minFontSize: 9,
            style: Theme.of(context).textTheme.bodyText2!.copyWith(
                  color: Theme.of(context).primaryColor,
                  //fontWeight: FontWeight.bold,
                ),
          ),
          trailing: Icon(
            trailing,
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final ownerData = Provider.of<Owner>(context, listen: false);
    final ownerid = Provider.of<Auth>(context, listen: false).ownerId;
    return FutureBuilder(
      future: Future.wait([
        Provider.of<Owner>(context, listen: false).getOwnerInfo(ownerid!),
      ])
        ..catchError((Object e, StackTrace stackTrace) {},
            test: (e) => e is HttpException),
      builder: (BuildContext ctx, AsyncSnapshot snapshotData) {
        if (snapshotData.hasError) {
          return Container(
            child: Center(
              child: Text('تحقق من وجود الانترنت'),
            ),
          );
        } else if (snapshotData.connectionState == ConnectionState.waiting) {
          return const Center(
            child: const CircularProgressIndicator(),
          );
        } else {
          return Container(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  _buildHeader(context, height, ownerData),
                  SizedBox(height: 10.0),
                  _buildMainInfo(context, ownerData),
                  _buildInfo(context, ownerData),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
