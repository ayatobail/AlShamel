import 'dart:async';

import 'package:alshamel_new/models/user_notification.dart';
import 'package:alshamel_new/providers/auth.dart';
import 'package:alshamel_new/providers/notifications.dart';
import 'package:alshamel_new/screens/cars/cars_homepage_screen.dart';
import 'package:alshamel_new/screens/property/property_homepage_screen.dart';
import 'package:alshamel_new/screens/used_items/usedItems_homepage_screen.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class HomePage extends StatefulWidget {
  static String routName = '/home-page';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late FlutterLocalNotificationsPlugin fltrNotification;
  late Timer timer;
  List<UserNotification> _notifications = [];
  bool introViewed = false;

  void getNotfication() {
    if (Provider.of<Auth>(context, listen: false).isAuth) {
      Provider.of<Notifications>(context, listen: false)
          .getAllNotificationsByUsedID(
              Provider.of<Auth>(context, listen: false).ownerId!)
          .then((_) {
        setState(() {
          _notifications = Provider.of<Notifications>(context, listen: false)
              .unreadedNotifications;
          _showNotifications(_notifications);
        });
      });
    } else {
      Provider.of<Notifications>(context, listen: false)
          .getAllNotifications()
          .then((_) {
        setState(() {
          _notifications = Provider.of<Notifications>(context, listen: false)
              .notificationsForShow;
          _showNotifications(_notifications);
        });
      });
    }
  }

  Future _showNotifications(List<UserNotification> nots) async {
    var androidDetails = new AndroidNotificationDetails(
      "AL-Shamel ID",
      "AL-Shamel",
      "AL-Shamel ",
      playSound: true,
      importance: Importance.max,
    );
    var iSODetails = new IOSNotificationDetails();
    var generalNotificationDetails = new NotificationDetails(
      android: androidDetails,
      iOS: iSODetails,
    );
    nots.forEach((not) async {
      await fltrNotification.show(not.notificationsid!, not.title,
          not.body, generalNotificationDetails,
          payload: '${not.notificationsid},${not.title}');
    });
  }

  Future notificationSelected(String? payload) async {
    List<String> messageDetailes = payload!.split(',');
    await Provider.of<Notifications>(context, listen: false)
        .readNotification(notid:int.parse(messageDetailes[0]) )
        .then((_) => AwesomeDialog(
            context: context,
            dialogType: DialogType.INFO,
            animType: AnimType.RIGHSLIDE,
            customHeader: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset('assets/images/logo.png'),
            ),
            headerAnimationLoop: false,
            title: 'إشعار من الشامل',
            desc: messageDetailes[1],
            btnOkOnPress: () {},
            btnOkIcon: Icons.done,
            btnOkColor: Colors.green)
          ..show());
  }

  @override
  dispose() {
    timer?.cancel();
    fltrNotification.cancelAll();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    var androidInitilize = new AndroidInitializationSettings(
      '@mipmap/launcher_icon',
    );
    var iOSinitilize = new IOSInitializationSettings();
    var initilizationsSettings = new InitializationSettings(
      android: androidInitilize,
      iOS: iOSinitilize,

      // androidInitilize, iOSinitilize,
    );
    fltrNotification = new FlutterLocalNotificationsPlugin();
    fltrNotification.initialize(
      initilizationsSettings,
      onSelectNotification: notificationSelected,
    );

    //initPlatformState();

    getNotfication();
    timer =
        Timer.periodic(Duration(minutes: 60), (Timer t) => getNotfication());
  }

  void _goToSections(context, text) {
    switch (text) {
      case ('العقارات'):
        {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => PropertyHomePage()));
          break;
        }
      case ('السيارات'):
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => CarsHomePage()));
        break;
      case ('إعلانات عامة'):
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => UsedItemsHomePage()));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final topPadding = MediaQuery.of(context).padding.top;
    final bottomPading = MediaQuery.of(context).padding.bottom;
    final availableSpace = deviceHeight - topPadding - bottomPading;
    final deviceWidth = MediaQuery.of(context).size.width;

    Widget section(String title, String img, he) {
      return InkWell(
          onTap: () => _goToSections(context, title),
          child: Container(
            height: he * .24,
            color: Colors.white10,
            margin: const EdgeInsets.symmetric(
              vertical: 1.0,
            ),
            child: Stack(
              children: <Widget>[
                new Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(img),
                      colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.35),
                        BlendMode.luminosity,
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: SizedBox.expand(
                    child: Container(
                      alignment: Alignment.center,
                      child: AutoSizeText(
                        title,
                        overflow: TextOverflow.ellipsis,
                        textScaleFactor: MediaQuery.of(context).textScaleFactor,
                        minFontSize: 9,
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 24),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ));
    }

    List<Widget> it = [
      section(
        'العقارات',
        'assets/images/buildings.jpeg',
        availableSpace,
      ),
      section(
        'السيارات',
        'assets/images/cars.jpeg',
        availableSpace,
      ),
      section(
        'إعلانات عامة',
        'assets/images/usedItem.jpeg',
        availableSpace,
      ),
    ];
    Future<bool> showExitPopup(context) async {
      return await showDialog(
            //show confirm dialogue
            //the return value will be from "Yes" or "No" options
            context: context,
            builder: (BuildContext context) => AlertDialog(
              //title: Text('الخروج من التطبيق'),
              content: Text('هل تريد بالتأكيد الخروج من التطبيق؟'),
              actions: [
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text('لا'),
                ),
                ElevatedButton(
                  onPressed: () =>
                      {SystemNavigator.pop(), Navigator.of(context).pop(true)},
                  child: Text('نعم'),
                ),
              ],
            ),
          ) ??
          false; //if showDialouge had returned null, then return false
    }

    return WillPopScope(
      onWillPop: () => showExitPopup(context),
      child: Scaffold(
        body: Container(
          margin: EdgeInsets.only(top: topPadding, bottom: bottomPading),
          height: availableSpace,
          width: deviceWidth,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: availableSpace * .05,
                ),
                Container(
                  child: Image.asset(
                    'assets/images/logo.png',
                    color: Theme.of(context).primaryColor,
                    fit: BoxFit.cover,
                  ),
                  alignment: Alignment.center,
                  width: (deviceWidth * .6),
                  height: (availableSpace * .15),
                ),
                Expanded(
                  child: Container(
                    child: ListView.builder(
                      itemCount: it.length,
                      itemBuilder: (ctx, index) =>
                          AnimationConfiguration.staggeredList(
                        position: index,
                        duration: Duration(seconds: 2),
                        child: ScaleAnimation(
                          child: FadeInAnimation(
                            child: it[index],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}
