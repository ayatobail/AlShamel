import 'package:alshamel_new/helper/app_config.dart';
import 'package:alshamel_new/helper/http_exception.dart';
import 'package:alshamel_new/providers/car_providers/car_item.dart';
import 'package:alshamel_new/providers/property_providers/property_item.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:alshamel_new/providers/used_items_providers/used_item.dart';

class Favorites with ChangeNotifier {
  List<CarItem> _favoriteCars = [];
  List<CarItem> get carfavos {
    return [..._favoriteCars];
  }

  int carIsFavorite(int carid) {
    return carfavos.indexWhere((element) => element.id == carid);
  }

  List<PropertyItem> _favoriteProperty = [];
  List<PropertyItem> get propertyfavos {
    return [..._favoriteProperty];
  }

  List<UsedItem> _favoritesUsedItem = [];
  List<UsedItem> get usedItemfavs {
    return [..._favoritesUsedItem];
  }

  int usedItemIsFavorite(int usedid) {
    return usedItemfavs.indexWhere((element) => element.useditemsid == usedid);
  }

  int proisFavorite(int propertyId) {
    return propertyfavos
        .indexWhere((element) => element.propertyId == propertyId);
  }

  Future<void> getAllFavoriteProperty(int ownerid) async {
    final Uri url = Uri.parse(AppConfig.APP_BASE_URL +
        '/api/fav_properties/get_user_fav_properties');
    final jsonData = {'user_id': ownerid};
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
    _favoriteProperty = loadeditems;
    notifyListeners();
  }

  Future<void> getAllFavoriteCars(int ownerid) async {
    final Uri url = Uri.parse(AppConfig.APP_BASE_URL +
        '/api/fav_cars/get_user_fav_cars');
    final jsonData = {'user_id': ownerid};
    final response = await http.post(url, body: jsonEncode(jsonData));
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
    _favoriteCars = loadeditems;
    notifyListeners();
  }

  Future<void> getAllFavoriteUsedItems(int ownerid) async {
    final Uri url = Uri.parse(AppConfig.APP_BASE_URL +
        '/api/fav_ads/get_user_fav_ads');
    final jsonData = {'user_id': ownerid};
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
    _favoritesUsedItem = loadeditems;
    print(_favoritesUsedItem.length);
    notifyListeners();
  }

  Future<void> insertFavoriteProperty({
    required PropertyItem property,
    required int ownerid,
  }) async {
    _favoriteProperty.add(property);
    notifyListeners();
    print('00000000');
    final Uri url = Uri.parse(AppConfig.APP_BASE_URL +
        '/api/fav_properties/add_fav_properties');
    final json = {
      'user_id': ownerid,
      'property_id': property.propertyId,
    };
    final response = await http.post(
      url,
      body: jsonEncode(json),
    );
    if (response.statusCode != 201) {
      _favoriteProperty
          .removeWhere((element) => element.propertyId == property.propertyId);
      notifyListeners();
      throw HttpException('حدث خطأ أثناء عملية تفضيل العقار ');
    }
  }

  Future<void> deleteFavoriteProperty({
    required int propertyid,
    required int ownerid,
  }) async {
    int deletedIndex = _favoriteProperty
        .indexWhere((element) => element.propertyId == propertyid);
    var deletedProperty = _favoriteProperty[deletedIndex];
    _favoriteProperty
        .removeWhere((element) => element.propertyId == propertyid);
    notifyListeners();
    final Uri url = Uri.parse(AppConfig.APP_BASE_URL +
        '/api/fav_properties/delete_fav_properties');
    final json = {
      'id': propertyid,
      'user_id': ownerid,
    };
    final response = await http.post(
      url,
      body: jsonEncode(json),
    );
    if (response.statusCode != 200) {
      _favoriteProperty.insert(deletedIndex, deletedProperty);
      notifyListeners();
      throw HttpException('حدث خطأ أثناء عملية الغاء تفضيل العقار ');
    }
  }

  Future<void> insertFavoriteCar({
    required CarItem car,
    required int? ownerid,
  }) async {
    _favoriteCars.add(car);
    notifyListeners();
    final Uri url = Uri.parse(AppConfig.APP_BASE_URL +
        '/api/fav_cars/add_fav_car');
    final json = {
      'user_id': ownerid,
      'car_id': car.id,
    };
    final response = await http.post(
      url,
      body: jsonEncode(json),
    );
    if (response.statusCode != 201) {
      _favoriteCars.removeWhere((element) => element.id == car.id);
      notifyListeners();
      throw HttpException('حدث خطأ أثناء عملية تفضيل السيارة ');
    }
  }

  Future<void> deleteFavoriteCar({
    required int carid,
    required int? ownerid,
  }) async {
    int deletedIndex =
        _favoriteCars.indexWhere((element) => element.id == carid);
    var deletedCar = _favoriteCars[deletedIndex];
    _favoriteCars.removeWhere((element) => element.id == carid);
    notifyListeners();
    final Uri url = Uri.parse(AppConfig.APP_BASE_URL +
        '/api/fav_cars/delete_fav_cars');
    final json = {
      'id': carid,
      'user_id': ownerid,
    };
    final response = await http.post(
      url,
      body: jsonEncode(json),
    );
    if (response.statusCode != 200) {
      _favoriteCars.insert(deletedIndex, deletedCar);
      notifyListeners();
      throw HttpException('حدث خطأ أثناء عملية الغاء تفضيل السيارة ');
    }
  }

  Future<void> insertFavoriteUsedItem({
    required UsedItem useditem,
    required int ownerid,
  }) async {
    _favoritesUsedItem.add(useditem);
    notifyListeners();
    final Uri url = Uri.parse(AppConfig.APP_BASE_URL +
        '/api/fav_ads/add_fav_ads');

    final json = {
      'user_id': ownerid,
      'ad_id': useditem.useditemsid,
    };
    final response = await http.post(
      url,
      body: jsonEncode(json),
    );
    if (response.statusCode != 201) {
      _favoritesUsedItem.removeWhere(
          (element) => element.useditemsid == useditem.useditemsid);
      notifyListeners();
      throw HttpException('حدث خطأ أثناء عملية تفضيل الأدوات المستعملة ');
    }
  }

  Future<void> deleteFavoriteUsedItem({
    required int useditemid,
    required int ownerid,
  }) async {
    int deletedIndex = _favoritesUsedItem
        .indexWhere((element) => element.useditemsid == useditemid);
    var deletedItem = _favoritesUsedItem[deletedIndex];
    _favoritesUsedItem
        .removeWhere((element) => element.useditemsid == useditemid);
    notifyListeners();
    final Uri url = Uri.parse(AppConfig.APP_BASE_URL +
        '/api/fav_ads/delete_fav_ads');
    final json = {
      'id': useditemid,
      'user_id': ownerid,
    };
    final response = await http.post(
      url,
      body: jsonEncode(json),
    );
    if (response.statusCode != 200) {
      _favoritesUsedItem.insert(deletedIndex, deletedItem);
      notifyListeners();
      throw HttpException('حدث خطأ أثناء عملية الغاء تفضيل الأدوات المستعملة ');
    }
  }
}
