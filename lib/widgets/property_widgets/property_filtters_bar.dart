import 'package:alshamel_new/helper/location_update.dart';
import 'package:alshamel_new/providers/property_providers/property.dart';
import 'package:alshamel_new/providers/property_providers/property_registration_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:alshamel_new/providers/property_providers/city.dart';
import 'package:alshamel_new/providers/property_providers/type.dart';
import 'package:alshamel_new/providers/property_providers/operation.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_geocoder/geocoder.dart';
import 'package:alshamel_new/helper/location_helper.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class PropertyFiltersBar extends StatefulWidget {
  @override
  _PropertyFiltersBarState createState() => _PropertyFiltersBarState();
}

class _PropertyFiltersBarState extends State<PropertyFiltersBar> {
  City? _selectedCity;
  Type? _selectedType;
  Operation? _selectedOperation;
  var first;
  PropertyRegistrationType? _selectedRegistrationType;
  bool isLoading = false;
  var addresses;
  Future<void> search(cityName) async {
    this.setState(() {
      this.isLoading = true;
    });

    try {
      List<Address> addresses =
          await Geocoder.google(LocationHelper.GOOGLE_API_KEY)
              .findAddressesFromQuery(cityName);

      var firstLocation = addresses.first;
      Provider.of<LocationUpdate>(context, listen: false).set(
          firstLocation.coordinates.latitude!,
          firstLocation.coordinates.longitude!);
    } catch (e) {
      print("Error occured: $e");
    } finally {
      this.setState(() {
        this.isLoading = false;
      });
    }
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

  Widget dropDownCityButton(City cityData) {
    return this.isLoading
        ? CircularProgressIndicator()
        : DropdownButtonHideUnderline(
            child: DropdownButton<City>(
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
              dropdownColor: Theme.of(context).primaryColor,
              value: _selectedCity,
              onChanged: (City? newvalue) async {
                setState(
                  () {
                    _selectedCity = newvalue;

                    search(newvalue!.cityName).then((_) {
                      bool res = Provider.of<Property>(context, listen: false)
                          .setFilters(
                        type:
                            _selectedType != null ? _selectedType!.typeId : null,
                        city:
                            _selectedCity != null ? _selectedCity!.cityId : null,
                        operation: _selectedOperation != null
                            ? _selectedOperation!.operationId
                            : null,
                        regType: _selectedRegistrationType != null
                            ? _selectedRegistrationType!.id
                            : null,
                      );
                      if (!res) {
                        _showErrorDialog('لا يوجد عقارات توافق البحث');
                      }
                    });
                  },
                );
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

  Widget dropDownTypeButton(Type typeData) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<Type>(
        iconEnabledColor: Theme.of(context).accentColor,
        iconSize: 25,
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
        dropdownColor: Theme.of(context).primaryColor,
        value: _selectedType,
        onChanged: (Type? newvalue) async {
          setState(
            () {
              _selectedType = newvalue;
              bool res =
                  Provider.of<Property>(context, listen: false).setFilters(
                type: _selectedType != null ? _selectedType!.typeId : null,
                city: _selectedCity != null ? _selectedCity!.cityId : null,
                operation: _selectedOperation != null
                    ? _selectedOperation!.operationId
                    : null,
                regType: _selectedRegistrationType != null
                    ? _selectedRegistrationType!.id
                    : null,
              );
              if (!res) {
                _showErrorDialog('لا يوجد عقارات توافق البحث');
              }
            },
          );
        },
        items: typeData.types.map<DropdownMenuItem<Type>>(
          (t) {
            return DropdownMenuItem<Type>(
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
          },
        ).toList(),
      ),
    );
  }

  Widget dropDownOperationButton(Operation operationData) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<Operation>(
        iconEnabledColor: Theme.of(context).accentColor,
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
        iconSize: 25,
        elevation: 8,
        dropdownColor: Theme.of(context).primaryColor,
        value: _selectedOperation,
        onChanged: (newvalue) async {
          setState(() {
            _selectedOperation = newvalue;
            bool res = Provider.of<Property>(context, listen: false).setFilters(
              type: _selectedType != null ? _selectedType!.typeId : null,
              city: _selectedCity != null ? _selectedCity!.cityId : null,
              operation: _selectedOperation != null
                  ? _selectedOperation!.operationId
                  : null,
              regType: _selectedRegistrationType != null
                  ? _selectedRegistrationType!.id
                  : null,
            );
            if (!res) {
              _showErrorDialog('لا يوجد عقارات توافق البحث');
            }
          });
        },
        items: operationData.operations.map<DropdownMenuItem<Operation>>((op) {
          return DropdownMenuItem(
            value: op,
            child: Text(
              op.operationName!,
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

  Widget dropDownRegistrationTypeButton(PropertyRegistrationType regTypedata) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<PropertyRegistrationType>(
        iconEnabledColor: Theme.of(context).accentColor,
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
        iconSize: 25,
        elevation: 8,
        dropdownColor: Theme.of(context).primaryColor,
        value: _selectedRegistrationType,
        onChanged: (newvalue) async {
          setState(() {
            _selectedRegistrationType = newvalue;
            bool res = Provider.of<Property>(context, listen: false).setFilters(
                type: _selectedType != null ? _selectedType!.typeId : null,
                city: _selectedCity != null ? _selectedCity!.cityId : null,
                operation: _selectedOperation != null
                    ? _selectedOperation!.operationId
                    : null,
                regType: _selectedRegistrationType != null
                    ? _selectedRegistrationType!.id
                    : null);
            if (!res) {
              _showErrorDialog('لا يوجد عقارات توافق البحث');
            }
          });
        },
        items: regTypedata.items
            .map<DropdownMenuItem<PropertyRegistrationType>>((op) {
          return DropdownMenuItem(
            value: op,
            child: Text(
              op.name!,
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
    final typeData = Provider.of<Type>(context, listen: false);
    final operationData = Provider.of<Operation>(context, listen: false);
    final regTypeData =
        Provider.of<PropertyRegistrationType>(context, listen: false);
    return ListView(
      reverse: true,
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(6.0),
      children: [
        Container(
          padding: const EdgeInsets.only(
            left: 10.0,
          ),
          margin: const EdgeInsets.symmetric(horizontal: 2.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Theme.of(context).primaryColor,
          ),
          child: dropDownCityButton(cityData),
        ),
        Container(
          padding: const EdgeInsets.only(left: 10.0),
          margin: const EdgeInsets.symmetric(horizontal: 2.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Theme.of(context).primaryColor,
          ),
          child: dropDownTypeButton(typeData),
        ),
        Container(
          padding: const EdgeInsets.only(left: 10.0),
          margin: const EdgeInsets.symmetric(horizontal: 2.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Theme.of(context).primaryColor,
          ),
          child: dropDownOperationButton(operationData),
        ),
        Container(
          padding: const EdgeInsets.only(left: 10.0),
          margin: const EdgeInsets.symmetric(horizontal: 2.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Theme.of(context).primaryColor,
          ),
          child: dropDownRegistrationTypeButton(regTypeData),
        ),
      ],
    );
  }
}
