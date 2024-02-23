import 'package:alshamel_new/helper/http_exception.dart';
import 'package:alshamel_new/home_page.dart';
import 'package:alshamel_new/providers/auth.dart';
import 'package:alshamel_new/providers/property_providers/city.dart';
import 'package:alshamel_new/providers/used_items_providers/used_item_type.dart';
import 'package:alshamel_new/providers/used_items_providers/used_items.dart';
import 'package:alshamel_new/screens/login/login_screen.dart';
import 'package:alshamel_new/screens/messaging_screen.dart';
import 'package:alshamel_new/screens/notification_screen.dart';
import 'package:alshamel_new/screens/used_items/usedItem_addNew_screen.dart';
import 'package:alshamel_new/screens/used_items/usedItem_favorites_screen.dart';
import 'package:alshamel_new/screens/used_items/usedItem_filters_screen.dart';
import 'package:alshamel_new/screens/used_items/usedItems_main_screen.dart';
import 'package:alshamel_new/widgets/used_items_widgets/search_bar_helper/the_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class UsedItemsHomePage extends StatefulWidget {
  static const routeName = '/usedItem-home-page';
  @override
  _UsedItemsHomePageState createState() => _UsedItemsHomePageState();
}

class _UsedItemsHomePageState extends State<UsedItemsHomePage> {
  bool _isLoading = false;

  void _showErrorDialog2(
    String title,
    String message,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    setState(
      () {
        _isLoading = true;
      },
    );
    Future.wait([
      Provider.of<City>(context, listen: false).getAllCities(),
      Provider.of<UsedItems>(context, listen: false).getAllUsedItems(),
      Provider.of<UsedItemType>(context, listen: false).getAllTypes(),
    ])
        .then(
      (_) => setState(
        () {
          _isLoading = false;
        },
      ),
    )
        .catchError(
      (Object e, StackTrace stackTrace) {
        _showErrorDialog2(
          'حدث خطأ',
          e.toString(),
        );
      },
      test: (e) => e is HttpException,
    );
    super.initState();
  }

  int _navigation = 0;
  List<Map<String, dynamic>> _pages = [
    {'page': UsedItemsMainScreen()},
    {'page': UsedItemsFavoritesScreen()},
    {'page': null},
    {'page': NotificationScreen()},
    {'page': null},
  ];
  void _goToHomePage(ctx) =>
      Navigator.push(ctx, MaterialPageRoute(builder: (ctx) => HomePage()));

  void _goToAddNewUsedItem() => Navigator.push(context,
      MaterialPageRoute(builder: (context) => UsedItemsAddNewScreen()));

  void _goToFiltersScreen() => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => UsedItemsFiltersScreen()),
      );

  void _goToMessagingScreen(ctx) => Navigator.push(
      ctx, MaterialPageRoute(builder: (ctx) => MessagingScreen()));

  void _goToLoginPage() {
    Navigator.pop(context, true);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  void _showErrorDialog(
    String message,
  ) {
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
      btnOkOnPress: () {
        _goToLoginPage();
      },
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
          _showErrorDialog('عليك تسجيل الدخول أولاً');
        }
      } else if (index == 2) {
        if (Provider.of<Auth>(context, listen: false).isAuth) {
          _goToAddNewUsedItem();
        } else {
          _showErrorDialog('عليك تسجيل الدخول أولاً');
        }
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
          "ابحث عن ..",
          style: TextStyle(color: Theme.of(context).primaryColorLight),
        ),
        icon: Icon(
          Icons.search,
          color: Theme.of(context).primaryColorLight,
        ),
        onPressed: _showSearch,
      ),
      actions: [
        IconButton(
          onPressed: () => _goToHomePage(context),
          icon: Icon(
            Icons.arrow_forward,
            color: Theme.of(context).accentColor,
          ),
        ),
      ],
      leading: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: _goToFiltersScreen,
            icon: Icon(
              (Icons.saved_search),
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
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _pages[_navigation]['page'],
    );
  }
}
