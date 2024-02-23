import 'dart:io';

import 'package:alshamel_new/helper/http_exception.dart';
import 'package:alshamel_new/providers/auth.dart';
import 'package:alshamel_new/providers/car_providers/car_item.dart';
import 'package:alshamel_new/providers/car_providers/car_manufacture.dart';
import 'package:alshamel_new/providers/car_providers/car_operation_type.dart';
import 'package:alshamel_new/providers/car_providers/car_type.dart';
import 'package:alshamel_new/providers/car_providers/cars.dart';
import 'package:alshamel_new/providers/property_providers/city.dart';
import 'package:alshamel_new/providers/property_providers/favorites.dart';
import 'package:alshamel_new/widgets/cars_widgets/car_filtered_items.dart';
import 'package:alshamel_new/widgets/cars_widgets/cars_filters_bar.dart';
import 'package:alshamel_new/widgets/cars_widgets/cars_lists_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CarsMainScreen extends StatefulWidget {
  static const routeName = '/cars-main';
  @override
  _CarsMainScreenState createState() => _CarsMainScreenState();
}

class _CarsMainScreenState extends State<CarsMainScreen> {
  void _showErrorDialog(String title, String message, onPressed) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: onPressed,
            child: Text('OK'),
          )
        ],
      ),
    );
  }

  bool isloading = false;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    setState(() {
      isloading = true;
    });
    final owner = Provider.of<Auth>(context, listen: false).ownerId;

    Future.wait([
      Provider.of<City>(context, listen: false).getAllCities(),
      Provider.of<Cars>(
        context,
        listen: false,
      ).getAllCars(),
      Provider.of<CarManufacture>(context, listen: false).getAllManufactures(),
      Provider.of<CarType>(context, listen: false).getAllCarTypes(),
      if (Provider.of<Auth>(context, listen: false).isAuth)
        Provider.of<Favorites>(context, listen: false)
            .getAllFavoriteCars(owner!),
      Provider.of<CarManufacture>(context, listen: false).getAllManufactures(),
      Provider.of<CarType>(context, listen: false).getAllCarTypes(),
      Provider.of<CarOperationType>(context, listen: false)
          .getAllCarOperationTypes(),
    ])
        .then((_) => setState(() {
              isloading = false;
            }))
        .catchError(
      (Object e, StackTrace stackTrace) {
        _showErrorDialog(
          'حدث خطأ',
          e.toString(),
          () {
            Navigator.of(context).pop();
          },
        );
      },
      test: (e) => e is HttpException,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final carsData = Provider.of<Cars>(context);
    List<CarItem> _filteredData = carsData.filtereditems;

    final deviceHeight = MediaQuery.of(context).size.height;
    final topPadding = MediaQuery.of(context).padding.top;
    final bottomPading = MediaQuery.of(context).padding.bottom;
    final availableSpace = deviceHeight - topPadding - bottomPading;
    final containerHeight = availableSpace - AppBar().preferredSize.height;
    final bodysection1 = (containerHeight) * .06;
    final bodysection2 = (containerHeight) * .94;
    return Container(
      margin: EdgeInsets.only(top: topPadding, bottom: bottomPading),
      child: Column(children: [
        Container(
          height: bodysection1,
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: CarsFiltersBar(),
              ),
            ],
          ),
        ),
        Expanded(
          child: _filteredData.isEmpty
              ? isloading
                  ? Center(child: CircularProgressIndicator())
                  : CarsListsScreen(
                      containerHeight: bodysection2,
                    )
              : CarFilteredItems(height: bodysection2),
        )
      ]),
    );
  }
}
