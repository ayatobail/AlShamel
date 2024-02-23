import 'dart:io';

import 'package:alshamel_new/helper/app_config.dart';
import 'package:alshamel_new/helper/http_exception.dart';
import 'package:alshamel_new/models/user_message.dart';
import 'package:flutter/cupertino.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class Messages with ChangeNotifier {
  List<UserMessage> _messages = [];
  List<UserMessage> get messages {
    return [..._messages];
  }

  Future<void> getAllMessagesByUsedID(int id) async {
    final Uri url = Uri.parse(AppConfig.APP_BASE_URL +
        '/api/messages/get_owner_messages');
    try {
      final jsondata = {"id": id};
      final response = await http.post(url, body: jsonEncode(jsondata));

      final responseData = json.decode(response.body);
      final List<UserMessage> _loadedMessages = [];
      for (var msg in responseData) {
        _loadedMessages.add(UserMessage.fromjson(msg));
      }
      _messages = _loadedMessages;

      notifyListeners();
    } on SocketException {
      throw HttpException('لا يوجد اتصال بالانترنت');
    } catch (e) {
      print(e);
      throw HttpException('حدث خطأ الرجاء المحاولة مرة أخرى');
    }
  }
}
