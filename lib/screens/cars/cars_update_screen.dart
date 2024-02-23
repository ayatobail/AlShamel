import 'package:alshamel_new/helper/http_exception.dart';
import 'package:alshamel_new/models/cars_models/car_type_detail.dart';
import 'package:alshamel_new/providers/car_providers/car_item.dart';
import 'package:alshamel_new/providers/car_providers/car_manufacture.dart';
import 'package:alshamel_new/providers/car_providers/car_models.dart';
import 'package:alshamel_new/providers/car_providers/car_operation_type.dart';
import 'package:alshamel_new/providers/car_providers/car_type.dart';
import 'package:alshamel_new/providers/car_providers/car_type_details.dart';
import 'package:alshamel_new/providers/car_providers/cars.dart';
import 'package:alshamel_new/widgets/cars_widgets/car_input_main_photo.dart';
import 'package:alshamel_new/screens/cars/cars_homepage_screen.dart';
import 'package:alshamel_new/widgets/cars_widgets/car_input_images.dart';
import 'package:alshamel_new/widgets/property_widgets/carousel_slider_images.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:alshamel_new/providers/property_providers/city.dart';
import 'package:alshamel_new/providers/auth.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CarsUpdateScreen extends StatefulWidget {
  final int carid;
  CarsUpdateScreen(this.carid);

  @override
  _CarsUpdateScreenState createState() => _CarsUpdateScreenState();
}

class _CarsUpdateScreenState extends State<CarsUpdateScreen> {
  late CarItem oldCar;
  bool _isLoadingImgADetails = true;
  bool _isLoading = false;
  bool _isAdding = false;
  bool _isUploading = false;

  @override
  void initState() {
    Future.wait(
      [
        Provider.of<CarTypeDetails>(context, listen: false).getCarTypeDetails(),
        Provider.of<CarItem>(context, listen: false)
            .getCarDetails(widget.carid),
        Provider.of<CarItem>(context, listen: false).getImages(
          widget.carid,
        )
      ],
    ).then((_) => setState(() {
          _isLoadingImgADetails = false;
        }));
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _carData = {};
  final Map<String, dynamic> _typeDetailsValues = {};
  List<String> _uploadedImages = [];
  String? mainPhoto;

  City? _selectedCity;
  CarType? _selectedType;
  CarManufacture? _selectedManufacture;
  CarOperationType? _selectedOperation;
  CarModels? _selectedModel;
  int? _selectedYear;

  List<String> prices = ['مليار', 'مليون', 'ألف', 'ليرة'];
  late int _generatedPrice;
  String? _priceType;

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
          _buildTextFormField(
              'السعر القديم', TextInputType.number, oldCar.price.toString()!,
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
                _priceType = newvalue;
              });
            },
            onSaved: (val) => setState(() => {_priceType = val}),
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

  List<int> getYearsInBeteween() {
    List<int> years = [];
    for (int i = 1960; i <= DateTime.now().year; i++) {
      years.add(i);
    }
    return years;
  }

  void setUploadedImages(List<String> images) {
    _uploadedImages = images;
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
        Navigator.of(context).pushReplacementNamed(CarsHomePage.routeName);
        //Navigator.of(context).pushNamed(CarsHomePage.routeName);
      },
    );
  }

  Widget dropDownYearButton() {
    return DropdownButtonFormField<int>(
      decoration: InputDecoration(
        enabledBorder: InputBorder.none,
      ),
      isExpanded: true,
      iconSize: 25,
      iconEnabledColor: Theme.of(context).accentColor,
      elevation: 8,
      hint: AutoSizeText(
        oldCar.manufactureyear.toString()??"",
        overflow: TextOverflow.ellipsis,
        textScaleFactor: MediaQuery.of(context).textScaleFactor,
        minFontSize: 9,
        style:
            Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.white),
      ),
      dropdownColor: Theme.of(context).primaryColorLight,
      value: _selectedYear,
      onChanged: (newvalue) async {
        setState(() {
          _selectedYear = newvalue;
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
    );
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
        oldCar.cityname??"",
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

  Widget dropDownModelButton() {
    return DropdownButtonFormField<CarModels>(
      decoration: InputDecoration(
        enabledBorder: InputBorder.none,
      ),
      //isDense: true,
      iconSize: 20,
      iconEnabledColor: Theme.of(context).accentColor,
      elevation: 8,

      hint: AutoSizeText(
        oldCar.modelname??"",
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
          _selectedModel = newvalue;
        });
      },
      // ignore: missing_return
      validator: (CarModels? value) {
        if (_selectedModel == null) {
          return 'اختر موديل المركبة';
        }
      },
      onSaved: (val) => setState(() => _selectedModel = val),
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
    );
  }

  Widget dropDownTypeButton(CarType typeData, CarTypeDetails typeDetailsData) {
    return DropdownButtonFormField<CarType>(
      decoration: InputDecoration(
        enabledBorder: InputBorder.none,
      ),

      iconSize: 20,
      iconEnabledColor: Theme.of(context).accentColor,
      elevation: 8,
      hint: AutoSizeText(
        oldCar.typename??"",
        overflow: TextOverflow.ellipsis,
        textScaleFactor: MediaQuery.of(context).textScaleFactor,
        minFontSize: 9,
        style:
            Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.white),
      ),
      dropdownColor: Theme.of(context).primaryColorLight,
      value: _selectedType,
      // ignore: missing_return

      onSaved: (val) => setState(() => _selectedType = val),
      onChanged: (newvalue) async {
        setState(() {
          _selectedType = newvalue;
        });
      },
      items: typeData.carTypes.map<DropdownMenuItem<CarType>>((t) {
        return DropdownMenuItem(
          value: t,
          child: AutoSizeText(
            t.typename??"",
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

  Widget dropDownOperationButton(CarOperationType operationData) {
    return DropdownButtonFormField<CarOperationType>(
      decoration: InputDecoration(
        enabledBorder: InputBorder.none,
      ),
      hint: AutoSizeText(
        oldCar.operationtypename??"",
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

      onSaved: (val) => setState(() => _selectedOperation = val),
      items: operationData.carOperationTypes
          .map<DropdownMenuItem<CarOperationType>>((op) {
        return DropdownMenuItem(
          value: op,
          child: AutoSizeText(
            op.operationtype??"",
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

  Widget dropDownCarManufactureButton(CarManufacture manufactureData) {
    return DropdownButtonFormField<CarManufacture>(
      decoration: InputDecoration(
        enabledBorder: InputBorder.none,
      ),
      isExpanded: true,
      iconSize: 25,
      iconEnabledColor: Theme.of(context).accentColor,
      elevation: 8,
      hint: AutoSizeText(
        oldCar.companyname??"",
        overflow: TextOverflow.ellipsis,
        textScaleFactor: MediaQuery.of(context).textScaleFactor,
        minFontSize: 9,
        style:
            Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.white),
      ),
      dropdownColor: Theme.of(context).primaryColorLight,
      value: _selectedManufacture,
      onChanged: (newvalue) async {
        setState(() {
          _selectedManufacture = newvalue;
          _selectedModel = null;
        });
        try {
          setState(() {
            _isLoading = true;
          });
          await Provider.of<CarModels>(context, listen: false)
              .getModelsByManufactureID(_selectedManufacture!.manufactureid.toString()??"");
        } on HttpException catch (error) {
          _showErrorDialog(
            'فشل عملية جلب الموديلات',
            error.toString(),
            () {
              Navigator.of(context).pop();
            },
          );
        } catch (error) {
          _showErrorDialog('فشل عملية جلب الموديلات', error.toString(), () {
            Navigator.of(context).pop();
          });
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
          initialValue: oldValue,
          textAlign: TextAlign.right,
          textDirection: TextDirection.rtl,
          keyboardType: type,
          decoration: InputDecoration(
              labelText: name,
              labelStyle: Theme.of(context).textTheme.bodyText2),
          // ignore: missing_return
          validator: (String? value) {
            if (valid == true && value!.isEmpty) {
              return 'هذا الحقل فارغ';
            }
          },
          onSaved: (val) => _carData[name] = val,
        ),
      ),
    );
  }

  Widget _buildDetailsTextFormField(
      CarTypeDetail ty, TextInputType type, String oldValue) {
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
              labelText: ty.detailsname,
              labelStyle: Theme.of(context).textTheme.bodyText2!.copyWith(
                    color: Theme.of(context).accentColor,
                  ),
            ),
            onSaved: (val) => val!.isNotEmpty
                ? _typeDetailsValues[ty.detailsid.toString()!] = val
                : _typeDetailsValues[ty.detailsid.toString()!] = 'غير مذكور'),
      ),
    );
  }

  Widget _buildListOfDetails() {
    return Column(
      children: [
        _buildTextFormField('عنوان الإعلان', TextInputType.text, oldCar.title??"",
            valid: true),
        _buildTextFormField(
            'الموقع بالتفصيل', TextInputType.text, oldCar.address??""),
        _buildTextFormField(
            'سنة تسجيل المركبة', TextInputType.number, oldCar.registeryear.toString()??""),
        _buildTextFormField(
            'المسافة المقطوعة', TextInputType.number, oldCar.km.toString()??""),
        _buildTextFormField('الوصف', TextInputType.text, oldCar.descriptions??""),
      ],
    );
  }

  void _submitForm(Auth authData, CarItem oldCar) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    if (_uploadedImages.isEmpty) {
      _uploadedImages = Provider.of<CarItem>(context, listen: false).images;
    }
    setState(() {
      _isAdding = true;
    });
    print(_carData['السعر القديم']);
    print(_carData['عنوان الإعلان']);
    print(_selectedType != null ? _selectedType!.typeid : oldCar.typeid);
    String te = _carData['السعر القديم'];
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
      await Provider.of<Cars>(context, listen: false).updateCar(
        carid: oldCar.id!,
        cartitle: _carData['عنوان الإعلان'],
        cartypeid: _selectedType != null ? _selectedType!.typeid.toString()! : oldCar.typeid.toString()!,
        carmanufactureid: _selectedManufacture != null
            ? _selectedManufacture!.manufactureid.toString()!
            : oldCar.manufactureid.toString()!,
        modelid:
            _selectedModel != null ? _selectedModel!.modelid!.toString() : oldCar.modelid.toString()!,
        manufactureyear:
            _selectedYear != null ? '$_selectedYear'! : oldCar.manufactureyear.toString()!,
        registeryear: _carData['سنة تسجيل المركبة'],
        km: _carData['المسافة المقطوعة'],
        price: '$_generatedPrice',
        mainphoto: mainPhoto != null ? mainPhoto??"" : oldCar.mainphoto??"",
        ownerid: authData.ownerId.toString()??"",
        descriptions: _carData['الوصف'],
        operationtypeid: _selectedOperation != null
            ? _selectedOperation!.operationid.toString()!
            : oldCar.operationtypeid.toString()!,
        cityid: _selectedCity != null ? _selectedCity!.cityId! : oldCar.cityid!,
        address: _carData['الموقع بالتفصيل'],
        token: authData.token??"",
        images: _uploadedImages,
        details: _typeDetailsValues,
      );
      _showSuccessDialog('تم تعديل المركبة');
    } on HttpException catch (error) {
      print(error.message);
      _showErrorDialog('فشل عملية تعديل المركبة', error.message.toString(), () {
        Navigator.of(context).pop();
      });
      return;
    } catch (error) {
      _showErrorDialog('فشل عملية تعديل المركبة', error.toString(), () {
        Navigator.of(context).pop();
      });
      return;
    } finally {
      setState(() {
        _isAdding = false;
      });
    }
  }

  Widget _submitButton(Auth authData, CarItem oldCar) {
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
        onPressed: () => _submitForm(authData, oldCar));
  }

  @override
  Widget build(BuildContext context) {
    final cityData = Provider.of<City>(context, listen: false);
    final cartypeData = Provider.of<CarType>(context, listen: false);
    final typeDetailsData = Provider.of<CarTypeDetails>(context, listen: false);
    final carmanufactureData =
        Provider.of<CarManufacture>(context, listen: false);
    final caroperationData =
        Provider.of<CarOperationType>(context, listen: false);
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

    oldCar = Provider.of<Cars>(context, listen: false)
        .findByIdForOwner(widget.carid);

    return Scaffold(
      appBar: appBar2,
      body: _isLoadingImgADetails
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: _isLoading == true
                    ? Center(child: CircularProgressIndicator())
                    : Column(
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
                                      color:
                                          Theme.of(context).primaryColorLight,
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
                                      color:
                                          Theme.of(context).primaryColorLight,
                                    ),
                                    child: dropDownTypeButton(
                                        cartypeData, typeDetailsData),
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
                                      color:
                                          Theme.of(context).primaryColorLight,
                                    ),
                                    child: dropDownCarManufactureButton(
                                      carmanufactureData,
                                    ),
                                  ),
                                  _selectedManufacture == null
                                      ? Container()
                                      : Container(
                                          padding:
                                              const EdgeInsets.only(left: 10.0),
                                          margin: const EdgeInsets.symmetric(
                                            horizontal: 4.0,
                                            vertical: 4.0,
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Theme.of(context)
                                                .primaryColorLight,
                                          ),
                                          child: dropDownModelButton(),
                                        ),
                                  Container(
                                    padding: const EdgeInsets.only(left: 10.0),
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 4.0,
                                      vertical: 4.0,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color:
                                          Theme.of(context).primaryColorLight,
                                    ),
                                    child: dropDownYearButton(),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(left: 10.0),
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
                                        caroperationData),
                                  ),
                                  _buildListOfDetails(),
                                  Container(
                                    child: Column(
                                      //key: _formKey,
                                      children: [
                                        ...typeDetailsData.cartypedetails.map(
                                          (e) => _buildDetailsTextFormField(
                                              e,
                                              TextInputType.text,
                                              Provider.of<CarItem>(context,
                                                      listen: false)
                                                  .detailsvalues[typeDetailsData
                                                      .cartypedetails
                                                      .indexOf(e)]
                                                  .value),
                                        )
                                      ],
                                    ),
                                  ),
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
                          oldCar.mainphoto!.isEmpty
                              ? Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30),
                                  height: containerHeight * .3,
                                  child: CarInputMainPhoto(setMainPhoto),
                                )
                              : Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 10),
                                  height: containerHeight * .7,
                                  child: Column(
                                    children: [
                                      AutoSizeText(
                                        'أضف صورة جديدة لتعديل صورة المركبة القديمة',
                                        textDirection: TextDirection.rtl,
                                        overflow: TextOverflow.ellipsis,
                                        textScaleFactor: MediaQuery.of(context)
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
                                        child:
                                        CachedNetworkImage(
                                          imageUrl: oldCar.mainphoto??"",
                                          cacheKey: oldCar.mainphoto!+DateTime.now().second.toString(),
                                          width: double.infinity,
                                          fit: BoxFit.fitWidth,
                                        ),
                                        /*Image.network(
                                          oldCar.mainphoto??"",
                                          width: double.infinity,
                                          fit: BoxFit.fitWidth,
                                        ),*/
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 30),
                                        height: containerHeight * .3,
                                        child: CarInputMainPhoto(setMainPhoto),
                                      )
                                    ],
                                  ),
                                ),
                          Divider(
                            color: Theme.of(context).accentColor,
                            indent: 20,
                            endIndent: 20,
                          ),
                          Provider.of<CarItem>(context, listen: false)
                                  .images
                                  .isEmpty
                              ? Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30),
                                  height: containerHeight * .3,
                                  child: CarImageInput(setUploadedImages),
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
                                        textScaleFactor: MediaQuery.of(context)
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
                                        images: Provider.of<CarItem>(context,
                                                listen: false)
                                            .images,
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 30),
                                        height: containerHeight * .3,
                                        child: CarImageInput(setUploadedImages),
                                      )
                                    ],
                                  ),
                                ),
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 60, vertical: 20),
                            child: (_isAdding == false && _isUploading == false)
                                ? _submitButton(authData, oldCar)
                                : Center(
                                    child: CircularProgressIndicator(),
                                  ),
                          )
                        ],
                      ),
              ),
            ),
    );
  }
}
