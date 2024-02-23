import 'dart:io';

import 'package:alshamel_new/helper/app_config.dart';
import 'package:alshamel_new/helper/http_exception.dart';
import 'package:alshamel_new/providers/used_items_providers/used_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UsedItems with ChangeNotifier {
  List<UsedItem> _items = [];
  List<UsedItem> _itemsByOwner = [];
  List<UsedItem> _filtereditem = [];
  late UsedItem itemById;

  List<UsedItem> get items {
    return [..._items].reversed.toList();
  }

  List<UsedItem> get filtereditems {
    return [..._filtereditem];
  }

  List<UsedItem> usedItemsByOwnerID(int id) {
    _itemsByOwner = items.where((element) => element.ownerid == id).toList();
    return [..._itemsByOwner];
  }

  UsedItem findByIdForOwner(int id) {
    return _itemsByOwner.firstWhere((element) => element.useditemsid == id);
  }

  List<UsedItem> get itemsByOwner {
    return [..._itemsByOwner];
  }

  List<UsedItem> get itemsByViews {
    List<UsedItem> _itemsByViews = items;
    _itemsByViews.sort((a, b) => b.views??0.compareTo(a.views??0));
    return _itemsByViews;
  }

  Future<void> getAllUsedItems() async {
    final Uri url = Uri.parse(AppConfig.APP_BASE_URL +
        '/api/Ads/get_Ads');
    final response = await http.get(url);
    if (response.statusCode != 200) {
      throw HttpException('حدثت مشكلة مع السيرفر');
    }
    final responseData = json.decode(response.body);
    final List<UsedItem> loadeditems = [];
    for (var unit in responseData) {
      loadeditems.add(
        UsedItem.fromjson(unit),
      );
    }
    _items = loadeditems;
    notifyListeners();
  }

  List<UsedItem> searchResult(String query) {
    print(
        'Search Result ======= ${items.where((element) => element.title!.contains(query)).toList().length}');
    return items.where((element) => element.title!.contains(query)).toList();
  }

  List<UsedItem> getUsedItemsSameCategory(int typeid) {
    return items.where((element) => element.itemtypeid == typeid).toList();
  }

  Future<void> addUsedItem({
    required String title,
    required int cityid,
    required int itemtypeid,
    //required String addeddate,
    required int ownerid,
    required String price,
    required String description,
    required String mainphoto,
    required String dimensions,
    //required String token,
  }) async {
    final json = {
      "title":title,
      "type_id":itemtypeid,
      "ownerid":ownerid,
      "price":price,
      "description":description,
      "country_id":1,
      "city_id":cityid,
      "currency":"1",
      "dimensions":dimensions,
      "mainPhoto":mainphoto
    };
   final Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
     // 'Token': token
    };

    final Uri url = Uri.parse(AppConfig.APP_BASE_URL +
        '/api/Ads/add_Ads');
    try {
      final response =
          await http.post(url ,body: jsonEncode(json));

      if (response.statusCode != 200) {
        print(response.statusCode);
        throw HttpException('حدث خطأ أثناء عمليةإدخال أداة مستعملة ');
      }
      notifyListeners();
    } on SocketException {
      throw HttpException('لا يوجد اتصال بالانترنت');
    } catch (e) {
      throw HttpException('حدثت مشكلة مع السيرفر');
    }
  }

  Future<void> getUsedItemByID(int id) async {
    final Uri url = Uri.parse(AppConfig.APP_BASE_URL +
        '/api/Ads/get_Ads_by_ad_id');
    final jsonData = {'id': id};
    try {
      final response = await http.post(url, body: jsonEncode(jsonData));
      if (response.statusCode != 200) {
        throw HttpException('حدثت مشكلة مع السيرفر');
      }
      final responseData = json.decode(response.body);
      final List<UsedItem> loadeditems = [];
      for (var unit in responseData) {
        loadeditems.add(
          UsedItem.fromjson(unit),
        );
      }
      itemById = loadeditems[0];
    } on SocketException {
      throw HttpException('لا يوجد اتصال بالانترنت');
    } catch (e) {
      throw HttpException('حدثت مشكلة مع السيرفر');
    }
  }

  Future<void> deleteUsedItem({
    required int id,
  }) async {
    int deletedIndex =
        _itemsByOwner.indexWhere((element) => element.useditemsid == id);
    var deleteditem = _itemsByOwner[deletedIndex];
    _itemsByOwner.removeWhere((element) => element.useditemsid == id);
    notifyListeners();
    final Uri url = Uri.parse(AppConfig.APP_BASE_URL +
        '/api/Ads/delete_ad');
    final json = {
      'id': id,
    };
    final response = await http.post(
      url,
      body: jsonEncode(json),
    );
    if (response.statusCode != 200) {
      _itemsByOwner.insert(deletedIndex, deleteditem);
      notifyListeners();
      throw HttpException('حدث خطأ أثناء عملية حذف الأداة المستعملة ');
    }
  }

  Future<void> updateUsedItem({
    required int oldid,
    required String title,
    required int cityid,
    required int itemtypeid,
    required String ownerid,
    required String price,
    required String description,
    required String mainphoto,
    required String dimensions,
    required String token,
  }) async {
    final json = {
      'id': oldid,
      'title': title,
      'type_id': itemtypeid,
      'ownerid': ownerid,
      'price': price,
      'description': description,
      'country_id':"1",
      'city_id': cityid,
      'currency':"1",
      'dimensions': dimensions,
      'mainPhoto': mainphoto


    };
    final Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Token': token
    };

    final Uri url = Uri.parse(AppConfig.APP_BASE_URL +
        '/api/Ads/edit_ad');

    final response =
        await http.post(url, body: jsonEncode(json));

    if (response.statusCode != 200) {
      print(response.statusCode);
      throw HttpException('حدث خطأ أثناء عملية تعديل أداة مستعملة ');
    }
    notifyListeners();
  }

  void clearFilters() {
    _filtereditem = [];
    notifyListeners();
  }

  bool setFilters({
    int? type,
    int? city,
    int? minPrice,
    int? maxPrice,
    int? orderBy,
    List<UsedItem>? filtered,
  }) {
    _filtereditem = [..._items].where((element) {
      var elementPrice = element.price;
      return ((minPrice != null
              ? (elementPrice! >= minPrice)
              : true) &&
          (maxPrice != null
              ? (elementPrice! <= maxPrice)
              : true) &&
          (city != null ? (element.cityid == city) : true) &&
          (type != null ? (element.itemtypeid == type) : true));
    }).toList();
    _filtereditem.sort((a, b) {
      var priceA = a.price;
      var priceB = b.price;
      return priceA!.compareTo(priceB!);
    });
    if (orderBy == 0) {
      _filtereditem.reversed;
    }
    filtered != null ? _filtereditem = filtered : print(_filtereditem.length);

    notifyListeners();
    if (_filtereditem.isNotEmpty) return true;
    return false;
  }
}
