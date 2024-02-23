import 'dart:io';

import 'package:alshamel_new/helper/app_config.dart';
import 'package:alshamel_new/helper/http_exception.dart';
import 'package:alshamel_new/providers/car_providers/car_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Cars with ChangeNotifier {
  List<CarItem> _items = [];
  List<CarItem> _filtereditem = [];
  List<CarItem> _newlyCars = [];
  List<CarItem> _carByOwner = [];

  List<CarItem> get items {
    return [..._items].reversed.toList();
  }

  List<CarItem> get filtereditems {
    return [..._filtereditem];
  }

  List<CarItem> get newlyCars {
    _newlyCars = items;
    _newlyCars
        .sort((a, b) => (b.manufactureyear)!.compareTo((a.manufactureyear!)));
    return _newlyCars;
  }

  CarItem findByIdForOwner(int id) {
    return carsByOwner.firstWhere((element) => element.id == id);
  }

  CarItem findById(int id) {
    return items.firstWhere((element) => element.id == id);
  }

  List<CarItem> getCarsSameCity(int cityid) {
    return items.where((element) => element.cityid == cityid).toList();
  }

  List<CarItem> getSameType(int typeid) {
    return items.where((element) => element.typeid == typeid).toList();
  }

  List<CarItem> carByOwnerID(int id) {
    _carByOwner = items.where((element) => element.ownerid == id).toList();
    return [..._carByOwner];
  }

  List<CarItem> get carsByOwner {
    return [..._carByOwner];
  }

  List<CarItem> searchResult(String query) {
    return items.where((element) => element.title!.contains(query)).toList();
  }

  Future<void> getAllCars() async {
    final Uri url = Uri.parse(
        AppConfig.APP_BASE_URL + '/api/cars/get_car');
    final response = await http.get(url);
    if (response.statusCode != 200) {
      throw HttpException('حدثت مشكلة مع السيرفر');
    }
    final responseData = json.decode(response.body);
    final List<CarItem> loadeditems = [];
    for (var unit in responseData) {
      loadeditems.add(
        CarItem.fromjson(unit),
      );
    }
    _items = loadeditems;
    notifyListeners();
  }

  Future<void> addCar({
    required String cartitle,
    required int cartypeid,
    required String carmanufactureid,
    required String modelid,
    required String manufactureyear,
    required String registeryear,
    required String km,
    required String price,
    required String mainphoto,
    required String ownerid,
    required String descriptions,
    required String operationtypeid,
    required int cityid,
    required String address,
    String? token,
    List<String>? images,
    Map<String, dynamic>? details,
  }) async {
    final json = {
      "cartname": cartitle,
      "cartypeid": cartypeid,
      "carmanufactureid": carmanufactureid,
      "modelid": modelid,
      "manufactureyear": manufactureyear,
      "registeryear": registeryear,
      "km": km,
      "price": price,
      "mainphoto": mainphoto,
      "ownerid": ownerid,
      "descriptions": descriptions,
      "operationtypeid": operationtypeid,
      "cityid": cityid,
      "address": address,
      "currency":null,
      "details": details,
      "images": images,

    };
    final Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      //'Token': token
    };
    try {
      final Uri url = Uri.parse(AppConfig.APP_BASE_URL +
          '/api/cars/add_car');
      final response =
          await http.post(url,  body: jsonEncode(json));
      if (response.statusCode != 201) {
        throw HttpException('حدث خطأ أثناء عمليةإدخال سيارة ');
      }
      notifyListeners();
    } on SocketException {
      throw HttpException('لا يوجد اتصال بالانترنت');
    } catch (e) {
      throw HttpException('حدثت مشكلة مع السيرفر');
    }
  }

  bool setFilters({
    int? type,
    int? city,
    int? year,
    int? operationtype,
    String? manufacture,
    String? model,
    int? minkm,
    int? maxkm,
    int? minPrice,
    int? maxPrice,
    int? orderBy,
    List<CarItem>? filtered,
  }) {
    _filtereditem = [..._items].where((element) {
      var elementPrice = element.price.toString()!.split('.');
      return (minPrice != null
              ? (int.parse(elementPrice[0]) >= minPrice)
              : true) &&
          (maxPrice != null
              ? (int.parse(elementPrice[0]) <= maxPrice)
              : true) &&
          (minkm != null
              ? (int.parse(element.km.toString()!) >= minkm)
              : true) &&
          (maxkm != null
              ? (int.parse(element.km.toString()!) <= maxkm)
              : true) &&
          (city != null ? (element.cityid == city) : true) &&
          (type != null ? (element.typeid == type) : true) &&
          (manufacture != null ? (element.companyname == manufacture) : true) &&
          (model != null ? (element.modelname == model) : true) &&
          (operationtype != null
              ? (element.operationtypeid == operationtype)
              : true) &&
          (year != null ? (element.manufactureyear == year.toString()) : true);
    }).toList();
    _filtereditem.sort((a, b) {
      var priceA = a.price.toString()!.split('.');
      var priceB = b.price.toString()!.split('.');
      return int.parse(priceA[0]).compareTo(int.parse(priceB[0]));
    });
    if (orderBy == 0) {
      _filtereditem.reversed;
    }
    filtered != null ? _filtereditem = filtered : print(_filtereditem.length);

    notifyListeners();
    if (_filtereditem.isNotEmpty) return true;
    return false;
  }

  void clearFilters() {
    _filtereditem = [];
    notifyListeners();
  }

  Future<void> deleteCar({
    required int carid,
  }) async {
    int deletedIndex = _carByOwner.indexWhere((element) => element.id == carid);
    print(deletedIndex);
    var deletedCar = _carByOwner[deletedIndex];
    _carByOwner.removeWhere((element) => element.id == carid);
    notifyListeners();
    final Uri url = Uri.parse(
        AppConfig.APP_BASE_URL + '/api/cars/delete_car');
    final json = {
      'id': carid,
    };
    final response = await http.post(
      url,
      body: jsonEncode(json),
    );
    if (response.statusCode != 200) {
      _carByOwner.insert(deletedIndex, deletedCar);
      notifyListeners();
      throw HttpException('حدث خطأ أثناء عملية حذف العقار ');
    }
  }

  Future<void> updateCar({
    required int carid,
    required String cartitle,
    required String cartypeid,
    required String carmanufactureid,
    required String modelid,
    required String manufactureyear,
    required String registeryear,
    required String km,
    required String price,
    required String mainphoto,
    required String ownerid,
    required String descriptions,
    required String operationtypeid,
    required int cityid,
    required String address,
    required String token,
    required List<String> images,
    required Map<String, dynamic> details,
  }) async {
    final json = {
      'id': carid,
      'cartname': cartitle,
      'cartypeid': cartypeid,
      'carmanufactureid': carmanufactureid,
      'modelid': modelid,
      'manufactureyear': manufactureyear,
      'registeryear': registeryear,
      'km': km,
      'price': price,
      'mainphoto': mainphoto,
      'ownerid': ownerid,
      'descriptions': descriptions,
      'operationtypeid': operationtypeid,
      'cityid': cityid,
      'address': address,
      'currency':"1",
      'details': details,
      'images': images
    };
    final Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Token': token
    };
    final Uri url = Uri.parse(AppConfig.APP_BASE_URL +
        '/api/cars/edit_car');
    final response =
        await http.post(url, body: jsonEncode(json));
    if (response.statusCode != 200) {
      throw HttpException('حدث خطأ أثناء عملية تعديل مركبة ');
    }
    notifyListeners();
  }
}
