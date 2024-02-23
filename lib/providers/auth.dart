import 'package:alshamel_new/helper/app_config.dart';
import 'package:alshamel_new/helper/http_exception.dart';
import 'package:flutter/cupertino.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
   String? _token;
   int? _ownerId;

  String? get token {
    return _token;
  }

  int? get ownerId {
    return _ownerId;
  }

  bool get isAuth {
    return token != null && ownerId != null;
  }

   Future<void> signup(String firstname, String lastname, String phone,
       String email, String password) async {
     const url = AppConfig.APP_BASE_URL +
         '/api/auth/register1';
     Uri uri = Uri.parse(url);
     Map<String, String> headers = {
       'Content-Type': 'application/json',
     };

     Map<String, dynamic> body = {
       'firstname': firstname,
       'lastname': lastname,
       'phone': phone,
       'email': email,
       'password': password,
       'image':""
     };
     final response = await http.post(
       uri,
       headers: headers,
       body: json.encode(body),
     );
     if (response.statusCode == 201) {
       throw HttpException('رقم الهاتف او البريد الاكتروني) موجود مسبقا)');
     }
     final responseData = json.decode(response.body);
     _token = responseData['token'];
     _ownerId = responseData['user_id'];

     notifyListeners();
     final prefs = await SharedPreferences.getInstance();
     final userAuthData = json.encode({
       'token': _token,
       'ownerId': _ownerId,
     });

     prefs.setString('userAuthData', userAuthData);
   }



   Future<void> login(String phone, String password) async {
     const url = AppConfig.APP_BASE_URL;
     Uri uri = Uri.parse(url+"/api/auth/login?email=$phone&password=$password");

     final response = await http.post(
       uri,
     );
       final responseData = json.decode(response.body);
       _token = responseData['token'];
       _ownerId =  responseData['user_id'];

     notifyListeners();
     final prefs = await SharedPreferences.getInstance();
     final userAuthData = json.encode({
       'token': responseData['token'],
       'ownerId': responseData['user_id'],
     });

     prefs.setString('userAuthData', userAuthData);
   }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userAuthData')) {
      // so there is no data stored on the user
      // no valid token
      return false;
    }
    final extractedUserData =
        json.decode(prefs.getString('userAuthData')!) as Map<String, dynamic>;
    _token = extractedUserData['token'];
    _ownerId = extractedUserData['ownerId'];
    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    _token = null;
    _ownerId = null;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userAuthData');
  }

  Future<void> forgetPassword(
    String phoneORemail,
  ) async {
    const url =
        AppConfig.APP_BASE_URL + '/api/auth/forgot_password';
    Uri uri = Uri.parse(url);

    final response = await http.post(
      uri,
      body: json.encode({
        'email': phoneORemail,
      }),
    );
    if (response.statusCode == 201) {
      throw HttpException('الايميل او رقم الهاتف غير صالحين');
    } else if (response.statusCode != 200) {
      throw HttpException('حدث خطا عند استرداد كلمة السر');
    }
  }

  Future<void> changePassword(
    String oldPassword,
    String newPassword,
  ) async {
    const url =
        AppConfig.APP_BASE_URL + '/api/auth/reset_password';
    Uri uri = Uri.parse(url);
    final response = await http.post(
      uri,
      body: json.encode({
        'old_password': oldPassword,
        'new_password': newPassword,
        'ownerId': ownerId
      }),
    );
    if (response.statusCode == 201) {
      throw HttpException('تأكد من كلمة المرور القديمة');
    } else if (response.statusCode != 200) {
      throw HttpException('حدث خطا عند تحديث كلمة المرور');
    }
  }

  Future<void> sendMsgToAdmin({
    required String text,
    required String title,
    required String isreport ,
  }) async {
    const url = AppConfig.APP_BASE_URL +
        '/api/messages/send_message_to_admin';
    Uri uri = Uri.parse(url);

    final response = await http.post(
      uri,
      body: json.encode({
        "title": title,
        "text":text ,
        "senderid": ownerId,
        'is_report': isreport
      }),
    );
    if (response.statusCode != 201) {
      throw HttpException('حدث خطا عند إرسال الرسالة إلى الإدارة');
    }
  }
}
