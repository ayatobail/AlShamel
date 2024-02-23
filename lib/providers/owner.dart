import 'dart:convert';
import 'dart:io';

import 'package:alshamel_new/helper/app_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:alshamel_new/helper/http_exception.dart';

class Owner with ChangeNotifier {
  final int? ownerid;
  final String? firstname;
  final String? lastname;
  final String? phone;
  final String? email;
  final String? photo;

  Owner? _user;

  String? _number;

  String? get phoneNumber {
    return _number;
  }

  Owner? get currentUser {
    return _user;
  }

  Owner(
      {this.ownerid,
      this.firstname,
      this.lastname,
      this.email,
      this.photo,
      this.phone});

  Owner.fromjson(Map<String, dynamic> json)
      : ownerid = json['id'],
        firstname = json['name'],
        lastname = json['last_name'],
        phone = json['phone'],
        email = json['email'],
        photo = json['photo'];

  Future<void> getOwnerInfo(int ownerid) async {
    final Uri url = Uri.parse(AppConfig.APP_BASE_URL +
        '/api/owner/get_owner_by_id');
    final jsondata = {
      "id": ownerid,
    };
    try {
      final response = await http.post(
        url,
        body: jsonEncode(jsondata),
      );
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final List<Owner> loaded = [];
        for (var unit in responseData) {
          loaded.add(Owner.fromjson(unit));
        }
        _number = loaded[0].phone;
        _user = new Owner(
          firstname: loaded[0].firstname,
          lastname: loaded[0].lastname,
          email: loaded[0].email,
          phone: loaded[0].phone,
          photo: loaded[0].photo,
        );
      } else {
        throw HttpException('حدثت مشكلة مع السيرفر');
      }
    } on SocketException {
      throw HttpException('لا يوجد اتصال بالانترنت');
    } catch (e) {
      throw HttpException('حدثت مشكلة مع السيرفر');
    }
  }

  Future<void> updateOwnerInfo({
    required int ownerid,
    required String firstname,
    required String lastname,
    required String phone,
    required String email,
  }) async {
    print(ownerid);
    print(firstname);
    //print(lastname);
    print(phone);
    print(email);
    final Uri url = Uri.parse(
        AppConfig.APP_BASE_URL + '/api/auth/edit_profile1');
    final jsondata = {
      "id": ownerid,
      "firstname": firstname,
      "lastname": lastname,
      "phone": phone,
      "email": email
    };
    try {
      final response = await http.post(
        url,
        body: jsonEncode(jsondata),
      );
      if (response.statusCode != 200) {
        throw HttpException('حدثت مشكلة أثناء عملية التعديل');
      }
    } on SocketException {
      throw HttpException('لا يوجد اتصال بالانترنت');
    } catch (e) {
      throw HttpException('حدثت مشكلة مع السيرفر');
    }
  }
}
