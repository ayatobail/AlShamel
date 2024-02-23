import 'package:alshamel_new/helper/http_exception.dart';
import 'package:alshamel_new/providers/used_items_providers/used_item_type.dart';
import 'package:alshamel_new/providers/used_items_providers/used_items.dart';
import 'package:alshamel_new/screens/used_items/usedItems_homepage_screen.dart';
import 'package:alshamel_new/widgets/used_items_widgets/usedItem_input_mainphoto.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:alshamel_new/providers/property_providers/city.dart';
import 'package:alshamel_new/providers/auth.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class UsedItemsAddNewScreen extends StatefulWidget {
  @override
  _UsedItemsAddNewScreenState createState() => _UsedItemsAddNewScreenState();
}

class _UsedItemsAddNewScreenState extends State<UsedItemsAddNewScreen> {
  bool _isAdding = false;
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _usedItemData = {};
  String?  mainPhoto;

  City? _selectedCity;
  UsedItemType? _selectedType;

  List<String> prices = ['مليار', 'مليون', 'ألف', 'ليرة'];
   int _generatedPrice=0;
   String? _priceType;

  Widget _generatePrice() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).accentColor),
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.symmetric(vertical: 20),
      padding: EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildTextFormField('السعر', TextInputType.number, valid: true),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              enabledBorder: InputBorder.none,
            ),
            iconSize: 25,
            iconEnabledColor: Theme.of(context).accentColor,
            elevation: 8,
            hint: AutoSizeText(
              'فئة السعر',
              textDirection: TextDirection.rtl,
              overflow: TextOverflow.ellipsis,
              textScaleFactor: MediaQuery.of(context).textScaleFactor,
              minFontSize: 9,
              style: Theme.of(context)
                  .textTheme
                  .bodyText2!
                  .copyWith(color: Theme.of(context).primaryColor),
            ),
            dropdownColor: Theme.of(context).primaryColorLight,
            value: _priceType,
            onChanged: (newvalue) {
              setState(() {
                _priceType = newvalue!;
              });
            },
            // ignore: missing_return
            validator: (value) {
              if (value == null) {
                return 'اختر فئة السعر';
              }
            },
            onSaved: (val) => setState(() => {_priceType = val!}),
            items: prices.map<DropdownMenuItem<String>>((op) {
              return DropdownMenuItem(
                value: op,
                child: AutoSizeText(
                  op,
                  overflow: TextOverflow.ellipsis,
                  textScaleFactor: MediaQuery.of(context).textScaleFactor,
                  minFontSize: 9,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2!
                      .copyWith(color: Theme.of(context).primaryColor),
                ),
              );
            }).toList(),
          )
        ],
      ),
    );
  }

  void setMainPhoto(String image) {
    mainPhoto = image;
  }

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

  void _showSuccessDialog(String message) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.SUCCES,
      animType: AnimType.LEFTSLIDE,
      desc: message,
      btnOkIcon: Icons.check_circle,
      btnOkOnPress: () {
        Navigator.pop(context, true);
        Navigator.of(context).pushReplacementNamed(UsedItemsHomePage.routeName);
      },
      btnOkColor: Theme.of(context).primaryColor,
      onDissmissCallback: (_) => {
        Navigator.pop(context, true),
        Navigator.of(context).pushReplacementNamed(UsedItemsHomePage.routeName),
      },
    ).show();
  }

  Widget dropDownCityButton(City cityData) {
    return DropdownButtonFormField<City>(
      decoration: InputDecoration(
        enabledBorder: InputBorder.none,
      ),
      //isDense: true,
      iconSize: 20,
      iconEnabledColor: Theme.of(context).accentColor,
      elevation: 8,

      hint: AutoSizeText(
        'المحافظة',
        textDirection: TextDirection.rtl,
        overflow: TextOverflow.ellipsis,
        textScaleFactor: MediaQuery.of(context).textScaleFactor,
        minFontSize: 9,
        style:
            Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.white),
      ),
      dropdownColor: Theme.of(context).primaryColorLight,
      value: _selectedCity,
      onChanged: (newvalue) async {
        setState(() {
          _selectedCity = newvalue;
        });
      },
      // ignore: missing_return
      validator: (City? value) {
        if (value == null) {
          return 'اختر المدينة';
        }
      },
      onSaved: (val) => setState(() => _selectedCity = val),
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
    );
  }

  Widget dropDownTypeButton(UsedItemType typeData) {
    return DropdownButtonFormField<UsedItemType>(
      decoration: InputDecoration(
        enabledBorder: InputBorder.none,
      ),

      iconSize: 20,
      iconEnabledColor: Theme.of(context).accentColor,
      elevation: 8,
      hint: AutoSizeText(
        'الفئة',
        overflow: TextOverflow.ellipsis,
        textScaleFactor: MediaQuery.of(context).textScaleFactor,
        minFontSize: 9,
        style:
            Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.white),
      ),
      dropdownColor: Theme.of(context).primaryColorLight,
      value: _selectedType,
      // ignore: missing_return
      validator: (UsedItemType? value) {
        if (value == null) {
          return 'اختر الفئة';
        }
      },
      onSaved: (val) => setState(() => _selectedType = val),
      onChanged: (newvalue) async {
        setState(() {
          _selectedType = newvalue;
        });
      },
      items: typeData.types.map<DropdownMenuItem<UsedItemType>>((t) {
        return DropdownMenuItem(
          value: t,
          child: AutoSizeText(
            t.usedtypename??"",
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
    );
  }

  void _goBack(context) {
    Navigator.of(context).pop();
  }

  Widget _buildTextFormField(String name, TextInputType type,
      {bool valid = false}) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: TextFormField(
          textAlign: TextAlign.right,
          textDirection: TextDirection.rtl,
          keyboardType: type,
          decoration: InputDecoration(
              labelText: name,
              labelStyle: Theme.of(context).textTheme.bodyText2),
          // ignore: missing_return
          validator: (value) {
            if (valid == true && value!.isEmpty) {
              return 'هذا الحقل فارغ';
            }
          },
          onSaved: (val) => _usedItemData[name] = val,
        ),
      ),
    );
  }

  Widget _buildListOfDetails() {
    return Column(
      children: [
        _buildTextFormField('عنوان الإعلان', TextInputType.text, valid: true),
        _buildTextFormField('الوصف', TextInputType.text),
        _buildTextFormField('ملاحظات', TextInputType.text),
      ],
    );
  }

  void _submitForm(Auth authData) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();

    setState(() {
      _isAdding = true;
    });
    String te = _usedItemData['السعر'];
    _generatedPrice = int.parse(te);
    if (_priceType == 'مليار') {
      _generatedPrice *= 1000000000;
    } else if (_priceType == 'مليون') {
      _generatedPrice *= 1000000;
    } else if (_priceType == 'ألف') {
      _generatedPrice *= 1000;
    }
    try {
      await Provider.of<UsedItems>(context, listen: false).addUsedItem(
        title: _usedItemData['عنوان الإعلان'],
        itemtypeid: _selectedType!.useditemtypeid!,
        cityid: _selectedCity!.cityId!,
        /*addeddate:
            '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}',*/
        ownerid: authData.ownerId!,
        price: '$_generatedPrice',
        description: _usedItemData['الوصف'],
        mainphoto: mainPhoto??"",
        dimensions: _usedItemData['ملاحظات'],
        //token: authData.token??"",
      );
      _showSuccessDialog('تمت إضافة الإعلان');
    } on HttpException catch (error) {
      _showErrorDialog('فشل عملية إضافة الإعلان', error.message.toString(), () {
        Navigator.of(context).pop();
      });
      return;
    } finally {
      setState(() {
        _isAdding = false;
      });
    }
  }

  Widget _submitButton(Auth authData) {
    return TextButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            Theme.of(context).accentColor,
          ),
        ),
        child: AutoSizeText(
          'نشر',
          overflow: TextOverflow.ellipsis,
          textScaleFactor: MediaQuery.of(context).textScaleFactor,
          minFontSize: 9,
          style: Theme.of(context)
              .textTheme
              .bodyText1!
              .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        onPressed: () => _submitForm(authData));
  }

  @override
  Widget build(BuildContext context) {
    final cityData = Provider.of<City>(context, listen: false);
    final typeData = Provider.of<UsedItemType>(context, listen: false);

    final authData = Provider.of<Auth>(context, listen: false);
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
      title: Center(
        child: AutoSizeText(
          'إضافة إعلان',
          overflow: TextOverflow.ellipsis,
          textScaleFactor: MediaQuery.of(context).textScaleFactor,
          minFontSize: 9,
          style: Theme.of(context)
              .textTheme
              .bodyText1!
              .copyWith(fontWeight: FontWeight.bold),
        ),
      ),
    );
    final deviceHeight = MediaQuery.of(context).size.height;
    final topPadding = MediaQuery.of(context).padding.top;
    final bottomPading = MediaQuery.of(context).padding.bottom;
    final availableSpace = deviceHeight - topPadding - bottomPading;
    final containerHeight = availableSpace - appBar2.preferredSize.height;

    return Scaffold(
      appBar: appBar2,
      body: (_isAdding == false)
          ? Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Card(
                      elevation: 2,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 30),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.only(left: 10.0),
                              margin: const EdgeInsets.symmetric(
                                horizontal: 4.0,
                                vertical: 4.0,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Theme.of(context).primaryColorLight,
                              ),
                              child: dropDownCityButton(
                                cityData,
                              ),
                            ),
                            Container(
                              //height: containerHeight * .06,
                              padding: const EdgeInsets.only(left: 10.0),
                              margin: const EdgeInsets.symmetric(
                                horizontal: 4.0,
                                vertical: 4.0,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Theme.of(context).primaryColorLight,
                              ),
                              child: dropDownTypeButton(typeData),
                            ),
                            _buildListOfDetails(),
                            _generatePrice(),
                          ],
                        ),
                      ),
                    ),
                    Divider(
                      color: Theme.of(context).accentColor,
                      indent: 20,
                      endIndent: 20,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      height: containerHeight * .3,
                      child: UsedItemInputMainPhoto(setMainPhoto),
                    ),
                    Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 60, vertical: 20),
                        child: _submitButton(authData))
                  ],
                ),
              ),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'تتم عملية إضافة الإعلان الآن',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: LinearProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).accentColor),
                      backgroundColor: Theme.of(context).primaryColorLight,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
