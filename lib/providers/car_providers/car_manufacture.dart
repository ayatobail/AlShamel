import 'package:alshamel_new/helper/app_config.dart';
import 'package:alshamel_new/helper/http_exception.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CarManufacture with ChangeNotifier {
  final int? manufactureid;
  final String? companyname;
  final String? companylogo;
  final String? companysite;

  CarManufacture({
    this.manufactureid,
    this.companyname,
    this.companylogo,
    this.companysite,
  });

  List<CarManufacture> _manufactures = [];

  List<CarManufacture> get carManufactures {
    return [..._manufactures];
  }

  @override
  bool operator ==(other) {
    return (other is CarManufacture) &&
        other.manufactureid == manufactureid &&
        other.companyname == companyname &&
        other.companylogo == companylogo &&
        other.companysite == companysite;
  }

  @override
  int get hashCode =>
      manufactureid.hashCode ^
      companyname.hashCode ^
      companylogo.hashCode ^
      companysite.hashCode;

  CarManufacture.fromjson(Map<String, dynamic> json)
      : manufactureid = json['id'],
        companyname = json['companyname'],
        companylogo = json['companylogo'],
        companysite = json['companysite'];

  Future<void> getAllManufactures() async {
    final Uri url =
        Uri.parse(AppConfig.APP_BASE_URL + '/api/cars/get_carmanufacture');
    final respons = await http.get(url);
    if (respons.statusCode != 200) {
      throw HttpException('حدث خطأ أثناء جلب بيانات الشركات');
    }

    List<CarManufacture> loadedManufactuers = [];
    final responseData = json.decode(respons.body);
    for (var man in responseData) {
      loadedManufactuers.add(CarManufacture.fromjson(man));
    }
    _manufactures = loadedManufactuers;
    notifyListeners();
  }
}
