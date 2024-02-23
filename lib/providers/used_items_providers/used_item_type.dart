import 'dart:convert';

import 'package:alshamel_new/helper/app_config.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:alshamel_new/helper/http_exception.dart';

class UsedItemType with ChangeNotifier {
  final int? useditemtypeid;
  final String? usedtypename;

  UsedItemType({ this.useditemtypeid,  this.usedtypename});

  List<UsedItemType> _types = [];

  List<UsedItemType> get types {
    return [..._types];
  }

  @override
  bool operator ==(other) {
    return (other is UsedItemType) &&
        other.useditemtypeid == useditemtypeid &&
        other.usedtypename == usedtypename;
  }

  UsedItemType findById(int typeId) {
    return types.firstWhere((element) => element.useditemtypeid == typeId);
  }

  @override
  int get hashCode => useditemtypeid.hashCode ^ usedtypename.hashCode;

  UsedItemType.fromjson(Map<String, dynamic> typejson)
      : useditemtypeid = typejson['id'],
        usedtypename = typejson['name'];

  Future<void> getAllTypes() async {
    final Uri url = Uri.parse(AppConfig.APP_BASE_URL +
        '/api/Ads/get_Ad_type');
    final response = await http.get(url);
    if (response.statusCode != 200) {
      throw HttpException('حدث خطأ أثناء جلب جميع الفئات للأدوات المستعملة');
    }
    final responseData = json.decode(response.body);
    List<UsedItemType> loadedTypes = [];
    for (var type in responseData) {
      loadedTypes.add(UsedItemType.fromjson(type));
    }
    _types = loadedTypes;
    notifyListeners();
  }
}
