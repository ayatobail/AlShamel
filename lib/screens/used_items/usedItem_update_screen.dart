import 'package:alshamel_new/helper/http_exception.dart';
import 'package:alshamel_new/providers/used_items_providers/used_item.dart';
import 'package:alshamel_new/providers/used_items_providers/used_item_type.dart';
import 'package:alshamel_new/providers/used_items_providers/used_items.dart';
import 'package:alshamel_new/screens/used_items/usedItems_homepage_screen.dart';
import 'package:alshamel_new/widgets/used_items_widgets/usedItem_input_mainphoto.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:alshamel_new/providers/property_providers/city.dart';
import 'package:alshamel_new/providers/auth.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';

class UsedItemsUpdateScreen extends StatefulWidget {
  final int? usedItemId;

  const UsedItemsUpdateScreen({this.usedItemId});
  @override
  _UsedItemsUpdateScreenState createState() => _UsedItemsUpdateScreenState();
}

class _UsedItemsUpdateScreenState extends State<UsedItemsUpdateScreen> {
  bool _isAdding = false;
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _usedItemData = {};
  String? mainPhoto;

  City? _selectedCity;
  UsedItemType? _selectedType;

  List<String> prices = ['مليار', 'مليون', 'ألف', 'ليرة'];
   int _generatedPrice=0;
   String? _priceType;

  Widget _generatePrice(int price) {
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
          _buildTextFormField('السعر', price.toString(), TextInputType.number,
              valid: true),
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
            value: _priceType != null ? _priceType : prices[3],
            onChanged: (newvalue) {
              setState(() {
                _priceType = newvalue!;
              });
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
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              content: Text(message),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'))
              ],
            )).then(
      (_) {
        Navigator.pop(context, true);
        Navigator.of(context).pushReplacementNamed(UsedItemsHomePage.routeName);
      },
    );
  }

  Widget dropDownCityButton(City cityData, String cityname) {
    return DropdownButtonFormField<City>(
      decoration: InputDecoration(
        enabledBorder: InputBorder.none,
      ),
      //isDense: true,
      iconSize: 20,
      iconEnabledColor: Theme.of(context).accentColor,
      elevation: 8,

      hint: AutoSizeText(
        cityname,
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

  Widget dropDownTypeButton(UsedItemType typeData, String typename) {
    return DropdownButtonFormField<UsedItemType>(
      decoration: InputDecoration(
        enabledBorder: InputBorder.none,
      ),

      iconSize: 20,
      iconEnabledColor: Theme.of(context).accentColor,
      elevation: 8,
      hint: AutoSizeText(
        typename,
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

  Widget _buildTextFormField(String name, String value, TextInputType type,
      {bool valid = false}) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: TextFormField(
          textAlign: TextAlign.right,
          initialValue: value.toString(),
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

  Widget _buildListOfDetails(UsedItem old) {
    return Column(
      children: [
        _buildTextFormField('عنوان الإعلان', old.title!, TextInputType.text,
            valid: true),
        _buildTextFormField('الوصف', old.description!, TextInputType.text),
        _buildTextFormField('ملاحظات', old.dimensions!, TextInputType.text),
      ],
    );
  }

  void _submitForm(Auth authData, UsedItem old) async {
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
    } else {
      _generatedPrice *= 1;
    }
    try {
      await Provider.of<UsedItems>(context, listen: false).updateUsedItem(
        oldid: old.useditemsid!,
        title: _usedItemData['عنوان الإعلان'],
        itemtypeid: _selectedType != null
            ? _selectedType!.useditemtypeid!
            : old.itemtypeid!,
        cityid: _selectedCity != null ? _selectedCity!.cityId! : old.cityid!,
        // addeddate:
        //     '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}',
        ownerid: authData.ownerId.toString()??"",
        price: '$_generatedPrice',
        description: _usedItemData['الوصف'],
        mainphoto: mainPhoto != null ? mainPhoto! : old.mainphoto!,
        dimensions: _usedItemData['ملاحظات'],
        token: authData.token??"",
      );
      _showSuccessDialog('تم تعديل بيانات الإعلان');
    } on HttpException catch (error) {
      print(error.message);
      _showErrorDialog(
          'فشل عملية تعديل بيانات الإعلان', error.message.toString(), () {
        Navigator.of(context).pop();
      });
      return;
    } catch (error) {
      _showErrorDialog('فشل عملية تعديل بيانات الإعلان', error.toString(), () {
        Navigator.of(context).pop();
      });
      return;
    } finally {
      setState(() {
        _isAdding = false;
      });
    }
  }

  Widget _submitButton(Auth authData, UsedItem old) {
    return TextButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            Theme.of(context).accentColor,
          ),
        ),
        child: AutoSizeText(
          'حفظ',
          overflow: TextOverflow.ellipsis,
          textScaleFactor: MediaQuery.of(context).textScaleFactor,
          minFontSize: 9,
          style: Theme.of(context)
              .textTheme
              .bodyText1!
              .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        onPressed: () => _submitForm(authData, old));
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
          'تعديل إعلان',
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
    final oldUsedItem = Provider.of<UsedItems>(context, listen: false)
        .findByIdForOwner(widget.usedItemId!);
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
                                  cityData, oldUsedItem.cityname??""),
                            ),
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
                              child: dropDownTypeButton(
                                  typeData, oldUsedItem.usedtypename??""),
                            ),
                            _buildListOfDetails(oldUsedItem),
                            _generatePrice(oldUsedItem.price!),
                          ],
                        ),
                      ),
                    ),
                    Divider(
                      color: Theme.of(context).accentColor,
                      indent: 20,
                      endIndent: 20,
                    ),
                    oldUsedItem.mainphoto!.isNotEmpty
                        ? Container(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: Column(
                              children: [
                                AutoSizeText(
                                  'أضف صورة جديدة لتعديل الصورة السابقة',
                                  textDirection: TextDirection.rtl,
                                  overflow: TextOverflow.ellipsis,
                                  textScaleFactor:
                                      MediaQuery.of(context).textScaleFactor,
                                  minFontSize: 9,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2!
                                      .copyWith(
                                        color: Theme.of(context).primaryColor,
                                      ),
                                ),
                                Container(
                                  height: containerHeight * .3,
                                  child: CachedNetworkImage(
                                  imageUrl:oldUsedItem.mainphoto??"",
                                    cacheKey: oldUsedItem.mainphoto!+DateTime.now().second.toString(),
                                    fit: BoxFit.fill,
                                )
                                  /*Image.network(
                                    oldUsedItem.mainphoto??"",
                                    fit: BoxFit.fill,
                                  ),*/
                                ),
                              ],
                            ),
                          )
                        : Container(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      height: containerHeight * .3,
                      child: UsedItemInputMainPhoto(setMainPhoto),
                    ),
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 60, vertical: 20),
                      child: _submitButton(authData, oldUsedItem),
                    )
                  ],
                ),
              ),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'تتم عملية تعديل بيانات الإعلان الآن',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  CircularProgressIndicator(),
                ],
              ),
            ),
    );
  }
}
