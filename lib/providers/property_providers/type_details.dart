import 'dart:convert';
import 'package:alshamel_new/helper/app_config.dart';
import 'package:alshamel_new/models/property_models.dart/type_detail.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:alshamel_new/helper/http_exception.dart';

class TypeDetails with ChangeNotifier {
  List<TypeDetail> _typedetails = [];

  List<TypeDetail> get typedetails {
    return [..._typedetails];
  }

  // Future<void> getTypeDetails(String typeid) async {
  //   final Uri url = Uri.parse(AppConfig.APP_BASE_URL +
  //       '/mobileapp/properties/property_type_details/select_property_type_details.php?typeid=$typeid');
  //   final response = await http.get(url);
  //   if (response.statusCode != 200) {
  //     throw HttpException('حدثت مشكلة مع السيرفر');
  //   }
  //   final responseData = json.decode(response.body);
  //   final List<TypeDetail> loadeddetails = [];
  //   for (var unit in responseData) {
  //     loadeddetails.add(TypeDetail.fromjson(unit));
  //   }
  //   _typedetails = loadeddetails;
  //   notifyListeners();
  // }
  Future<void> getTypeDetails() async {
    final Uri url = Uri.parse(AppConfig.APP_BASE_URL +
        '/api/property/get_propertydetails');
    final response = await http.get(url);
    if (response.statusCode != 200) {
      throw HttpException('حدثت مشكلة مع السيرفر');
    }
    final responseData = json.decode(response.body);
    final List<TypeDetail> loadeddetails = [];
    for (var unit in responseData) {
      loadeddetails.add(TypeDetail.fromjson(unit));
    }
    _typedetails = loadeddetails;
    notifyListeners();
  }
}
