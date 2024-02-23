import 'dart:convert';

import 'package:alshamel_new/helper/app_config.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:alshamel_new/helper/http_exception.dart';

class Type with ChangeNotifier {
  final int? typeId;
  final String? typeName;

  Type({ this.typeId,  this.typeName});

  List<Type> _types = [];

  List<Type> get types {
    return [..._types];
  }

  @override
  bool operator ==(other) {
    return (other is Type) &&
        other.typeId == typeId &&
        other.typeName == typeName;
  }

  Type findById(int typeId) {
    return types.firstWhere((element) => element.typeId == typeId);
  }

  @override
  int get hashCode => typeId.hashCode ^ typeName.hashCode;

  Type.fromjson(Map<String, dynamic> typejson)
      : typeId = typejson['id'],
        typeName = typejson['typename'];

  Future<void> getAllTypes() async {
    final Uri url = Uri.parse(AppConfig.APP_BASE_URL +
        '/api/property/get_property_type');
    final response = await http.get(url);
    if (response.statusCode != 200) {
      throw HttpException('حدث خطأ أثناء جلب أنواع العقارات');
    }
    final responseData = json.decode(response.body);
    List<Type> loadedTypes = [];
    for (var type in responseData) {
      loadedTypes.add(Type.fromjson(type));
    }
    _types = loadedTypes;
    notifyListeners();
  }
}
