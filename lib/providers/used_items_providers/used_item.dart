import 'package:alshamel_new/helper/app_config.dart';
import 'package:alshamel_new/helper/http_exception.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UsedItem with ChangeNotifier {
  final int? useditemsid;
  final String? title;
  final int? itemtypeid;
  final String? addeddate;
  final int? ownerid;
  final int? price;
  final String? description;
  final int? views;
  final String? mainphoto;
  final String? dimensions;
  final String? usedtypename;
  final int? cityid;
  final String? cityname;
  final String? firstname;
  final String? lastname;
  final int? phone;

  UsedItem(
      {this.useditemsid,
      this.title,
      this.itemtypeid,
      this.addeddate,
      this.ownerid,
      this.price,
      this.description,
      this.views,
      this.mainphoto,
      this.dimensions,
      this.usedtypename,
      this.cityid,
      this.cityname,
      this.firstname,
      this.lastname,
      this.phone});

  UsedItem.fromjson(Map<String, dynamic> json)
      : useditemsid = json['id'],
        title = json['title'],
        itemtypeid = json['type_id'],
        addeddate = json['created_at'],
        ownerid = json['ownerid'],
        price = json['price'],
        description = json['description'],
        views = json['views'],
        mainphoto = json['mainphoto'],
        dimensions = json['dimensions'],
        usedtypename = json['Ad_type_name'],
        cityid = json['city_id'],
        cityname = json['city_name'],
        firstname = json['owner_name'],
        lastname = json['lastname'],
        phone = json['phone'];

  Future<void> increaseViews({
    required int itemid,
  }) async {
    final Uri url = Uri.parse(AppConfig.APP_BASE_URL +
        '/api/Ads/edit_ad_views');
    final json = {
      'id': itemid,
    };
    final response = await http.post(
      url,
      body: jsonEncode(json),
    );
    if (response.statusCode != 200) {
      throw HttpException('حدث خطأ أثناء عملية زيادة المشاهدات ');
    }
    notifyListeners();
  }
}
