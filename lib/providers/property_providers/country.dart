import 'dart:convert';
import 'dart:io';

import 'package:alshamel_new/helper/app_config.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:alshamel_new/helper/http_exception.dart';

class Country with ChangeNotifier {
  final String countryId;
  final String countryName;

  Country({
    required this.countryId,
    required this.countryName,
  });
  @override
  bool operator ==(other) {
    return (other is Country) &&
        other.countryId == countryId &&
        other.countryName == countryName;
  }

  @override
  int get hashCode => countryId.hashCode ^ countryName.hashCode;

  List<Country> _countries = [];

  List<Country> get countries {
    return [..._countries];
  }

  Country findById(String cityId) {
    return countries.firstWhere((element) => element.countryId == cityId);
  }

  Country.fromjson(Map<String, dynamic> json)
      : countryId = json['id'],
        countryName = json['country_name'];

  Future<void> getAllCities() async {
    final Uri url =
    Uri.parse(AppConfig.APP_BASE_URL + '/api/country/get_country');
    try {
      final response = await http.get(url);
      if (response.statusCode != 200) {
        throw HttpException('حدثت مشكلة أثناء جلب أسماء البلدان من السيرفر');
      }
      final responseData = json.decode(response.body);
      List<Country> loadedCountries = [];
      for (var city in responseData) {
        loadedCountries.add(Country.fromjson(city));
      }
      _countries = loadedCountries;
      notifyListeners();
    } on SocketException {
      throw HttpException('لا يوجد اتصال بالانترنت');
    } catch (e) {
      throw HttpException('حدثت مشكلة مع السيرفر');
    }
  }
}
