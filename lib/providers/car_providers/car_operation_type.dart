import 'package:alshamel_new/helper/app_config.dart';
import 'package:alshamel_new/helper/http_exception.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CarOperationType with ChangeNotifier {
  final int? operationid;
  final String? operationtype;

  CarOperationType({this.operationid, this.operationtype});

  List<CarOperationType> _operationtypes = [];

  List<CarOperationType> get carOperationTypes {
    return [..._operationtypes];
  }

  @override
  bool operator ==(other) {
    return (other is CarOperationType) &&
        other.operationid == operationid &&
        other.operationtype == operationtype;
  }

  @override
  int get hashCode => operationid.hashCode ^ operationtype.hashCode;

  CarOperationType.fromjson(Map<String, dynamic> json)
      : operationid = json['id'],
        operationtype = json['operation_name'];

  Future<void> getAllCarOperationTypes() async {
    final Uri url =
        Uri.parse(AppConfig.APP_BASE_URL + '/api/cars/get_caroperationtype');
    final respons = await http.get(url);
    if (respons.statusCode != 200) {
      throw HttpException('حدث خطأ أثناء جلب بيانات أنواع المركبات');
    }

    List<CarOperationType> loadedOperation = [];
    final responseData = json.decode(respons.body);
    for (var man in responseData) {
      loadedOperation.add(CarOperationType.fromjson(man));
    }
    _operationtypes = loadedOperation;
    notifyListeners();
  }
}
