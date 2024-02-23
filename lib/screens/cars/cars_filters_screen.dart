import 'package:alshamel_new/helper/http_exception.dart';
import 'package:alshamel_new/providers/car_providers/car_manufacture.dart';
import 'package:alshamel_new/providers/car_providers/car_models.dart';
import 'package:alshamel_new/providers/car_providers/car_operation_type.dart';
import 'package:alshamel_new/providers/car_providers/car_type.dart';
import 'package:alshamel_new/providers/car_providers/cars.dart';
import 'package:alshamel_new/providers/property_providers/city.dart';
import 'package:alshamel_new/screens/cars/cars_homepage_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:intl/intl.dart' as intl1;

class CarsFiltersScreen extends StatefulWidget {
  @override
  _CarsFiltersScreenState createState() => _CarsFiltersScreenState();
}

class _CarsFiltersScreenState extends State<CarsFiltersScreen> {
  bool _isLoading = false;

   City? _selectedCity;
   CarType? _selectedType;
   CarManufacture? _selectedManufacture;
   CarOperationType? _selectedOperation;
   CarModels? _selectedModel;
   int? _selectedYear;

  int _priceRange = 0;

  RangeValues kmValues = RangeValues(0, 10000000);
  RangeLabels kmLabels = RangeLabels('0', '10000000');

  RangeValues priceValues = RangeValues(0, 10000000000);
  RangeLabels priceLabels = RangeLabels('0', '10000000000');

  List<int> getYearsInBeteween() {
    List<int> years = [];
    for (int i = 1960; i <= DateTime.now().year; i++) {
      years.add(i);
    }
    return years;
  }

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

  void _handlePriceRangeChange(int? value) {
    setState(() {
      _priceRange = value!;
    });
  }

  void _goBack(context) {
    Navigator.pop(context);
  }

  Widget dropDownCityButton(City cityData) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<City>(
        isExpanded: true,
        iconSize: 25,
        iconEnabledColor: Theme.of(context).accentColor,
        elevation: 8,
        hint: AutoSizeText(
          'المدينة',
          overflow: TextOverflow.ellipsis,
          textScaleFactor: MediaQuery.of(context).textScaleFactor,
          minFontSize: 9,
          style: Theme.of(context)
              .textTheme
              .bodyText1!
              .copyWith(color: Colors.white),
        ),
        dropdownColor: Theme.of(context).primaryColorLight,
        value: _selectedCity,
        onChanged: (City? newvalue) async {
          setState(() {
            _selectedCity = newvalue!;
          });
        },
        items: cityData.cities.map<DropdownMenuItem<City>>((op) {
          return DropdownMenuItem<City>(
            value: op,
            child: AutoSizeText(
              op.cityName??"",
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

  Widget dropDownTypeButton(CarType typeData) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<CarType>(
        isExpanded: true,
        iconSize: 25,
        iconEnabledColor: Theme.of(context).accentColor,
        elevation: 8,
        hint: AutoSizeText(
          'نوع المركبة',
          overflow: TextOverflow.ellipsis,
          textScaleFactor: MediaQuery.of(context).textScaleFactor,
          minFontSize: 9,
          style: Theme.of(context)
              .textTheme
              .bodyText1!
              .copyWith(color: Colors.white),
        ),
        dropdownColor: Theme.of(context).primaryColorLight,
        value: _selectedType,
        onChanged: (newvalue) async {
          setState(() {
            _selectedType = newvalue!;
          });
        },
        items: typeData.carTypes.map<DropdownMenuItem<CarType>>((cartype) {
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

  Widget dropDownCarManufactureButton(CarManufacture manufactureData) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<CarManufacture>(
        isExpanded: true,
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
              .bodyText1!
              .copyWith(color: Colors.white),
        ),
        dropdownColor: Theme.of(context).primaryColorLight,
        value: _selectedManufacture,
        onChanged: (newvalue) async {
          setState(() {
            _selectedManufacture = newvalue!;
          });
          try {
            setState(() {
              _isLoading = true;
            });
            await Provider.of<CarModels>(context, listen: false)
                .getModelsByManufactureID(_selectedManufacture!.manufactureid.toString()??"");
          } on HttpException {
            _showErrorDialog(
              'فشل عملية جلب الموديلات',
            );
          } catch (error) {
            _showErrorDialog(
              'فشل عملية جلب الموديلات',
            );
          } finally {
            setState(
              () {
                _isLoading = false;
              },
            );
          }
        },
        items: manufactureData.carManufactures
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

  Widget dropDownModelButton() {
    return DropdownButtonHideUnderline(
        child: DropdownButton<CarModels>(
      isExpanded: true,
      iconSize: 25,
      iconEnabledColor: Theme.of(context).accentColor,
      elevation: 8,
      hint: AutoSizeText(
        'موديل المركبة',
        textDirection: TextDirection.rtl,
        overflow: TextOverflow.ellipsis,
        textScaleFactor: MediaQuery.of(context).textScaleFactor,
        minFontSize: 9,
        style:
            Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.white),
      ),
      dropdownColor: Theme.of(context).primaryColorLight,
      value: _selectedModel,
      onChanged: (newvalue) async {
        setState(() {
          _selectedModel = newvalue!;
        });
      },
      items: Provider.of<CarModels>(context)
          .carModels
          .map<DropdownMenuItem<CarModels>>((model) {
        return DropdownMenuItem<CarModels>(
          value: model,
          child: AutoSizeText(
            model.modelname??"",
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
    ));
  }

  Widget dropDownYearButton() {
    return DropdownButtonHideUnderline(
      child: DropdownButton<int>(
        isExpanded: true,
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
            _selectedYear = newvalue!;
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

  Widget dropDownCarOperationTypeButton(CarOperationType operationData) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<CarOperationType>(
        isExpanded: true,
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
            _selectedOperation = newvalue!;
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

  Widget kmRangeSlider() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        AutoSizeText(
          'العداد',
          style: Theme.of(context).textTheme.bodyText1,
          overflow: TextOverflow.ellipsis,
          textScaleFactor: MediaQuery.of(context).textScaleFactor,
          minFontSize: 9,
        ),
        RangeSlider(
            activeColor: Theme.of(context).accentColor,
            inactiveColor: Theme.of(context).primaryColorLight,
            min: 0.0,
            max: 10000000.0,
            divisions: 1000,
            values: kmValues,
            labels: kmLabels,
            onChanged: (value) {
              setState(() {
                kmValues = value;
                kmLabels = RangeLabels('${value.start.toInt().toString()}',
                    '${value.end.toInt().toString()}');
                print("START: ${value.start}, End: ${value.end}");
              });
            }),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            AutoSizeText(
              'الحد الأدنى : ${kmValues.start.toInt().toString()}',
              overflow: TextOverflow.ellipsis,
              textScaleFactor: MediaQuery.of(context).textScaleFactor,
              minFontSize: 9,
            ),
            AutoSizeText(
              'الحد الأعلى : ${kmValues.end.toInt().toString()}',
              overflow: TextOverflow.ellipsis,
              textScaleFactor: MediaQuery.of(context).textScaleFactor,
              minFontSize: 9,
            ),
          ],
        )
      ],
    );
  }

  Widget priceRangeSlider() {
    var p = intl1.NumberFormat.currency(symbol: '');
    var r1 = p.format(priceValues.start.toInt());
    var r2 = p.format(priceValues.end.toInt());

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        AutoSizeText(
          'السعر',
          overflow: TextOverflow.ellipsis,
          textScaleFactor: MediaQuery.of(context).textScaleFactor,
          minFontSize: 9,
          style: Theme.of(context).textTheme.bodyText1,
        ),
        RangeSlider(
            activeColor: Theme.of(context).accentColor,
            inactiveColor: Theme.of(context).primaryColorLight,
            min: 0,
            max: 10000000000,
            divisions: 1000,
            values: priceValues,
            labels: priceLabels,
            onChanged: (value) {
              setState(() {
                priceValues = value;
                priceLabels = RangeLabels('${value.start.toInt().toString()}',
                    '${value.end.toInt().toString()}');
                print("START: ${value.start}, End: ${value.end}");
              });
            }),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            AutoSizeText(
              'الأدنى : $r1',
              //'السعر الأدنى : ${priceValues.start.toInt().toString()}',
              overflow: TextOverflow.ellipsis,
              textScaleFactor: MediaQuery.of(context).textScaleFactor,
              minFontSize: 9,
            ),
            AutoSizeText(
              'الأعلى : $r2',
              //'السعر الأعلى : ${priceValues.end.toInt().toString()}',
              overflow: TextOverflow.ellipsis,
              textScaleFactor: MediaQuery.of(context).textScaleFactor,
              minFontSize: 9,
            ),
          ],
        )
      ],
    );
  }

  Widget showviaMaxMinPrice() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        AutoSizeText(
          'عرض بحسب',
          overflow: TextOverflow.ellipsis,
          textScaleFactor: MediaQuery.of(context).textScaleFactor,
          minFontSize: 9,
          style: Theme.of(context).textTheme.bodyText1!.copyWith(
              color: Theme.of(context).primaryColorLight,
              fontWeight: FontWeight.bold),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Radio(
              value: 0,
              groupValue: _priceRange,
              onChanged: _handlePriceRangeChange,
            ),
            AutoSizeText(
              'السعر من الحد الأدنى إلى الأعلى',
              overflow: TextOverflow.ellipsis,
              textScaleFactor: MediaQuery.of(context).textScaleFactor,
              minFontSize: 9,
              style: Theme.of(context)
                  .textTheme
                  .bodyText2!
                  .copyWith(color: Theme.of(context).primaryColor),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Radio(
              value: 1,
              groupValue: _priceRange,
              onChanged: _handlePriceRangeChange,
            ),
            AutoSizeText(
              'السعر من الحد الأعلى إلى الأدنى',
              overflow: TextOverflow.ellipsis,
              textScaleFactor: MediaQuery.of(context).textScaleFactor,
              minFontSize: 9,
              style: Theme.of(context)
                  .textTheme
                  .bodyText2!
                  .copyWith(color: Theme.of(context).primaryColor),
            ),
          ],
        ),
        Divider(
          color: Theme.of(context).accentColor,
        ),
      ],
    );
  }

  Widget searchButton() {
    return TextButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(
          Theme.of(context).accentColor,
        ),
      ),
      child: AutoSizeText(
        'بحث',
        overflow: TextOverflow.ellipsis,
        textScaleFactor: MediaQuery.of(context).textScaleFactor,
        minFontSize: 9,
        style: Theme.of(context)
            .textTheme
            .bodyText2!
            .copyWith(color: Colors.white, fontSize: 20),
      ),
      onPressed: _setFiltersAndSearch,
    );
  }

  void _setFiltersAndSearch() {
    bool result = Provider.of<Cars>(context, listen: false).setFilters(
      city: _selectedCity != null ? _selectedCity!.cityId : null,
      type: _selectedType != null ? _selectedType!.typeid : null,
      manufacture: _selectedManufacture != null
          ? _selectedManufacture!.companyname
          : null,
      model: _selectedModel != null ? _selectedModel!.modelname : null,
      operationtype:
          _selectedOperation != null ? _selectedOperation!.operationid : null,
      year: _selectedYear,
      minkm: kmValues.start.toInt(),
      maxkm: kmValues.end.toInt(),
      minPrice: priceValues.start.toInt(),
      maxPrice: priceValues.end.toInt(),
      orderBy: _priceRange,
    );
    if (result) {
      Navigator.of(context).pop();
      Navigator.of(context).pushNamed(CarsHomePage.routeName);
    } else {
      _showErrorDialog('لا يوجد نتائج لهذا البحث');
    }
  }

  @override
  Widget build(BuildContext context) {
    /*
    listen to providers to get data
    */
    final cityData = Provider.of<City>(context, listen: false);
    final cartypeData = Provider.of<CarType>(context, listen: false);
    final carmanufactureData =
        Provider.of<CarManufacture>(context, listen: false);
    final caroperationData =
        Provider.of<CarOperationType>(context, listen: false);
    var appBar2 = AppBar(
      leading: Container(),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: IconButton(
            onPressed: () => _goBack(context),
            icon: Icon(
              Icons.arrow_forward,
              color: Theme.of(context).accentColor,
            ),
          ),
        ),
      ],
      title: Text(
        'بحث متقدم',
        style: Theme.of(context)
            .textTheme
            .bodyText1!
            .copyWith(fontWeight: FontWeight.bold),
        textAlign: TextAlign.right,
      ),
    );

    final deviceHeight = MediaQuery.of(context).size.height;
    final topPadding = MediaQuery.of(context).padding.top;
    final bottomPading = MediaQuery.of(context).padding.bottom;
    final availableSpace = deviceHeight - topPadding - bottomPading;
    final containerHeight = availableSpace - appBar2.preferredSize.height;

    return Scaffold(
      appBar: appBar2,
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 35, vertical: 15.0),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 8.0),
                    margin: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 7.0,
                    ),
                    height: containerHeight * .055,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).primaryColorLight,
                    ),
                    child: dropDownCityButton(cityData),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 8.0),
                    margin: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 7.0,
                    ),
                    height: containerHeight * .055,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).primaryColorLight,
                    ),
                    child: dropDownTypeButton(cartypeData),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 8.0),
                    margin: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 7.0,
                    ),
                    height: containerHeight * .055,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).primaryColorLight,
                    ),
                    child: dropDownCarManufactureButton(carmanufactureData),
                  ),
                  _selectedManufacture == null
                      ? Container()
                      : Container(
                          padding: const EdgeInsets.only(left: 8.0),
                          margin: const EdgeInsets.symmetric(
                            horizontal: 10.0,
                            vertical: 7.0,
                          ),
                          height: containerHeight * .055,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Theme.of(context).primaryColorLight,
                          ),
                          child: dropDownModelButton(),
                        ),
                  Container(
                    padding: const EdgeInsets.only(left: 8.0),
                    margin: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 7.0,
                    ),
                    height: containerHeight * .055,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).primaryColorLight,
                    ),
                    child: dropDownCarOperationTypeButton(caroperationData),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 8.0),
                    margin: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 7.0,
                    ),
                    height: containerHeight * .055,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).primaryColorLight,
                    ),
                    child: dropDownYearButton(),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 15.0),
                    //height: containerHeight * .15,
                    child: kmRangeSlider(),
                  ),
                  Container(
                    //height: containerHeight * .15,
                    child: priceRangeSlider(),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 15.0),
                    //height: containerHeight * .2,
                    child: showviaMaxMinPrice(),
                  ),
                  Container(
                    width: double.infinity,
                    height: 50,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 30,
                    ),
                    child: searchButton(),
                  )
                ],
              ),
            ),
    );
  }
}
