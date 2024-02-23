import 'package:alshamel_new/helper/http_exception.dart';
import 'package:alshamel_new/models/property_models.dart/type_detail.dart';
import 'package:alshamel_new/providers/property_providers/property_item.dart';
import 'package:alshamel_new/providers/property_providers/property_registration_type.dart';
import 'package:alshamel_new/providers/property_providers/type_details.dart';
import 'package:alshamel_new/screens/property/map_pick_location_screen.dart';
import 'package:alshamel_new/screens/property/property_homepage_screen.dart';
import 'package:alshamel_new/widgets/property_widgets/carousel_slider_images.dart';
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
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
class PropertyUpdateScreen extends StatefulWidget {
  static const routName = '/upadte-property';
  final int propertyId;

  PropertyUpdateScreen(this.propertyId);

  @override
  _PropertyUpdateScreenState createState() => _PropertyUpdateScreenState();
}

class _PropertyUpdateScreenState extends State<PropertyUpdateScreen> {
  LatLng? _curLocation;
  bool _isLoading = true;

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
    Future.wait([
      Provider.of<Property>(context, listen: false)
          .getPropertyByID(widget.propertyId),
      Provider.of<Operation>(context, listen: false).getAllOperations(),
      Provider.of<PropertyRegistrationType>(context, listen: false)
          .getAllRegistrationType(),
      Provider.of<Type>(context, listen: false).getAllTypes(),
      Provider.of<City>(context, listen: false).getAllCities(),
      Provider.of<PropertyItem>(context, listen: false)
          .getImages(widget.propertyId),
      Provider.of<PropertyItem>(context, listen: false)
          .getPropertyDetails(widget.propertyId),
      Provider.of<TypeDetails>(context, listen: false).getTypeDetails()
    ]).then((_) => setState(() {
          _isLoading = false;
        }));
    _getcurrentplace();
    super.initState();
  }

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
        Navigator.of(context).pushReplacementNamed(PropertyHomePage.routeName);
      },
    );
  }

  Widget dropDownCityButton(City cityData, City oldCity) {
    return DropdownButtonFormField<City>(
      decoration: InputDecoration(
        enabledBorder: InputBorder.none,
      ),
      iconSize: 20,
      iconEnabledColor: Theme.of(context).accentColor,
      elevation: 8,

      hint: AutoSizeText(
        oldCity.cityName??"",
        textDirection: TextDirection.rtl,
        overflow: TextOverflow.ellipsis,
        textScaleFactor: MediaQuery.of(context).textScaleFactor,
        minFontSize: 9,
        style: Theme.of(context)
            .textTheme
            .bodyText2!
            .copyWith(color: Colors.white),
      ),
      dropdownColor: Theme.of(context).primaryColorLight,
      value: _selectedCity != null ? _selectedCity : oldCity,
      onChanged: (newvalue) async {
        setState(() {
          _selectedCity = newvalue;
        });
      },
      // ignore: missing_return

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

  Widget dropDownTypeButton(
      Type typeData, TypeDetails typeDetailsData, Type oldtype) {
    return DropdownButtonFormField<Type>(
      decoration: InputDecoration(
        enabledBorder: InputBorder.none,
      ),

      iconSize: 20,
      iconEnabledColor: Theme.of(context).accentColor,
      elevation: 8,
      hint: AutoSizeText(
        oldtype.typeName??"",
        overflow: TextOverflow.ellipsis,
        textScaleFactor: MediaQuery.of(context).textScaleFactor,
        minFontSize: 9,
        style: Theme.of(context)
            .textTheme
            .bodyText2!
            .copyWith(color: Colors.white),
      ),
      dropdownColor: Theme.of(context).primaryColorLight,
      value: _selectedType != null ? _selectedType : oldtype,
      // ignore: missing_return

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

  Widget dropDownOperationButton(
      Operation operationData, Operation oldOperation) {
    return DropdownButtonFormField<Operation>(
      decoration: InputDecoration(
        enabledBorder: InputBorder.none,
      ),
      hint: AutoSizeText(
        oldOperation.operationName??"",
        overflow: TextOverflow.ellipsis,
        textScaleFactor: MediaQuery.of(context).textScaleFactor,
        minFontSize: 9,
        style: Theme.of(context)
            .textTheme
            .bodyText2!
            .copyWith(color: Colors.white),
      ),
      iconSize: 25,
      iconEnabledColor: Theme.of(context).accentColor,
      elevation: 8,
      dropdownColor: Theme.of(context).primaryColorLight,
      value: _selectedOperation != null ? _selectedOperation : oldOperation,
      onChanged: (newvalue) async {
        setState(() {
          _selectedOperation = newvalue;
        });
      },
      // ignore: missing_return

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

  Widget dropDownRegTypeButton(
      PropertyRegistrationType regTypeData, PropertyRegistrationType oldReg) {
    return DropdownButtonFormField<PropertyRegistrationType>(
      decoration: InputDecoration(
        enabledBorder: InputBorder.none,
      ),
      hint: AutoSizeText(
        oldReg.name??"",
        overflow: TextOverflow.ellipsis,
        textScaleFactor: MediaQuery.of(context).textScaleFactor,
        minFontSize: 9,
        style: Theme.of(context)
            .textTheme
            .bodyText2!
            .copyWith(color: Colors.white),
      ),
      iconSize: 25,
      iconEnabledColor: Theme.of(context).accentColor,
      elevation: 8,
      dropdownColor: Theme.of(context).primaryColorLight,
      value: _selectedRegType != null ? _selectedRegType : oldReg,
      onChanged: (newvalue) async {
        setState(() {
          _selectedRegType = newvalue;
        });
      },
      // ignore: missing_return

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

  Widget _buildTextFormField(String name, TextInputType type, String oldValue,
      {bool valid = false}) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: TextFormField(
          autofocus: false,
          //controller: _textEditingController,
          //key: Key(oldValue),
          initialValue: oldValue,
          textAlign: TextAlign.right,
          textDirection: TextDirection.rtl,
          keyboardType: type,
          maxLines: null,
          decoration: InputDecoration(
              labelText: name,
              labelStyle: Theme.of(context).textTheme.bodyText2),
          // ignore: missing_return
          validator: (value) {
            if (valid == true && value!.isEmpty) {
              return 'هذا الحقل فارغ';
            }
          },
          onSaved: (val) => _propertyData[name] = val,
        ),
      ),
    );
  }

  Widget _buildTextFormField2(
      TypeDetail ty, TextInputType type, String oldValue) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: TextFormField(
          initialValue: oldValue,
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

  Widget _generatePrice(PropertyItem old) {
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
          _buildTextFormField('السعر القديم', TextInputType.number, old.price.toString()!,
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

  Widget _buildListOfDetails(PropertyItem old) {
    return Column(
      children: [
        _buildTextFormField('الحالة', TextInputType.multiline, old.status!),
        _buildTextFormField('الملاحظات', TextInputType.multiline, old.notes!),
      ],
    );
  }

  void _submitForm(Auth authData, PropertyItem p) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    _typedetailsformkey.currentState!.save();

    setState(() {
      _isAdding = true;
    });
    int value;
    String r = _propertyData['السعر القديم'];
    String te = r.split('.')[0];
    _generatedPrice = int.parse(te);
    if (_priceType == 'مليار') {
      _generatedPrice *= 1000000000;
    } else if (_priceType == 'مليون') {
      _generatedPrice *= 1000000;
    } else if (_priceType == 'ألف') {
      _generatedPrice *= 1000;
    } else if (_priceType == 'ليرة') {
      _generatedPrice *= 1;
    }

    try {
      value =
          await Provider.of<Property>(context, listen: false).updateProperty(
        oldid: p.propertyId.toString()??"",
        title: _propertyData['عنوان الإعلان'],
        publishDate:
            '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}',
        operationTypeId: _selectedOperation!.operationId.toString()??"",
        propertyTypeId: _selectedType!.typeId.toString()??"",
        regType: _selectedRegType!.id.toString()??"",
        price: '$_generatedPrice',
        location: _propertyData['الموقع بالتفصيل'],
        cityId: _selectedCity!.cityId!,
        coordinates: _pickedLocation != null
            ? '${_pickedLocation!.latitude},${_pickedLocation!.longitude}'!
            : p.coordinates!,
        ownerId: authData.ownerId!,
        areasize: _propertyData['المساحة'],
        mainPhoto: mainPhoto == null ? p.mainPhoto??"" : mainPhoto??"",
        status: _propertyData['الحالة'],
        notes: _propertyData['الملاحظات'],
        token: authData.token??"",
      );
    } on HttpException catch (error) {
      _showErrorDialog('فشل عملية تعديل العقار', error.toString(), () {
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
      _uploadImages(value);
    }
    setState(() {
      _isAdding = false;
    });
  }

  void _uploadImages(int propertyid) async {
    setUploadedImages();
    if (_uploadedImages.isEmpty) {
      _uploadedImages =
          Provider.of<PropertyItem>(context, listen: false).images;
    }
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
    _showSuccessDialog('تم استلام طلب التعديل .. انتظر الموافقة');
  }

  Widget _submitButton(Auth authData, PropertyItem p) {
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
        onPressed: () => _submitForm(authData, p));
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
    final oldProperty = Provider.of<Property>(context, listen: false).itemById;

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
    Operation? oldOperation;
    PropertyRegistrationType? oldRegType;
    Type? oldType;
    City? oldCity;
    if (oldProperty != null) {
      oldOperation = operationData.findById(oldProperty.operationTypeId!);
      oldRegType = regtypeData.findById(oldProperty.propertyRegestrationTypeId!);
      oldCity = cityData.findById(oldProperty.cityId!);
      oldType = typeData.findById(oldProperty.propertyTypeId!);
    }

    return Scaffold(
      appBar: appBar2,
      body: _curLocation == null
          ? Center(child: CircularProgressIndicator())
          : _isLoading == true
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
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 4.0,
                                        vertical: 4.0,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color:
                                            Theme.of(context).primaryColorLight,
                                      ),
                                      child: dropDownTypeButton(
                                          typeData, typeDetailsData, oldType!),
                                    ),
                                    Container(
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 4.0,
                                        vertical: 4.0,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color:
                                            Theme.of(context).primaryColorLight,
                                      ),
                                      child: dropDownOperationButton(
                                          operationData, oldOperation!),
                                    ),
                                    Container(
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 4.0,
                                        vertical: 4.0,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color:
                                            Theme.of(context).primaryColorLight,
                                      ),
                                      child: dropDownRegTypeButton(
                                          regtypeData, oldRegType!),
                                    ),
                                    Container(
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 4.0,
                                        vertical: 4.0,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color:
                                            Theme.of(context).primaryColorLight,
                                      ),
                                      child:
                                          dropDownCityButton(cityData, oldCity!),
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
                                          ? Text('عدّل موقع العقار على الخريطة')
                                          : Text('تم تعديل موقع العقار'),
                                    ),
                                    _buildTextFormField(
                                      'عنوان الإعلان',
                                      TextInputType.text,
                                      oldProperty.title??"",
                                      valid: true,
                                    ),
                                    _buildTextFormField(
                                        'الموقع بالتفصيل',
                                        TextInputType.text,
                                        oldProperty.location??"",
                                        valid: true),
                                    _buildTextFormField(
                                        'المساحة',
                                        TextInputType.number,
                                        oldProperty.areasize.toString()??"",
                                        valid: true),
                                    Consumer<TypeDetails>(
                                      builder: (ctx, data, child) => Form(
                                        key: _typedetailsformkey,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            ...data.typedetails.map(
                                                (e) => _buildTextFormField2(
                                                      e,
                                                      TextInputType.text,
                                                      Provider.of<PropertyItem>(
                                                              context,
                                                              listen: false)
                                                          .details[data
                                                              .typedetails
                                                              .indexOf(e)]
                                                          .value,
                                                    ))
                                          ],
                                        ),
                                      ),
                                    ),
                                    _buildListOfDetails(oldProperty),
                                    _generatePrice(oldProperty),
                                  ],
                                ),
                              ),
                            ),
                            Divider(
                              color: Theme.of(context).accentColor,
                              indent: 20,
                              endIndent: 20,
                            ),
                            oldProperty.mainPhoto!=null
                                ? Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30),
                                    height: containerHeight * .3,
                                    child: InputMainPhoto(setMainPhoto),
                                  )
                                : Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30, vertical: 10),
                                    height: containerHeight * .7,
                                    child: Column(
                                      children: [
                                        AutoSizeText(
                                          'أضف صورة جديدة لتعديل صورة العقار القديمة',
                                          textDirection: TextDirection.rtl,
                                          overflow: TextOverflow.ellipsis,
                                          textScaleFactor:
                                              MediaQuery.of(context)
                                                  .textScaleFactor,
                                          minFontSize: 9,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2!
                                              .copyWith(
                                                  color: Theme.of(context)
                                                      .primaryColor),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 30),
                                          height: containerHeight * .3,
                                          child:CachedNetworkImage(
                                            imageUrl:oldProperty.mainPhoto??"",
                                            cacheKey: oldProperty.mainPhoto!+DateTime.now().second.toString(),
                                            width: double.infinity,
                                            fit: BoxFit.fitWidth,
                                          ),

                                          /*Image.network(
                                            oldProperty.mainPhoto??"",
                                            width: double.infinity,
                                            fit: BoxFit.fitWidth,
                                          ),*/
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 30),
                                          height: containerHeight * .3,
                                          child: InputMainPhoto(setMainPhoto),
                                        )
                                      ],
                                    ),
                                  ),
                            Divider(
                              color: Theme.of(context).accentColor,
                              indent: 20,
                              endIndent: 20,
                            ),
                            Provider.of<PropertyItem>(context, listen: false)
                                    .images
                                    .isEmpty
                                ? Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30),
                                    height: containerHeight * .3,
                                    child: ImageInput(),
                                  )
                                : Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30),
                                    height: containerHeight * .7,
                                    child: Column(
                                      children: [
                                        AutoSizeText(
                                          'أضف صور جديدة لتعديل الصور القديمة',
                                          textDirection: TextDirection.rtl,
                                          overflow: TextOverflow.ellipsis,
                                          textScaleFactor:
                                              MediaQuery.of(context)
                                                  .textScaleFactor,
                                          minFontSize: 9,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2!
                                              .copyWith(
                                                  color: Theme.of(context)
                                                      .primaryColor),
                                        ),
                                        CarouselSliderImages(
                                          containerHeight: containerHeight * .3,
                                          images: Provider.of<PropertyItem>(
                                                  context,
                                                  listen: false)
                                              .images,
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 30),
                                          height: containerHeight * .3,
                                          child: ImageInput(),
                                        )
                                      ],
                                    ),
                                  ),
                            Container(
                              width: double.infinity,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 60, vertical: 20),
                              child: _submitButton(authData, oldProperty),
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
                            'تتم عملية جمع بيانات العقار الآن',
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          CircularProgressIndicator(),
                        ],
                      ),
                    ),
    );
  }
}
