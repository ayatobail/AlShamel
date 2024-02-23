import 'package:alshamel_new/providers/property_providers/city.dart';
import 'package:alshamel_new/providers/used_items_providers/used_item_type.dart';
import 'package:alshamel_new/providers/used_items_providers/used_items.dart';
import 'package:alshamel_new/screens/used_items/usedItems_homepage_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:intl/intl.dart' as intl1;
import 'package:awesome_dialog/awesome_dialog.dart';

class UsedItemsFiltersScreen extends StatefulWidget {
  @override
  _UsedItemsFiltersScreenState createState() => _UsedItemsFiltersScreenState();
}

class _UsedItemsFiltersScreenState extends State<UsedItemsFiltersScreen> {
  bool _isLoading = false;

  City? _selectedCity;
  UsedItemType? _selectedType;

  int _priceRange = 0;

  RangeValues priceValues = RangeValues(0, 10000000000);
  RangeLabels priceLabels = RangeLabels('0', '10000000000');

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
            _selectedCity = newvalue;
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

  Widget dropDownTypeButton(UsedItemType typeData) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<UsedItemType>(
        isExpanded: true,
        iconSize: 25,
        iconEnabledColor: Theme.of(context).accentColor,
        elevation: 8,
        hint: AutoSizeText(
          'الفئة',
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
            _selectedType = newvalue;
          });
        },
        items: typeData.types.map<DropdownMenuItem<UsedItemType>>((type) {
          return DropdownMenuItem<UsedItemType>(
            value: type,
            child: AutoSizeText(
              type.usedtypename??"",
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
              overflow: TextOverflow.ellipsis,
              textScaleFactor: MediaQuery.of(context).textScaleFactor,
              minFontSize: 9,
            ),
            AutoSizeText(
              'الأعلى : $r2',
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
    bool result = Provider.of<UsedItems>(context, listen: false).setFilters(
      city: _selectedCity != null ? _selectedCity!.cityId : null,
      type: _selectedType != null ? _selectedType!.useditemtypeid : null,
      minPrice: priceValues.start.toInt(),
      maxPrice: priceValues.end.toInt(),
      orderBy: _priceRange,
    );
    if (result) {
      Navigator.of(context).pop();
      Navigator.of(context).pushNamed(UsedItemsHomePage.routeName);
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
    final typeData = Provider.of<UsedItemType>(context, listen: false);

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
                      horizontal: 15.0,
                      vertical: 10.0,
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
                      horizontal: 15.0,
                      vertical: 10.0,
                    ),
                    height: containerHeight * .055,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).primaryColorLight,
                    ),
                    child: dropDownTypeButton(typeData),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 20.0),
                    child: priceRangeSlider(),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 30.0),
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
