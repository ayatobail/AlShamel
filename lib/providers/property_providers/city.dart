import 'dart:convert';
import 'dart:io';

import 'package:alshamel_new/helper/app_config.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:alshamel_new/helper/http_exception.dart';

class City with ChangeNotifier {
  final int? cityId;
  final String? cityName;

  City({
     this.cityId,
     this.cityName,
  });
  @override
  bool operator ==(other) {
    return (other is City) &&
        other.cityId == cityId &&
        other.cityName == cityName;
  }

  @override
  int get hashCode => cityId.hashCode ^ cityName.hashCode;

  List<City> _cities = [];

  List<City> get cities {
    return [..._cities];
  }

  City findById(int cityId) {
    return cities.firstWhere((element) => element.cityId == cityId);
  }

  City.fromjson(Map<String, dynamic> json)
      : cityId = json['id'],
        cityName = json['name'];

  Future<void> getAllCities() async {
    final Uri url = Uri.parse(
        AppConfig.APP_BASE_URL + '/api/country/get_cities');
    try {
      final response = await http.get(url);
      if (response.statusCode != 200) {
        throw HttpException('حدثت مشكلة أثناء جلب أسماء المدن من السيرفر');
      }
      final responseData = json.decode(response.body);
      List<City> loadedCities = [];
      for (var city in responseData) {
        loadedCities.add(City.fromjson(city));
      }
      _cities = loadedCities;
      notifyListeners();
    } on SocketException {
      throw HttpException('لا يوجد اتصال بالانترنت');
    } catch (e) {
      throw HttpException('حدثت مشكلة مع السيرفر');
    }
  }
}
