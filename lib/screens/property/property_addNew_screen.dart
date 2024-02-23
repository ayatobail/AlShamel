import 'package:alshamel_new/helper/http_exception.dart';
import 'package:alshamel_new/models/property_models.dart/type_detail.dart';
import 'package:alshamel_new/providers/property_providers/property_item.dart';
import 'package:alshamel_new/providers/property_providers/property_registration_type.dart';
import 'package:alshamel_new/providers/property_providers/type_details.dart';
import 'package:alshamel_new/screens/property/map_pick_location_screen.dart';
import 'package:alshamel_new/screens/property/property_homepage_screen.dart';
import 'package:alshamel_new/widgets/property_widgets/image_input.dart';
import 'package:alshamel_new/widgets/property_widgets/input_main_photo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:alshamel_new/providers/property_providers/city.dart';
import 'package:alshamel_new/providers/property_providers/operation.dart';
import 'package:alshamel_new/providers/property_providers/type.dart';
import 'package:alshamel_new/providers/property_providers/property.dart';
import 'package:alshamel_new/providers/auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'dart:convert';

class PropertyAddNewScreen extends StatefulWidget {
  @override
  _PropertyAddNewScreenState createState() => _PropertyAddNewScreenState();
}

class _PropertyAddNewScreenState extends State<PropertyAddNewScreen> {
  LatLng? _curLocation;
  Future<void> _getcurrentplace() async {
    LocationData locData = await Location().getLocation();
    if (locData == null) {
      return;
    }
    setState(() {
      _curLocation = LatLng(locData.latitude!, locData.longitude!);
    });
  }

  @override
  void initState() {
    super.initState();
    _getcurrentplace();
    setState(() {
      _isLoadingTypeDetails = true;
    });
    Future.wait(
            [Provider.of<TypeDetails>(context, listen: false).getTypeDetails()])
        .then((value) => setState(() {
              _isLoadingTypeDetails = false;
            }));
  }

  bool _isLoadingTypeDetails = false;
  bool _isAdding = false;
  bool _isUploading = false;
  final _formKey = GlobalKey<FormState>();
  final _typedetailsformkey = GlobalKey<FormState>();
  LatLng? _pickedLocation;
  final Map<String, dynamic> _propertyData = {};
  final Map<String, dynamic> _typeDetailsValues = {};
  List<String> _uploadedImages = [];
  String? mainPhoto;
  City? _selectedCity;
  Type? _selectedType;
  Operation? _selectedOperation;
  PropertyRegistrationType? _selectedRegType;
  String? id;

  List<String> prices = ['مليار', 'مليون', 'ألف', 'ليرة'];
   int _generatedPrice=0;
   String? _priceType;

  void setUploadedImages() {
    for (var e
        in Provider.of<PropertyItem>(context, listen: false).getimgsForUpload) {
      List<int> fileInByte = e.readAsBytesSync();
      String fileInBase64 = base64Encode(fileInByte);
      _uploadedImages.add(fileInBase64);
    }
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
        Navigator.of(context).pushReplacementNamed(PropertyHomePage.routeName);
      },
      btnOkColor: Theme.of(context).primaryColor,
      onDissmissCallback: (_) => {
        Navigator.pop(context, true),
        Navigator.of(context).pushReplacementNamed(PropertyHomePage.routeName),
      },
    ).show();
  }

  Widget dropDownCityButton(City cityData) {
    return DropdownButtonFormField<City>(
      decoration: InputDecoration(
        enabledBorder: InputBorder.none,
      ),
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
      validator: ( value) {
        if (_selectedCity == null) {
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

  Widget dropDownTypeButton(Type typeData, TypeDetails typeDetailsData) {
    return DropdownButtonFormField<Type>(
      decoration: InputDecoration(
        enabledBorder: InputBorder.none,
      ),

      iconSize: 20,
      iconEnabledColor: Theme.of(context).accentColor,
      elevation: 8,
      hint: AutoSizeText(
        'نوع العقار',
        overflow: TextOverflow.ellipsis,
        textScaleFactor: MediaQuery.of(context).textScaleFactor,
        minFontSize: 9,
        style:
            Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.white),
      ),
      dropdownColor: Theme.of(context).primaryColorLight,
      value: _selectedType,
      // ignore: missing_return
      validator: ( value) {
        if (value == null) {
          return 'اختر نوع العقار';
        }
      },
      onSaved: (val) => setState(() => _selectedType = val),
      onChanged: (newvalue) async {
        setState(() {
          _selectedType = newvalue;
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
    );
  }

  Widget dropDownOperationButton(Operation operationData) {
    return DropdownButtonFormField<Operation>(
      decoration: InputDecoration(
        enabledBorder: InputBorder.none,
      ),
      hint: AutoSizeText(
        'نوع العملية',
        overflow: TextOverflow.ellipsis,
        textScaleFactor: MediaQuery.of(context).textScaleFactor,
        minFontSize: 9,
        style:
            Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.white),
      ),
      iconSize: 25,
      iconEnabledColor: Theme.of(context).accentColor,
      elevation: 8,
      dropdownColor: Theme.of(context).primaryColorLight,
      value: _selectedOperation,
      onChanged: (newvalue) async {
        setState(() {
          _selectedOperation = newvalue;
        });
      },
      // ignore: missing_return
      validator: (value) {
        if (value == null) {
          return 'اختر نوع العملية';
        }
      },
      onSaved: (val) => setState(() => _selectedOperation = val),
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
    );
  }

  Widget dropDownRegTypeButton(PropertyRegistrationType regTypeData) {
    return DropdownButtonFormField<PropertyRegistrationType>(
      decoration: InputDecoration(
        enabledBorder: InputBorder.none,
      ),
      hint: AutoSizeText(
        'نوع الملكية',
        overflow: TextOverflow.ellipsis,
        textScaleFactor: MediaQuery.of(context).textScaleFactor,
        minFontSize: 9,
        style:
            Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.white),
      ),
      iconSize: 25,
      iconEnabledColor: Theme.of(context).accentColor,
      elevation: 8,
      dropdownColor: Theme.of(context).primaryColorLight,
      value: _selectedRegType,
      onChanged: (newvalue) async {
        setState(() {
          _selectedRegType = newvalue;
        });
      },
      // ignore: missing_return
      validator: (PropertyRegistrationType? value) {
        if (value == null) {
          return 'اختر نوع الملكية';
        }
      },
      onSaved: (val) => setState(() => _selectedRegType = val),
      items: regTypeData.items
          .map<DropdownMenuItem<PropertyRegistrationType>>((op) {
        return DropdownMenuItem(
          value: op,
          child: AutoSizeText(
            op.name??"",
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
          maxLines: null,
          decoration: InputDecoration(
              labelText: name,
              labelStyle: Theme.of(context).textTheme.bodyText2),
          // ignore: missing_return
          validator: ( value) {
            if (valid == true && value!.isEmpty) {
              return 'هذا الحقل فارغ';
            }
          },
          onSaved: (val) => _propertyData[name] = val,
        ),
      ),
    );
  }

  Widget _buildTextFormField2(TypeDetail ty, TextInputType type) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: TextFormField(
          textAlign: TextAlign.right,
          textDirection: TextDirection.rtl,
          keyboardType: type,
          decoration: InputDecoration(
            labelText: ty.typeDetailName,
            labelStyle: Theme.of(context).textTheme.bodyText2!.copyWith(
                  color: Theme.of(context).accentColor,
                ),
          ),
          onSaved: (val) => val!.isNotEmpty
              ? _typeDetailsValues[ty.typeDetailId.toString()] = val
              : _typeDetailsValues[ty.typeDetailId.toString()] = 'غير مذكور',
        ),
      ),
    );
  }

  Widget _generatePrice() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).accentColor),
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.symmetric(vertical: 5),
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

  Widget _buildListOfDetails() {
    return Column(
      children: [
        _buildTextFormField('نوع الاكساء', TextInputType.multiline),
        _buildTextFormField('الملاحظات', TextInputType.multiline),
      ],
    );
  }

  void _submitForm(Auth authData) async {
    setUploadedImages();
    String m = ' زائرنا الكريم إن عملية النشر العقارية في التطبيق توازي نشر الإعلان' +
        ' في المكتب لذلك نود إعلامكم انه في حال بيع العقار من خلال المكتب أو التطبيق' +
        ' فسيتم استيفاء رسوم البيع المحددة في قانون البيوع العقارية في أراضي' +
        ' الجمهورية العربية السورية من خلال تحويل النسبة المحددة في القانون' +
        ' الى الحساب التجاري رقم 0403784951030 في البنك التجاري على' +
        ' أن يتكفل المكتب بالمعاملات القانونية لعملية البيع والشراء ولكم جزيل الشكر';
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    _typedetailsformkey.currentState!.save();

    if (_pickedLocation == null) {
      _pickedLocation = _curLocation;
    }

    setState(() {
      _isAdding = true;
    });
    int value;
    String te = _propertyData['السعر'];
    _generatedPrice = int.parse(te);
    if (_priceType == 'مليار') {
      _generatedPrice *= 1000000000;
    } else if (_priceType == 'مليون') {
      _generatedPrice *= 1000000;
    } else if (_priceType == 'ألف') {
      _generatedPrice *= 1000;
    }
    try {
      value = await Provider.of<Property>(context, listen: false).addProperty(
        title: _propertyData['عنوان الإعلان'],
        /*publishDate:
            '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}',*/
        operationTypeId: _selectedOperation!.operationId!,
        propertyTypeId: _selectedType!.typeId!,
        regType: _selectedRegType!.id!,
        price: '$_generatedPrice',
        location: _propertyData['الموقع بالتفصيل'],
        cityId: _selectedCity!.cityId!,
        coordinates: '${_pickedLocation!.latitude},${_pickedLocation!.longitude}',
        ownerId: authData.ownerId!,
        areasize: _propertyData['المساحة م²'],
        mainPhoto: mainPhoto??"",
        status: _propertyData['نوع الاكساء'],
        notes: _propertyData['الملاحظات'],
        //token: authData.token??"",
      );
    } on HttpException catch (error) {
      setState(() {
        _isAdding = false;
      });
      _showErrorDialog('فشل عملية إضافة العقار', error.toString(), () {
        Navigator.of(context).pop();
      });
      return;
    }
    if (value != null) {
      _typeDetailsValues.forEach((key, val) async {
        await Provider.of<PropertyItem>(context, listen: false)
            .addPropertyTypeDetails(
                detailsid: key, propertyid: value, detailvalue: val);
      });

      if (_uploadedImages.isEmpty) {
        _showSuccessDialog('تمت إضافة العقار \n $m');
      }
      if (_uploadedImages.isNotEmpty) _uploadImages(value);
    }
    setState(() {
      _isAdding = false;
    });
    Provider.of<PropertyItem>(context, listen: false).setImgs([]);
  }

  void _uploadImages(int propertyid) async {
    String m = ' زائرنا الكريم إن عملية النشر العقارية في التطبيق توازي نشر الإعلان' +
        ' في المكتب لذلك نود إعلامكم انه في حال بيع العقار من خلال المكتب أو التطبيق' +
        ' فسيتم استيفاء رسوم البيع المحددة في قانون البيوع العقارية في أراضي' +
        ' الجمهورية العربية السورية من خلال تحويل النسبة المحددة في القانون' +
        ' الى الحساب التجاري رقم 0403784951030 في البنك التجاري على' +
        ' أن يتكفل المكتب بالمعاملات القانونية لعملية البيع والشراء ولكم جزيل الشكر';
    setState(() {
      _isUploading = true;
    });
    try {
      await Provider.of<PropertyItem>(context, listen: false)
          .uploadImages(propertyid: propertyid, images: _uploadedImages);
    } catch (e) {
      print(e);
    }
    setState(() {
      _isUploading = false;
    });
    _showSuccessDialog('تمت إضافة العقار \n $m');
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

  Future<void> _selectOnMap() async {
    final selectedLocation = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        builder: (ctx) => MapToPickLocationScreen(),
      ),
    );
    setState(() {
      _pickedLocation = selectedLocation;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cityData = Provider.of<City>(context, listen: false);
    final typeData = Provider.of<Type>(context, listen: false);
    final operationData = Provider.of<Operation>(context, listen: false);
    final typeDetailsData = Provider.of<TypeDetails>(context, listen: false);
    final regtypeData =
        Provider.of<PropertyRegistrationType>(context, listen: false);
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
      body: _curLocation == null || _isLoadingTypeDetails == true
          ? Center(child: CircularProgressIndicator())
          : (_isAdding == false && _isUploading == false)
              ? Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
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
                                  child: dropDownTypeButton(
                                      typeData, typeDetailsData),
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
                                  child: dropDownOperationButton(operationData),
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
                                  child: dropDownRegTypeButton(regtypeData),
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
                                  child: dropDownCityButton(
                                    cityData,
                                  ),
                                ),
                                TextButton.icon(
                                  onPressed: _selectOnMap,
                                  icon: Icon(
                                    Icons.pin_drop_rounded,
                                    color: _pickedLocation == null
                                        ? Colors.red
                                        : Colors.green,
                                  ),
                                  label: _pickedLocation == null
                                      ? Text('حدّد موقع العقار على الخريطة')
                                      : Text('تم تحديد موقع العقار'),
                                ),
                                _buildTextFormField(
                                    'عنوان الإعلان', TextInputType.text,
                                    valid: true),
                                _buildTextFormField(
                                    'الموقع بالتفصيل', TextInputType.text,
                                    valid: true),
                                _buildTextFormField(
                                    'المساحة م²', TextInputType.number,
                                    valid: true),
                                Container(
                                  child: Consumer<TypeDetails>(
                                    builder: (ctx, data, child) => Form(
                                      key: _typedetailsformkey,
                                      child: Column(
                                        children: [
                                          ...data.typedetails.map(
                                            (e) => _buildTextFormField2(
                                                e, TextInputType.text),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
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
                          child: InputMainPhoto(setMainPhoto),
                        ),
                        Divider(
                          color: Theme.of(context).accentColor,
                          indent: 20,
                          endIndent: 20,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          height: containerHeight * .3,
                          child: ImageInput(),
                        ),
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 60, vertical: 20),
                          child: _submitButton(authData),
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
                        'تتم عملية إضافة العقار الآن',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
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
