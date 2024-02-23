import 'dart:convert';
import 'package:alshamel_new/helper/app_config.dart';
import 'package:alshamel_new/models/cars_models/car_type_detail.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:alshamel_new/helper/http_exception.dart';

class CarTypeDetails with ChangeNotifier {
  List<CarTypeDetail> _cartypedetails = [];

  List<CarTypeDetail> get cartypedetails {
    return [..._cartypedetails];
  }

  Future<void> getCarTypeDetails() async {
    final Uri url = Uri.parse(AppConfig.APP_BASE_URL +
        '/api/cars/get_cardetails');

    final response = await http.get(
      url,
    );

    if (response.statusCode != 200) {
      throw HttpException('حدثت مشكلة مع السيرفر');
    }
    final responseData = json.decode(response.body);
    final List<CarTypeDetail> loadeddetails = [];
    for (var unit in responseData) {
      loadeddetails.add(CarTypeDetail.fromjson(unit));
    }
    _cartypedetails = loadeddetails;
    notifyListeners();
  }
}
