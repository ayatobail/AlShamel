import 'dart:io';

import 'package:alshamel_new/helper/app_config.dart';
import 'package:alshamel_new/helper/http_exception.dart';
import 'package:flutter/cupertino.dart';
import 'package:alshamel_new/models/user_notification.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Notifications with ChangeNotifier {
  List<UserNotification> _notifications = [];
  List<UserNotification> get notifications {
    return [..._notifications];
  }

  List<UserNotification> _notificationsForShow = [];
  List<UserNotification> get notificationsForShow {
    return [..._notificationsForShow];
  }

  List<UserNotification> get unreadedNotifications {
    return notifications.where((element) => element.isread == '0').toList();
  }

  Future<void> readNotification({
    required int notid,
  }) async {
    final Uri url = Uri.parse(AppConfig.APP_BASE_URL +
        '/api/notification/read_notifications_for_one');
    final json = {
      "id": notid,
    };
    final response = await http.post(
      url,
      body: jsonEncode(json),
    );
    if (response.statusCode != 200) {
      throw HttpException('حدث خطأ أثناء عملية قراءة الاشعار ');
    }
  }

  Future<void> getAllNotifications() async {
    final Uri url = Uri.parse(AppConfig.APP_BASE_URL +
        '/api/notification/get_all_notifications');
    try {
      final response = await http.get(url);
      final responseData = json.decode(response.body);
      final List<UserNotification> _loadedNotifications = [];
      for (var msg in responseData) {
        _loadedNotifications.add(UserNotification.fromjson(msg));
      }
      _notifications = _loadedNotifications;

      final prefs = await SharedPreferences.getInstance();

      if (prefs.containsKey('notifications_global')) {
        final extractedNotifications =
            json.decode(prefs.getString('notifications_global')!);
        if (extractedNotifications.length != 0) {
          List<UserNotification> _temp = [];
          for (var i in extractedNotifications) {
            _temp.add(UserNotification.fromjson(i));
          }

          _notificationsForShow = [];
          for (var not in _notifications) {
            List<UserNotification> n = _temp
                .where(
                    (element) => element.notificationsid == not.notificationsid)
                .toList();
            if (n.isEmpty) {
              _notificationsForShow.add(not);
            }
          }
        } else {
          _notificationsForShow = _notifications;
        }
      } else {
        _notificationsForShow = _notifications;
      }

      final encodedData =
          jsonEncode(_notifications.map((e) => e.toJson()).toList());
      prefs.setString('notifications_global', encodedData);

      notifyListeners();
    } on SocketException {
      throw HttpException('لا يوجد اتصال بالانترنت');
    } catch (e) {
      print(e);
      throw HttpException('حدث خطأ الرجاء المحاولة مرة أخرى');
    }
  }

  Future<void> getAllNotificationsByUsedID(int id) async {
    final Uri url = Uri.parse(AppConfig.APP_BASE_URL +
        '/api/notification/get_notifications_for_one');
    try {
      final jsondata = {'id': id};
      final response = await http.post(url, body: jsonEncode(jsondata));
      final responseData = json.decode(response.body);
      final List<UserNotification> _loadedNotifications = [];
      for (var not in responseData) {
        _loadedNotifications.add(UserNotification.fromjsonforowner(not));
      }
      _notifications = _loadedNotifications;
      notifyListeners();
    } on SocketException {
      throw HttpException('لا يوجد اتصال بالانترنت');
    } catch (e) {
      throw HttpException('حدث خطأ الرجاء المحاولة مرة أخرى');
    }
  }
}
