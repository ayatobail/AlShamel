import 'package:alshamel_new/home_page.dart';
import 'package:alshamel_new/providers/auth.dart';
import 'package:alshamel_new/screens/cars/cars_addNew_screen.dart';
import 'package:alshamel_new/screens/cars/cars_favorites_screen.dart';
import 'package:alshamel_new/screens/cars/cars_filters_screen.dart';
import 'package:alshamel_new/screens/cars/cars_main_screen.dart';
import 'package:alshamel_new/screens/login/login_screen.dart';
import 'package:alshamel_new/screens/messaging_screen.dart';
import 'package:alshamel_new/screens/notification_screen.dart';
import 'package:alshamel_new/widgets/cars_widgets/search_bar_helper/the_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class CarsHomePage extends StatefulWidget {
  static const routeName = 'cars-home-page';
  @override
  _CarsHomePageState createState() => _CarsHomePageState();
}

class _CarsHomePageState extends State<CarsHomePage> {
  int _navigation = 0;
  List<Map<String, dynamic>> _pages = [
    {'page': CarsMainScreen()},
    {'page': CarsFavoritesScreen()},
    {'page': null},
    {'page': NotificationScreen()},
    {'page': null},
  ];
  void _goToLoginPage() {
    Navigator.pop(context, true);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  void _goToAddNewCar() => Navigator.push(
      context, MaterialPageRoute(builder: (context) => CarsAddNewScreen()));

  void _goToFiltersScreen() => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CarsFiltersScreen()),
      );

  void _goToMessagingScreen(ctx) => Navigator.push(
      ctx, MaterialPageRoute(builder: (ctx) => MessagingScreen()));

  void _goToHomePage(ctx) =>
      Navigator.push(ctx, MaterialPageRoute(builder: (ctx) => HomePage()));

  void _showDialog(String message) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.WARNING,
      animType: AnimType.TOPSLIDE,
      customHeader: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(
          Icons.notifications,
          color: Theme.of(context).primaryColorLight,
        ),
      ),
      desc: message,
      btnOkOnPress: () => _goToLoginPage(),
      btnOkColor: Theme.of(context).accentColor,
    ).show();
  }

  void _selectPage(int index) {
    setState(() {
      if (index == 0) {
        _navigation = 0;
      } else if (index == 1) {
        _navigation = 1;
        if (!Provider.of<Auth>(context, listen: false).isAuth) {
          _showDialog('عليك تسجيل الدخول أولاً');
        }
      } else if (index == 2) {
        Provider.of<Auth>(context, listen: false).isAuth
            ? _goToAddNewCar()
            : _showDialog('عليك تسجيل الدخول أولاً');
      } else if (index == 3) {
        _navigation = 3;
      } else if (index == 4) {
        _goToLoginPage();
      }
    });
  }

  Future<void> _showSearch() async {
    await showSearch(
      context: context,
      delegate: TheSearch(),
      query: "",
    );
  }

  @override
  Widget build(BuildContext context) {
    var appBar2 = AppBar(
      elevation: 8.0,
      title: TextButton.icon(
        label: Text(
          "ابحث عن مركبة",
          style: TextStyle(color: Theme.of(context).primaryColorLight),
        ),
        icon: Icon(
          Icons.search,
          color: Theme.of(context).primaryColorLight,
        ),
        onPressed: _showSearch,
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: IconButton(
            onPressed: () => _goToHomePage(context),
            icon: Icon(
              Icons.arrow_forward,
              color: Theme.of(context).accentColor,
            ),
          ),
        )
      ],
      leading: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () => _goToFiltersScreen(),
            icon: Icon(
              Icons.saved_search,
              color: Theme.of(context).accentColor,
            ),
          ),
          IconButton(
            onPressed: () => _goToMessagingScreen(context),
            icon: Icon(
              Icons.message_outlined,
              color: Theme.of(context).accentColor,
            ),
          ),
        ],
      ),
      leadingWidth: 100,
    );

    var makeBottomBar = Container(
      //height: containerHeight * .1,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30),
          topLeft: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
              color: Theme.of(context).primaryColorLight,
              spreadRadius: 0,
              blurRadius: 7),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          iconSize: 25,
          unselectedItemColor: Theme.of(context).primaryColorLight,
          selectedItemColor: Theme.of(context).accentColor,
          currentIndex: _navigation,
          onTap: _selectPage,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'الرئيسية',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border),
              label: 'المفضلة',
            ),
            BottomNavigationBarItem(
              label: '',
              icon: Icon(
                Icons.add_circle,
                size: 35,
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications_active_outlined),
              label: 'الاشعارات',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'حسابي',
            ),
          ],

          // to mark the tab we selected as an active tab and knowing who was selected
        ),
      ),
    );

    return Scaffold(
      appBar: _navigation == 1 ? null : appBar2,
      bottomNavigationBar: makeBottomBar,
      body: _pages[_navigation]['page'],
    );
  }
}
