import 'package:alshamel_new/providers/used_items_providers/used_item_type.dart';
import 'package:alshamel_new/providers/used_items_providers/used_items.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:alshamel_new/providers/property_providers/city.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class UsedItemsFiltersBar extends StatefulWidget {
  @override
  _UsedItemsFiltersBarState createState() => _UsedItemsFiltersBarState();
}

class _UsedItemsFiltersBarState extends State<UsedItemsFiltersBar> {
  City? _selectedCity;
  UsedItemType? _selectedType;

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
            _selectedCity = newvalue!;
            bool result =
                Provider.of<UsedItems>(context, listen: false).setFilters(
              city: _selectedCity != null ? _selectedCity!.cityId : null,
              type: _selectedType != null ? _selectedType!.useditemtypeid : null,
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

  Widget dropDownUsedItemTypeButton(UsedItemType typeData) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<UsedItemType>(
        iconEnabledColor: Theme.of(context).accentColor,
        hint: AutoSizeText(
          'نوع الخدمة',
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
        onChanged: (UsedItemType? newvalue) async {
          setState(() {
            _selectedType = newvalue!;
            bool result =
                Provider.of<UsedItems>(context, listen: false).setFilters(
              city: _selectedCity != null ? _selectedCity!.cityId : null,
              type: _selectedType != null ? _selectedType!.useditemtypeid : null,
            );
            if (!result) {
              _showErrorDialog('لا يوجد نتائج');
            }
          });
        },
        items:
            typeData.types.map<DropdownMenuItem<UsedItemType>>((useditemtype) {
          return DropdownMenuItem<UsedItemType>(
            value: useditemtype,
            child: AutoSizeText(
              useditemtype.usedtypename??"",
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

  @override
  Widget build(BuildContext context) {
    final cityData = Provider.of<City>(context, listen: false);
    final useditemtypeData = Provider.of<UsedItemType>(context, listen: false);

    return !isLoading
        ? ListView(
            reverse: true,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(7.0),
            children: [
              Container(
                padding: const EdgeInsets.only(
                  left: 10.0,
                ),
                margin: const EdgeInsets.symmetric(horizontal: 2.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Theme.of(context).primaryColorLight,
                ),
                child: dropDownCityButton(cityData),
              ),
              Container(
                padding: const EdgeInsets.only(left: 10.0),
                margin: const EdgeInsets.symmetric(horizontal: 2.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Theme.of(context).primaryColorLight,
                ),
                child: dropDownUsedItemTypeButton(useditemtypeData),
              ),
            ],
          )
        : Center(
            child: const CircularProgressIndicator(),
          );
  }
}
