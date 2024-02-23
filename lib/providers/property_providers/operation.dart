import 'dart:convert';
import 'package:alshamel_new/helper/app_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:alshamel_new/helper/http_exception.dart';

class Operation with ChangeNotifier {
  final int? operationId;
  final String? operationName;

  Operation({ this.operationId,  this.operationName});

  List<Operation> _operations = [];

  List<Operation> get operations {
    return [..._operations];
  }

  Operation findById(int operId) {
    return operations.firstWhere((element) => element.operationId == operId);
  }

  @override
  bool operator ==(other) {
    return (other is Operation) &&
        other.operationId == operationId &&
        other.operationName == operationName;
  }

  @override
  int get hashCode => operationId.hashCode ^ operationName.hashCode;

  Operation.fromjson(Map<String, dynamic> json)
      : operationId = json['id'],
        operationName = json['operationtypename'];

  Future<void> getAllOperations() async {
    final Uri url = Uri.parse(AppConfig.APP_BASE_URL +
        '/api/property/get_propertyoperationtype');
    final respons = await http.get(url);
    if (respons.statusCode != 200) {
      throw HttpException('حدث خطأ أثناء جلب بيانات عمليات العقار');
    }

    List<Operation> loadedOperation = [];
    final responseData = json.decode(respons.body);
    for (var oper in responseData) {
      loadedOperation.add(Operation.fromjson(oper));
    }
    _operations = loadedOperation;
    notifyListeners();
  }
}
