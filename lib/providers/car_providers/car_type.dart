import 'package:alshamel_new/helper/app_config.dart';
import 'package:alshamel_new/helper/http_exception.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CarType with ChangeNotifier {
  final int? typeid;
  final String? typename;

  CarType({ this.typeid,  this.typename});

  List<CarType> _types = [];

  List<CarType> get carTypes {
    return [..._types];
  }

  @override
  bool operator ==(other) {
    return (other is CarType) &&
        other.typeid == typeid &&
        other.typename == typename;
  }

  @override
  int get hashCode => typeid.hashCode ^ typename.hashCode;

  CarType.fromjson(Map<String, dynamic> json)
      : typeid = json['id'],
        typename = json['typename'];

  Future<void> getAllCarTypes() async {
    final Uri url = Uri.parse(AppConfig.APP_BASE_URL +
        '/api/cars/get_cartype');
    final respons = await http.get(url);
    if (respons.statusCode != 200) {
      throw HttpException('حدث خطأ أثناء جلب بيانات أنواع المركبات');
    }

    List<CarType> loadedTypes = [];
    final responseData = json.decode(respons.body);
    for (var man in responseData) {
      loadedTypes.add(CarType.fromjson(man));
    }
    _types = loadedTypes;
    notifyListeners();
  }
}
