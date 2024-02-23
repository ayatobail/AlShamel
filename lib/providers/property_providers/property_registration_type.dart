import 'package:alshamel_new/helper/app_config.dart';
import 'package:alshamel_new/helper/http_exception.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PropertyRegistrationType with ChangeNotifier {
  final int? id;
  final String? name;

  PropertyRegistrationType({ this.id, this.name});

  List<PropertyRegistrationType> _items = [];

  List<PropertyRegistrationType> get items {
    return [..._items];
  }

  @override
  bool operator ==(other) {
    return (other is PropertyRegistrationType) &&
        other.id == id &&
        other.name == name;
  }

  PropertyRegistrationType findById(int id) {
    return items.firstWhere((element) => element.id == id);
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;

  PropertyRegistrationType.fromjson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'];

  Future<void> getAllRegistrationType() async {
    final Uri url = Uri.parse(AppConfig.APP_BASE_URL +
        '/api/property/get_property_registration_type');
    final respons = await http.get(url);
    if (respons.statusCode != 200) {
      throw HttpException('حدث خطأ أثناء جلب بيانات أنواع الملكيات العقار');
    }

    List<PropertyRegistrationType> loadedOperation = [];
    final responseData = json.decode(respons.body);
    for (var oper in responseData) {
      loadedOperation.add(PropertyRegistrationType.fromjson(oper));
    }
    _items = loadedOperation;
    notifyListeners();
  }
}
