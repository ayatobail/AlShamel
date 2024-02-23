import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:alshamel_new/helper/app_config.dart';
import 'package:alshamel_new/providers/property_providers/property_item.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:alshamel_new/helper/http_exception.dart';

class Property with ChangeNotifier {
  List<PropertyItem> _items = [];
  List<PropertyItem> _itemsByDate = [];
  List<PropertyItem> _itemsByViews = [];
  List<PropertyItem> _filtereditem = [];
  List<PropertyItem> _propertyByOwner = [];
  PropertyItem? _proItem;
  int noFilteredData = 0;

  List<PropertyItem> get items {
    return [..._items].reversed.toList();
    //return [..._items];
  }

  PropertyItem get itemById {
    return _proItem!;
  }

  List<PropertyItem> get propertyByOwner {
    return [..._propertyByOwner];
  }

  List<PropertyItem> get itemsByDate {
    return [..._itemsByDate];
  }

  List<PropertyItem> get itemsByViews {
    return [..._itemsByViews];
  }

  List<PropertyItem> get filteredItems {
    return [..._filtereditem];
  }

  //List<PropertyItem> get favoItems {}

  List<PropertyItem> get getAllPropertyOrderedByViews {
    _itemsByViews = items;
    _itemsByViews.sort((a, b) => b.views??0.compareTo(a.views??0));
    return _itemsByViews;
  }

  List<PropertyItem> get getPropertyforSale {
    return items
        .where((element) => element.operationTypeName == 'مبيع')
        .toList();
  }

  List<PropertyItem> getPropertySameCity(String cityName) {
    return items.where((element) => element.cityName == cityName).toList();
  }

  List<PropertyItem> get getAllPropertyOrderedByDate {
    _itemsByDate = items;
    _itemsByDate.sort((a, b) =>
        DateTime.parse(b.approveDate!).compareTo(DateTime.parse(a.approveDate!)));
    return _itemsByDate;
  }

  PropertyItem findById(int id) {
    return items.firstWhere((element) => element.propertyId == id);
  }

  bool setFilters({
    int? type,
    int? city,
    int? operation,
    int? regType,
    int? minAreaSize,
    int? maxAreaSize,
    int? minPrice,
    int? maxPrice,
    int? orderBy,
    List<PropertyItem>? filtered,
  }) {
    _filtereditem = [..._items].where((element) {
      var elementPrice = element.price!.split('.');

      return (minPrice != null
              ? (int.parse(elementPrice[0]) >= minPrice)
              : true) &&
          (maxPrice != null
              ? (int.parse(elementPrice[0]) <= maxPrice)
              : true) &&
          (minAreaSize != null
              ? (element.areasize! >= minAreaSize)
              : true) &&
          (maxAreaSize != null
              ? (element.areasize! <= maxAreaSize)
              : true) &&
          (city != null ? (element.cityId == city) : true) &&
          (type != null ? (element.propertyTypeId == type) : true) &&
          (operation != null ? (element.operationTypeId == operation) : true) &&
          (regType != null ? (element.propertyRegType == regType) : true);
    }).toList();
    _filtereditem.sort((a, b) {
      var priceA = a.price!.split('.');
      var priceB = b.price!.split('.');
      return int.parse(priceA[0]).compareTo(int.parse(priceB[0]));
    });
    if (orderBy == 0) {
      _filtereditem.reversed.toList();
    }
    filtered != null ? _filtereditem = filtered : print(_filtereditem.length);
    _filtereditem.sort((a, b) =>
        DateTime.parse(b.approveDate??"2023-11-20").compareTo(DateTime.parse(a.approveDate??"2023-11-20")));

    if (_filtereditem.length == 0) {
      noFilteredData = -1;
      notifyListeners();
      return false;
    } else {
      noFilteredData = 1;
      notifyListeners();
      return true;
    }
  }

  void clearFilters() {
    _filtereditem = [];
    notifyListeners();
  }

  Future<void> getAllProperty() async {
    final Uri url = Uri.parse(AppConfig.APP_BASE_URL +
        '/api/property/get_property');

    final response = await http.get(url);
    if (response.statusCode != 200) {
      throw HttpException('حدثت مشكلة مع السيرفر');
    }

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final List<PropertyItem> loadeditems = [];
      for (var unit in responseData) {
        loadeditems.add(
          PropertyItem.fromjson(unit),
        );
      }
      _items = loadeditems;
      notifyListeners();
    }
  }

  Future<List<PropertyItem>> getAllPropertyFake() async {
    final Uri url = Uri.parse(AppConfig.APP_BASE_URL +
        '/api/property/get_property');
    final response = await http.get(url);
    if (response.statusCode != 200) {
      throw HttpException('حدثت مشكلة مع السيرفر');
    }
    final responseData = json.decode(response.body);
    final List<PropertyItem> loadeditems = [];
    for (var unit in responseData) {
      loadeditems.add(
        PropertyItem.fromjson(unit),
      );
    }
    _items = loadeditems;
    //print(_items.length);
    notifyListeners();
    return _items;
  }

  Future<void> getAllPropertyByOwnerID(int id) async {
    final Uri url = Uri.parse(AppConfig.APP_BASE_URL +
        '/api/property/get_property_by_ownerId');
    final jsondata = {'id': id};
    final response = await http.post(url, body: jsonEncode(jsondata));
    if (response.statusCode != 200) {
      throw HttpException('حدثت مشكلة مع السيرفر');
    }
    final responseData = json.decode(response.body);
    final List<PropertyItem> loadeditems = [];
    for (var unit in responseData) {
      loadeditems.add(
        PropertyItem.fromjson(unit),
      );
    }
    _propertyByOwner = loadeditems;
    notifyListeners();
  }

  Future<int> addProperty({
    required String title,
    //required String publishDate,
    required int operationTypeId,
    required int propertyTypeId,
    required int regType,
    required String price,
    required String location,
    required int cityId,
    required String coordinates,
    required int ownerId,
    required String areasize,
    required String mainPhoto,
    required String status,
    required String notes,
    //required String token,
  }) async {
    final json = {
      "title":title,
      "operationTypeId":operationTypeId,
      "propertyTypeId":propertyTypeId,
      "price":price,
      "location":location,
      "countryId":1,
      "cityId":cityId,
      "coordinates":coordinates,
      "ownerId":ownerId,
      "areasize":areasize,
      "notes":notes,
      "property_regestration_type_id":regType,
      "currency":"1",
      "old_property_id":"0",
      "mainPhoto":mainPhoto,
      "status":status


    };
    final Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      //'Token': token
    };

    final Uri url = Uri.parse(AppConfig.APP_BASE_URL +
        '/api/property/add_property');
    try {
      final response =
          await http.post(url, body: jsonEncode(json));

      if (response.statusCode != 201) {
        print(response.statusCode);
        throw HttpException('حدث خطأ أثناء عمليةإدخال عقار ');
      }
      final data = jsonDecode(response.body);
      notifyListeners();
      return data['id'];
    } on SocketException {
      throw HttpException('لا يوجد اتصال بالانترنت');
    } catch (e) {
      print(e);
      throw HttpException('حدثت مشكلة مع السيرفر');
    }
  }

  Future<void> getPropertyByID(int id) async {
    final Uri url = Uri.parse(AppConfig.APP_BASE_URL +
        '/api/property/get_property_by_Id');
    final jsonData = {'id': id};
    try {
      final response = await http.post(url, body: jsonEncode(jsonData));
      if (response.statusCode != 200) {
        throw HttpException('حدثت مشكلة مع السيرفر');
      }
      final responseData = json.decode(response.body);
      final List<PropertyItem> loadeditems = [];
      for (var unit in responseData) {
        loadeditems.add(
          PropertyItem.fromjson(unit),
        );
      }
      _proItem = loadeditems[0];
    } on SocketException {
      throw HttpException('لا يوجد اتصال بالانترنت');
    } catch (e) {
      throw HttpException('حدثت مشكلة مع السيرفر');
    }
  }

  Future<void> deleteProperty({
    required int proId,
  }) async {
    print(proId);
    int deletedIndex =
        _propertyByOwner.indexWhere((element) => element.propertyId == proId);

    var deletedProperty = _propertyByOwner[deletedIndex];
    _propertyByOwner.removeWhere((element) => element.propertyId == proId);
    notifyListeners();
    try {
      final Uri url = Uri.parse(AppConfig.APP_BASE_URL +
          '/api/property/delete_property');
      final json = {
        'id': proId,
      };
      final response = await http.post(
        url,
        body: jsonEncode(json),
      );
      if (response.statusCode != 200) {
        _propertyByOwner.insert(deletedIndex, deletedProperty);
        notifyListeners();
        throw HttpException('حدث خطأ أثناء عملية حذف العقار ');
      }
    } on SocketException {
      _propertyByOwner.insert(deletedIndex, deletedProperty);
      throw HttpException('لا يوجد اتصال بالانترنت');
    } catch (e) {
      _propertyByOwner.insert(deletedIndex, deletedProperty);
      throw HttpException('حدثت مشكلة مع السيرفر');
    }
  }

  Future<int> updateProperty({
    required String oldid,
    required String title,
    required String publishDate,
    required String operationTypeId,
    required String propertyTypeId,
    required String regType,
    required String price,
    required String location,
    required int cityId,
    required String coordinates,
    required int ownerId,
    required String areasize,
    required String mainPhoto,
    required String status,
    required String notes,
    required String token,
  }) async {
    final json = {
      'id': oldid,
      'title': title,
      //'publishDate': publishDate,
      'operationTypeId': operationTypeId,
      'propertyTypeId': propertyTypeId,
      'price': price,
      'location': location,
      'countryId':"1",
      'cityId': cityId,
      'coordinates': coordinates,
      'ownerId': ownerId,
      'areasize': areasize,
      'status': status,
      'notes': notes,
      'property_regestration_type_id': regType,
      "currency":"1",
      'mainPhoto': mainPhoto,
      'status':status

    };
    final Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Token': token
    };
    try {
      final Uri url = Uri.parse(AppConfig.APP_BASE_URL +
          '/api/property/edit_property');

      final response =
          await http.post(url, body: jsonEncode(json));

      if (response.statusCode != 200) {
        throw HttpException('حدث خطأ أثناء تعديل عقار ');
      }
      final data = jsonDecode(response.body);
      notifyListeners();
      return data[0]['id'];
    } on SocketException {
      throw HttpException('لا يوجد اتصال بالانترنت');
    } catch (e) {
      throw HttpException('حدثت مشكلة مع السيرفر');
    }
  }

  List<PropertyItem> searchResult(String query) {
    return items.where((element) => element.title!.contains(query)).toList();
  }
}
