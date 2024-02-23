import 'package:alshamel_new/providers/property_providers/property_registration_type.dart';
import 'package:provider/provider.dart';
import 'package:alshamel_new/providers/property_providers/operation.dart';
import 'package:alshamel_new/providers/property_providers/property.dart';
import 'package:alshamel_new/providers/property_providers/type.dart';
import 'package:alshamel_new/providers/property_providers/city.dart';
import 'package:alshamel_new/screens/property/property_homepage_screen.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:intl/intl.dart' as intl1;
import 'package:awesome_dialog/awesome_dialog.dart';

class PropertyFiltersScreen extends StatefulWidget {
  @override
  _PropertyFiltersScreenState createState() => _PropertyFiltersScreenState();
}

class _PropertyFiltersScreenState extends State<PropertyFiltersScreen> {
  bool _isLoading = false;

   Type? _selectedType;
   Operation? _selectedOperation;
   City? _selectedCity;
   PropertyRegistrationType? _selectedRegType;

  int _priceRange = 0;

  RangeValues areaValues = RangeValues(0, 10000);
  RangeLabels areaLabels = RangeLabels('0', '10000');

  RangeValues priceValues = RangeValues(0, 1000000000);
  RangeLabels priceLabels = RangeLabels('0', '1000000000');

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

  Widget dropDownTypeButton(Type typeData) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<Type>(
        isExpanded: true,
        iconSize: 25,
        iconEnabledColor: Theme.of(context).accentColor,
        elevation: 8,
        hint: AutoSizeText(
          'نوع العقار',
          overflow: TextOverflow.ellipsis,
          textScaleFactor: MediaQuery.of(context).textScaleFactor,
          minFontSize: 9,
          style: Theme.of(context)
              .textTheme
              .bodyText2!
              .copyWith(color: Colors.white),
        ),
        dropdownColor: Theme.of(context).primaryColorLight,
        value: _selectedType,
        onChanged: (newvalue) async {
          setState(() {
            _selectedType = newvalue!;
          });
        },
        items: typeData.types.map<DropdownMenuItem<Type>>((t) {
          return DropdownMenuItem(
            value: t,
            child: AutoSizeText(
              t.typeName??"",
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

  Widget dropDownOperationButton(Operation operationData) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<Operation>(
        isExpanded: true,
        iconSize: 25,
        iconEnabledColor: Theme.of(context).accentColor,
        elevation: 8,
        hint: AutoSizeText(
          'نوع العملية',
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
        items: operationData.operations.map<DropdownMenuItem<Operation>>((op) {
          return DropdownMenuItem(
            value: op,
            child: AutoSizeText(
              op.operationName??"",
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

  Widget dropDownRegistrationTypeButton(PropertyRegistrationType regTypeData) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<PropertyRegistrationType>(
        isExpanded: true,
        iconSize: 25,
        iconEnabledColor: Theme.of(context).accentColor,
        elevation: 8,
        hint: AutoSizeText(
          'نوع الملكية',
          overflow: TextOverflow.ellipsis,
          textScaleFactor: MediaQuery.of(context).textScaleFactor,
          minFontSize: 9,
          style: Theme.of(context)
              .textTheme
              .bodyText2!
              .copyWith(color: Colors.white),
        ),
        dropdownColor: Theme.of(context).primaryColorLight,
        value: _selectedRegType,
        onChanged: (newvalue) async {
          setState(() {
            _selectedRegType = newvalue!;
          });
        },
        items: regTypeData.items
            .map<DropdownMenuItem<PropertyRegistrationType>>((t) {
          return DropdownMenuItem(
            value: t,
            child: AutoSizeText(
              t.name??"",
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

  Widget areaRangeSlider() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'المساحة',
          style: Theme.of(context).textTheme.bodyText1,
        ),
        RangeSlider(
            activeColor: Theme.of(context).accentColor,
            inactiveColor: Theme.of(context).primaryColorLight,
            min: 0,
            max: 10000,
            divisions: 1000,
            values: areaValues,
            labels: areaLabels,
            onChanged: (value) {
              setState(() {
                areaValues = value;
                areaLabels = RangeLabels('${value.start.toInt().toString()}',
                    '${value.end.toInt().toString()}');
                print("START: ${value.start}, End: ${value.end}");
              });
            }),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text('الحد الأدنى : ${areaValues.start.toInt().toString()}'),
            Text('الحد الأعلى : ${areaValues.end.toInt().toString()}'),
          ],
        )
      ],
    );
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
              .bodyText2!
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

  Widget priceRangeSlider() {
    var p = intl1.NumberFormat.currency(symbol: '');
    var r1 = p.format(priceValues.start.toInt());
    var r2 = p.format(priceValues.end.toInt());
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'السعر',
          style: Theme.of(context).textTheme.bodyText1,
        ),
        RangeSlider(
            activeColor: Theme.of(context).accentColor,
            inactiveColor: Theme.of(context).primaryColorLight,
            min: 0,
            max: 1000000000,
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
            Text('الأدنى : $r1'),
            Text('الأعلى : $r2'),
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
        Text(
          'عرض بحسب',
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
            Text(
              'السعر من الحد الأدنى إلى الأعلى',
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
            Text(
              'السعر من الحد الأعلى إلى الأدنى',
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
            .bodyText1!
            .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      onPressed: _setFiltersAndSearch,
    );
  }

  void _setFiltersAndSearch() {
    bool res = Provider.of<Property>(context, listen: false).setFilters(
      type: _selectedType != null ? _selectedType!.typeId : null,
      city: _selectedCity != null ? _selectedCity!.cityId : null,
      operation:
          _selectedOperation != null ? _selectedOperation!.operationId : null,
      regType: _selectedRegType != null ? _selectedRegType!.id : null,
      minAreaSize: areaValues.start.toInt(),
      maxAreaSize: areaValues.end.toInt(),
      minPrice: priceValues.start.toInt(),
      maxPrice: priceValues.end.toInt(),
      orderBy: _priceRange,
    );
    if (res) {
      Navigator.of(context).pop();
      Navigator.of(context).pushNamed(PropertyHomePage.routeName);
    } else {
      _showErrorDialog('لا يوجد نتائج');
    }
  }

  Widget makeTextField(String label) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: TextField(
        textAlign: TextAlign.right,
        textDirection: TextDirection.rtl,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: Theme.of(context).textTheme.bodyText1,
        ),
      ),
    );
  }

  Widget _makeDropDownContainer(containerHeight, Widget dropdown) {
    return Container(
      padding: const EdgeInsets.only(left: 8.0),
      margin: const EdgeInsets.symmetric(
        horizontal: 10.0,
        vertical: 5.0,
      ),
      height: containerHeight * .055,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).primaryColorLight,
      ),
      child: dropdown,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cityData = Provider.of<City>(context, listen: false);
    final typeData = Provider.of<Type>(context, listen: false);
    final operationData = Provider.of<Operation>(context, listen: false);
    final regtypeData =
        Provider.of<PropertyRegistrationType>(context, listen: false);

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
                  _makeDropDownContainer(
                    containerHeight,
                    dropDownTypeButton(typeData),
                  ),
                  _makeDropDownContainer(
                    containerHeight,
                    dropDownOperationButton(operationData),
                  ),
                  _makeDropDownContainer(
                    containerHeight,
                    dropDownRegistrationTypeButton(regtypeData),
                  ),
                  _makeDropDownContainer(
                    containerHeight,
                    dropDownCityButton(cityData),
                  ),
                  makeTextField('العنوان'),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 15.0),
                    child: areaRangeSlider(),
                  ),
                  Container(
                    child: priceRangeSlider(),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 15.0),
                    child: showviaMaxMinPrice(),
                  ),
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 20,
                    ),
                    child: searchButton(),
                  )
                ],
              ),
            ),
    );
  }
}
