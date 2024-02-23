import 'dart:io';

import 'package:alshamel_new/helper/http_exception.dart';
import 'package:alshamel_new/home_page.dart';
import 'package:alshamel_new/providers/auth.dart';
import 'package:alshamel_new/providers/property_providers/city.dart';
import 'package:alshamel_new/providers/property_providers/favorites.dart';
import 'package:alshamel_new/providers/property_providers/operation.dart';
import 'package:alshamel_new/providers/property_providers/property.dart';
import 'package:alshamel_new/providers/property_providers/property_registration_type.dart';
import 'package:alshamel_new/providers/property_providers/type.dart';
import 'package:alshamel_new/screens/login/login_screen.dart';
import 'package:alshamel_new/screens/messaging_screen.dart';
import 'package:alshamel_new/screens/property/property_addNew_screen.dart';
import 'package:alshamel_new/screens/property/property_favorites_screen.dart';
import 'package:alshamel_new/screens/property/property_filters_screen.dart';
import 'package:alshamel_new/screens/property/property_lists_screen.dart';
import 'package:alshamel_new/screens/notification_screen.dart';
import 'package:alshamel_new/widgets/property_widgets/property_filtters_bar.dart';
import 'package:alshamel_new/widgets/property_widgets/search_bar_helper/the_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:alshamel_new/widgets/property_widgets/map_widget.dart';
import 'package:provider/provider.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class PropertyHomePage extends StatefulWidget {
  static const routeName = 'property-home-page';
  @override
  _PropertyHomePageState createState() => _PropertyHomePageState();
}

class _PropertyHomePageState extends State<PropertyHomePage> {
  int _navigation = 0;
  int _propertyListIndex = 0;
  bool _isLoading = false;
  List<Map<String, dynamic>> _pages = [
    {'page': GoogleMapWidget()},
    {'page': PropertyFavoritesScreen()},
    {'page': null},
    {'page': NotificationScreen()},
    {'page': null},
  ];

  void _showErrorDialog(String title, String message, onPressed) {
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
      title: title,
      desc: message,
      btnOkOnPress: onPressed,
      btnOkColor: Theme.of(context).accentColor,
    ).show();
  }

  @override
  void dispose() {
    Provider.of<Property>(context, listen: false).clearFilters();
    super.dispose();
  }

  @override
  void initState() {
    setState(
      () {
        _isLoading = true;
      },
    );
    print('*************');

    Future.wait([
      Provider.of<City>(context, listen: false).getAllCities(),
      Provider.of<Operation>(context, listen: false).getAllOperations(),
      Provider.of<Type>(context, listen: false).getAllTypes(),
      Provider.of<PropertyRegistrationType>(context, listen: false)
          .getAllRegistrationType(),
      Provider.of<Property>(context, listen: false).getAllProperty(),
     if (Provider.of<Auth>(context, listen: false).isAuth)
        Provider.of<Favorites>(context, listen: false).getAllFavoriteProperty(
            Provider.of<Auth>(context, listen: false).ownerId!)
    ])
        .then(
      (_) => setState(
        () {
          _isLoading = false;
        },
      ),
    )
        .catchError((Object e, StackTrace stackTrace) {
      _showErrorDialog(
        'حدث خطأ',
        e.toString(),
        () {},
      );
    }, test: (e) => e is HttpException).whenComplete(() => setState(
              () {
                _isLoading = false;
              },
            ));
    super.initState();
  }

  void _goToAddNewProperty() => Navigator.push(
      context, MaterialPageRoute(builder: (context) => PropertyAddNewScreen()));

  void _goToFiltersScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PropertyFiltersScreen()),
    );
  }

  void _goToLoginPage() {
    Navigator.pop(context, true);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  void _goToHomePage(ctx) =>
      Navigator.push(ctx, MaterialPageRoute(builder: (ctx) => HomePage()));

  void _goToMessagingScreen(ctx) => Navigator.push(
      ctx, MaterialPageRoute(builder: (ctx) => MessagingScreen()));

  void _goToListItemsProperty() => setState(() {
        _propertyListIndex = 1;
      });

  void _selectPage(int index) {
    setState(() {
      _propertyListIndex = 0;
      if (index == 0) {
        _navigation = 0;
      } else if (index == 1) {
        _navigation = 1;
        if (!Provider.of<Auth>(context, listen: false).isAuth) {
          _showErrorDialog('', 'عليك تسجيل الدخول أولاً', () {
            //Navigator.of(context).pop();
            _goToLoginPage();
          });
        }
      } else if (index == 2) {
        if (Provider.of<Auth>(context, listen: false).isAuth) {
          _goToAddNewProperty();
        } else {
          _showErrorDialog('', 'عليك تسجيل الدخول أولاً', () {
            //Navigator.of(context).pop();
            _goToLoginPage();
          });
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
    Provider.of<Property>(context);
    var appBar2 = AppBar(
      elevation: 8.0,
      title: TextButton.icon(
        label: Text(
          "ابحث عن العقار",
          style: TextStyle(color: Theme.of(context).primaryColorLight),
        ),
        icon: Icon(
          Icons.search,
          color: Theme.of(context).primaryColorLight,
        ),
        //color: Theme.of(context).primaryColorLight,
        onPressed: _showSearch,
      ),
      actions: [
        IconButton(
          onPressed: () => _goToListItemsProperty(),
          icon: Icon(
            Icons.list_outlined,
            color: Theme.of(context).accentColor,
          ),
        ),
        IconButton(
          onPressed: () => _goToHomePage(context),
          icon: Icon(
            Icons.arrow_forward,
            color: Theme.of(context).accentColor,
          ),
        ),
      ],
      leading: FittedBox(
        child: Row(
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
      ),
      leadingWidth: 100,
    );

    final deviceHeight = MediaQuery.of(context).size.height;
    final topPadding = MediaQuery.of(context).padding.top;
    final bottomPading = MediaQuery.of(context).padding.bottom;
    final availableSpace = deviceHeight - topPadding - bottomPading;
    final containerHeight = availableSpace - appBar2.preferredSize.height;
    final bodysection1 = (containerHeight) * .06;
    final bodysection2 = (containerHeight) * .94;

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
          ? Center(
              child: CircularProgressIndicator(),
            )
          : (_navigation == 0 || _propertyListIndex == 1)
              ? Container(
                  child: Column(
                    children: [
                      Container(
                        height: bodysection1,
                        margin: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: PropertyFiltersBar(),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: _propertyListIndex == 1
                            ? _pages[0]['page']
                            : PropertyListsScreen(bodysection2),
                      )
                    ],
                  ),
                )
              : _pages[_navigation]['page'],
    );
  }
}
