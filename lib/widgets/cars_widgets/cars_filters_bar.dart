import 'package:alshamel_new/providers/car_providers/car_manufacture.dart';
import 'package:alshamel_new/providers/car_providers/car_operation_type.dart';
import 'package:alshamel_new/providers/car_providers/car_type.dart';
import 'package:alshamel_new/providers/car_providers/cars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:alshamel_new/providers/property_providers/city.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class CarsFiltersBar extends StatefulWidget {
  @override
  _CarsFiltersBarState createState() => _CarsFiltersBarState();
}

class _CarsFiltersBarState extends State<CarsFiltersBar> {
  City? _selectedCity;
  CarType? _selectedType;
  CarManufacture? _selectedManufacture;
  CarOperationType? _selectedOperation;
  int? _selectedYear;
  bool isLoading = false;
  void _showErrorDialog(String message) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.INFO,
      animType: AnimType.BOTTOMSLIDE,
      customHeader: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(
          Icons.notifications,
          color: Theme.of(context).primaryColorLight,
        ),
      ),
      desc: message,
      btnOkOnPress: () {},
      btnOkColor: Theme.of(context).accentColor,
    ).show();
  }

  List<int> getYearsInBeteween() {
    List<int> years = [];
    for (int i = 1960; i <= DateTime.now().year; i++) {
      years.add(i);
    }
    return years;
  }

  Widget dropDownCityButton(City cityData) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<City>(
        //isExpanded: true,
        iconEnabledColor: Theme.of(context).accentColor,
        hint: AutoSizeText(
          'المحافظة',
          overflow: TextOverflow.ellipsis,
          textScaleFactor: MediaQuery.of(context).textScaleFactor,
          minFontSize: 9,
          style: Theme.of(context)
              .textTheme
              .bodyText2!
              .copyWith(color: Colors.white),
        ),
        iconSize: 25,
        elevation: 8,
        dropdownColor: Theme.of(context).primaryColorLight,
        value: _selectedCity,
        onChanged: (City? newvalue) async {
          setState(() {
            _selectedCity = newvalue;
            bool result = Provider.of<Cars>(context, listen: false).setFilters(
              city: _selectedCity != null ? _selectedCity!.cityId : null,
              type: _selectedType != null ? _selectedType!.typeid : null,
              manufacture: _selectedManufacture != null
                  ? _selectedManufacture!.companyname
                  : null,
              operationtype: _selectedOperation != null
                  ? _selectedOperation!.operationid
                  : null,
              year: _selectedYear,
            );
            if (!result) {
              _showErrorDialog('لا يوجد نتائج');
            }
          });
        },
        items: cityData.cities.map<DropdownMenuItem<City>>((city) {
          return DropdownMenuItem<City>(
            value: city,
            child: AutoSizeText(
              city.cityName??"",
              overflow: TextOverflow.ellipsis,
              textScaleFactor: MediaQuery.of(context).textScaleFactor,
              minFontSize: 9,
              style: Theme.of(context)
                  .textTheme
                  .bodyText2!
                  .copyWith(color: Colors.white),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget dropDownCarTypeButton(CarType carTypeData) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<CarType>(
        iconEnabledColor: Theme.of(context).accentColor,
        hint: AutoSizeText(
          'نوع المركبة',
          overflow: TextOverflow.ellipsis,
          textScaleFactor: MediaQuery.of(context).textScaleFactor,
          minFontSize: 9,
          style: Theme.of(context)
              .textTheme
              .bodyText2!
              .copyWith(color: Colors.white),
        ),
        iconSize: 25,
        elevation: 8,
        dropdownColor: Theme.of(context).primaryColorLight,
        value: _selectedType,
        onChanged: (CarType? newvalue) async {
          setState(() {
            _selectedType = newvalue;
            bool result = Provider.of<Cars>(context, listen: false).setFilters(
                city: _selectedCity != null ? _selectedCity!.cityId : null,
                type: _selectedType != null ? _selectedType!.typeid : null,
                manufacture: _selectedManufacture != null
                    ? _selectedManufacture!.companyname
                    : null,
                operationtype: _selectedOperation != null
                    ? _selectedOperation!.operationid
                    : null,
                year: _selectedYear);
            if (!result) {
              _showErrorDialog('لا يوجد نتائج');
            }
          });
        },
        items: carTypeData.carTypes.map<DropdownMenuItem<CarType>>((cartype) {
          return DropdownMenuItem<CarType>(
            value: cartype,
            child: AutoSizeText(
              cartype.typename??"",
              overflow: TextOverflow.ellipsis,
              textScaleFactor: MediaQuery.of(context).textScaleFactor,
              minFontSize: 9,
              style: Theme.of(context)
                  .textTheme
                  .bodyText2!
                  .copyWith(color: Colors.white),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget dropDownCarManufactureButton(CarManufacture manufacturesData) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<CarManufacture>(
        //isExpanded: true,
        iconSize: 25,
        iconEnabledColor: Theme.of(context).accentColor,
        elevation: 8,
        hint: AutoSizeText(
          'طراز المركبة',
          overflow: TextOverflow.ellipsis,
          textScaleFactor: MediaQuery.of(context).textScaleFactor,
          minFontSize: 9,
          style: Theme.of(context)
              .textTheme
              .bodyText2!
              .copyWith(color: Colors.white),
        ),
        dropdownColor: Theme.of(context).primaryColorLight,
        value: _selectedManufacture,
        onChanged: (newvalue) async {
          setState(() {
            _selectedManufacture = newvalue;
            bool result = Provider.of<Cars>(context, listen: false).setFilters(
                city: _selectedCity != null ? _selectedCity!.cityId : null,
                type: _selectedType != null ? _selectedType!.typeid : null,
                manufacture: _selectedManufacture != null
                    ? _selectedManufacture!.companyname
                    : null,
                operationtype: _selectedOperation != null
                    ? _selectedOperation!.operationid
                    : null,
                year: _selectedYear);
            if (!result) {
              _showErrorDialog('لا يوجد نتائج');
            }
          });
        },
        items: manufacturesData.carManufactures
            .map<DropdownMenuItem<CarManufacture>>((manu) {
          return DropdownMenuItem<CarManufacture>(
            value: manu,
            child: AutoSizeText(
              manu.companyname??"",
              overflow: TextOverflow.ellipsis,
              textScaleFactor: MediaQuery.of(context).textScaleFactor,
              minFontSize: 9,
              style: Theme.of(context)
                  .textTheme
                  .bodyText2!
                  .copyWith(color: Colors.white),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget dropDownCarOperationTypeButton(CarOperationType operationData) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<CarOperationType>(
        //isExpanded: true,
        iconSize: 25,
        iconEnabledColor: Theme.of(context).accentColor,
        elevation: 8,
        hint: AutoSizeText(
          'الحالة',
          overflow: TextOverflow.ellipsis,
          textScaleFactor: MediaQuery.of(context).textScaleFactor,
          minFontSize: 9,
          style: Theme.of(context)
              .textTheme
              .bodyText2!
              .copyWith(color: Colors.white),
        ),
        dropdownColor: Theme.of(context).primaryColorLight,
        value: _selectedOperation,
        onChanged: (newvalue) async {
          setState(() {
            _selectedOperation = newvalue;
            bool result = Provider.of<Cars>(context, listen: false).setFilters(
                city: _selectedCity != null ? _selectedCity!.cityId : null,
                type: _selectedType != null ? _selectedType!.typeid : null,
                manufacture: _selectedManufacture != null
                    ? _selectedManufacture!.companyname
                    : null,
                operationtype: _selectedOperation != null
                    ? _selectedOperation!.operationid
                    : null,
                year: _selectedYear);
            if (!result) {
              _showErrorDialog('لا يوجد نتائج');
            }
          });
        },
        items: operationData.carOperationTypes
            .map<DropdownMenuItem<CarOperationType>>((oper) {
          return DropdownMenuItem<CarOperationType>(
            value: oper,
            child: AutoSizeText(
              oper.operationtype??"",
              overflow: TextOverflow.ellipsis,
              textScaleFactor: MediaQuery.of(context).textScaleFactor,
              minFontSize: 9,
              style: Theme.of(context)
                  .textTheme
                  .bodyText2!
                  .copyWith(color: Colors.white),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget dropDownYearButton() {
    return DropdownButtonHideUnderline(
      child: DropdownButton<int>(
        iconSize: 25,
        iconEnabledColor: Theme.of(context).accentColor,
        elevation: 8,
        hint: AutoSizeText(
          'سنة التصنيع',
          overflow: TextOverflow.ellipsis,
          textScaleFactor: MediaQuery.of(context).textScaleFactor,
          minFontSize: 9,
          style: Theme.of(context)
              .textTheme
              .bodyText1!
              .copyWith(color: Colors.white),
        ),
        dropdownColor: Theme.of(context).primaryColorLight,
        value: _selectedYear,
        onChanged: (newvalue) async {
          setState(() {
            _selectedYear = newvalue;
            bool result = Provider.of<Cars>(context, listen: false).setFilters(
                city: _selectedCity != null ? _selectedCity!.cityId : null,
                type: _selectedType != null ? _selectedType!.typeid : null,
                manufacture: _selectedManufacture != null
                    ? _selectedManufacture!.companyname
                    : null,
                operationtype: _selectedOperation != null
                    ? _selectedOperation!.operationid
                    : null,
                year: _selectedYear);
            if (!result) {
              _showErrorDialog('لا يوجد نتائج');
            }
          });
        },
        items: getYearsInBeteween().map<DropdownMenuItem<int>>((item) {
          return DropdownMenuItem<int>(
            value: item,
            child: AutoSizeText(
              '$item',
              overflow: TextOverflow.ellipsis,
              textScaleFactor: MediaQuery.of(context).textScaleFactor,
              minFontSize: 9,
              style: Theme.of(context)
                  .textTheme
                  .bodyText2!
                  .copyWith(color: Colors.white),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _makeDropDownContainer(Widget dropdown) {
    return Container(
      padding: const EdgeInsets.only(
        left: 10.0,
      ),
      margin: const EdgeInsets.symmetric(horizontal: 2.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Theme.of(context).primaryColorLight,
      ),
      child: dropdown,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cityData = Provider.of<City>(context, listen: false);
    final cartypeData = Provider.of<CarType>(context, listen: false);
    final carmanufactureData =
        Provider.of<CarManufacture>(context, listen: false);
    final caroperationData =
        Provider.of<CarOperationType>(context, listen: false);
    return !isLoading
        ? ListView(
            reverse: true,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(7.0),
            children: [
              _makeDropDownContainer(dropDownCityButton(cityData)),
              _makeDropDownContainer(dropDownCarTypeButton(cartypeData)),
              _makeDropDownContainer(
                  dropDownCarManufactureButton(carmanufactureData)),
              _makeDropDownContainer(
                  dropDownCarOperationTypeButton(caroperationData)),
              _makeDropDownContainer(dropDownYearButton())
            ],
          )
        : Center(
            child: const CircularProgressIndicator(),
          );
  }
}
