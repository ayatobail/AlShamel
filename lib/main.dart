import 'dart:io';

import 'package:alshamel_new/helper/location_update.dart';
import 'package:alshamel_new/home_page.dart';
import 'package:alshamel_new/onBoardScreen.dart';
import 'package:alshamel_new/providers/auth.dart';
import 'package:alshamel_new/providers/car_providers/car_item.dart';
import 'package:alshamel_new/providers/car_providers/car_manufacture.dart';
import 'package:alshamel_new/providers/car_providers/car_models.dart';
import 'package:alshamel_new/providers/car_providers/car_operation_type.dart';
import 'package:alshamel_new/providers/car_providers/car_type.dart';
import 'package:alshamel_new/providers/car_providers/car_type_details.dart';
import 'package:alshamel_new/providers/car_providers/cars.dart';
import 'package:alshamel_new/providers/messages.dart';
import 'package:alshamel_new/providers/notifications.dart';
import 'package:alshamel_new/providers/owner.dart';
import 'package:alshamel_new/providers/property_providers/favorites.dart';
import 'package:alshamel_new/providers/property_providers/operation.dart';
import 'package:alshamel_new/providers/property_providers/property.dart';
import 'package:alshamel_new/providers/property_providers/property_item.dart';
import 'package:alshamel_new/providers/property_providers/property_registration_type.dart';
import 'package:alshamel_new/providers/property_providers/type_details.dart';
import 'package:alshamel_new/providers/used_items_providers/used_item.dart';
import 'package:alshamel_new/providers/used_items_providers/used_item_type.dart';
import 'package:alshamel_new/providers/used_items_providers/used_items.dart';
import 'package:alshamel_new/screens/cars/car_review_screen.dart';
import 'package:alshamel_new/screens/cars/cars_homepage_screen.dart';
import 'package:alshamel_new/screens/cars/cars_main_screen.dart';
import 'package:alshamel_new/screens/profile/about_us.dart';
import 'package:alshamel_new/screens/profile/change_password.dart';
import 'package:alshamel_new/screens/profile/main_profile.dart';
import 'package:alshamel_new/screens/profile/my_cars.dart';
import 'package:alshamel_new/screens/profile/my_property.dart';
import 'package:alshamel_new/screens/profile/my_usedItems.dart';
import 'package:alshamel_new/screens/profile/personal_info.dart';
import 'package:alshamel_new/screens/profile/send_message.dart';
import 'package:alshamel_new/screens/property/property_details_screen.dart';
import 'package:alshamel_new/screens/property/property_homepage_screen.dart';
import 'package:alshamel_new/screens/property/splash_screen.dart';
import 'package:alshamel_new/screens/used_items/usedItem_review_screen.dart';
import 'package:alshamel_new/screens/used_items/usedItems_homepage_screen.dart';
import 'package:alshamel_new/screens/used_items/usedItems_main_screen.dart';
import 'package:alshamel_new/widgets/property_widgets/property_review.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:alshamel_new/providers/property_providers/city.dart';
import 'package:alshamel_new/providers/property_providers/type.dart';
import 'package:shared_preferences/shared_preferences.dart';

int? introViewed;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey("onBoard")) {
    introViewed = prefs.getInt("onBoard");
  } else {
    introViewed = 0;
  }
  HttpOverrides.global = MyHttpOverrides();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Color.fromRGBO(23, 49, 67, 1);
    Color secondColor = Color.fromRGBO(32, 217, 148, 1);
    Color supportColor = Color.fromRGBO(157, 157, 157, 1);
    Color lightColor = Color.fromRGBO(237, 250, 250, 1);
    Color warningColor = Color.fromRGBO(241, 111, 111, 1);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Auth()),
        ChangeNotifierProvider.value(value: City()),
        ChangeNotifierProvider.value(value: Type()),
        ChangeNotifierProvider.value(value: Operation()),
        ChangeNotifierProvider.value(value: PropertyItem()),
        ChangeNotifierProvider.value(value: Property()),
        ChangeNotifierProvider.value(value: TypeDetails()),
        ChangeNotifierProvider.value(value: PropertyRegistrationType()),
        ChangeNotifierProvider.value(value: Cars()),
        ChangeNotifierProvider.value(value: CarItem()),
        ChangeNotifierProvider.value(value: CarType()),
        ChangeNotifierProvider.value(value: CarManufacture()),
        ChangeNotifierProvider.value(value: CarOperationType()),
        ChangeNotifierProvider.value(value: CarTypeDetails()),
        ChangeNotifierProvider.value(value: CarModels()),
        ChangeNotifierProvider.value(value: Owner()),
        ChangeNotifierProvider.value(value: Favorites()),
        ChangeNotifierProvider.value(value: UsedItem()),
        ChangeNotifierProvider.value(value: UsedItems()),
        ChangeNotifierProvider.value(value: UsedItemType()),
        ChangeNotifierProvider.value(value: Notifications()),
        ChangeNotifierProvider.value(value: Messages()),
        ChangeNotifierProvider.value(value: LocationUpdate())
        // ChangeNotifierProxyProvider<Auth, Favorites>(
        //   create: (_) => Favorites(),
        //   update: (_, auth, previousFavo) {
        //     previousFavo.authUserId = auth.ownerId;
        //     return previousFavo;
        //   },
        // ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          theme: ThemeData(
            primaryColor: primaryColor,
            primaryColorLight: supportColor,
            accentColor: secondColor,
            errorColor: warningColor,
            backgroundColor: lightColor,
            bottomAppBarColor: Colors.white,
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.white,
              textTheme: TextTheme(
                bodyText1: TextStyle(
                  fontFamily: 'Helvetica-Neue-LT-Arabic-55-Roman',
                  fontSize: 12 * MediaQuery.textScaleFactorOf(context),
                ),
              ),
            ),
            textTheme: TextTheme(
              bodyText1: TextStyle(
                fontFamily: 'Helvetica-Neue-LT-Arabic-55-Roman',
                fontSize: 16 * MediaQuery.textScaleFactorOf(context),
                color: primaryColor,
              ),
              bodyText2: TextStyle(
                fontFamily: 'Helvetica-Neue-LT-Arabic-55-Roman',
                fontSize: 14 * MediaQuery.textScaleFactorOf(context),
                color: primaryColor,
              ),
            ),
          ),
          debugShowCheckedModeBanner: false,
          title: 'Shamel',
          home: auth.isAuth
              ? HomePage()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : HomePage(),
                ),
          initialRoute:
              introViewed == 0 ? OnBoardingScreen.routeName : HomePage.routName,
          routes: {
            HomePage.routName: (ctx) => HomePage(),
            ChangePasswordScreen.routeName: (ctx) => ChangePasswordScreen(),
            SendMessageScreen.routeName: (ctx) => SendMessageScreen(),
            MainProfileScreen.routeName: (ctx) => MainProfileScreen(),
            OnBoardingScreen.routeName: (ctx) => OnBoardingScreen(),
            PropertyHomePage.routeName: (ctx) => PropertyHomePage(),
            PropertyReviewScreen.routeName: (ctx) => PropertyReviewScreen(),
            PropertyDetailsScreen.routeName: (ctx) => PropertyDetailsScreen(),
            CarReviewScreen.routeName: (ctx) => CarReviewScreen(),
            PersonalInfoScreen.routeName: (ctx) => PersonalInfoScreen(),
            MyPropertyScreen.routeName: (cx) => MyPropertyScreen(),
            MyCarsScreen.routeName: (ctx) => MyCarsScreen(),
            AboutUsScreen.routName: (ctx) => AboutUsScreen(),
            CarsHomePage.routeName: (ctx) => CarsHomePage(),
            UsedItemsHomePage.routeName: (ctx) => UsedItemsHomePage(),
            UsedItemsMainScreen.routeName: (ctx) => UsedItemsMainScreen(),
            UsedItemReviewScreen.routeName: (ctx) => UsedItemReviewScreen(),
            MyUsedItemsScreen.routeName: (ctx) => MyUsedItemsScreen(),
            CarsMainScreen.routeName: (ctx) => CarsMainScreen()
          },
        ),
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}