import 'package:alshamel_new/helper/app_config.dart';
import 'package:alshamel_new/helper/http_exception.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CarModels with ChangeNotifier {
  final int? modelid;
  final String? modelname;
  final int? manufactureid;

  List<CarModels> _carmodels = [];

  List<CarModels> get carModels {
    return [..._carmodels];
  }

  CarModels({this.modelid, this.modelname, this.manufactureid});

  @override
  bool operator ==(other) {
    return (other is CarModels) &&
        other.manufactureid == manufactureid &&
        other.modelid == modelid &&
        other.modelname == modelname;
  }

  @override
  int get hashCode =>
      manufactureid.hashCode ^ modelid.hashCode ^ modelname.hashCode;

  CarModels.fromjson(Map<String, dynamic> json)
      : modelid = json['id'],
        modelname = json['modelname'],
        manufactureid = json['manufactureid'];

  Future<void> getModelsByManufactureID(String manuId) async {
    _carmodels = [];
    final Uri url = Uri.parse(
        AppConfig.APP_BASE_URL + '/api/cars/get_carmodel_by_manufactureId');

    final response = await http.Client().post(
      url,
      body: jsonEncode({
        'manufactureid': manuId,
      }),
    );

    if (response.statusCode != 200) {
      throw HttpException('حدث خطأ أثناء جلب موديلات السيارات');
    }

    List<CarModels> loadedModels = [];
    final responseData = json.decode(response.body);
    for (var man in responseData) {
      loadedModels.add(CarModels.fromjson(man));
    }
    _carmodels = loadedModels;
    notifyListeners();
  }
}
