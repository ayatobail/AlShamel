import 'dart:convert';
import 'package:alshamel_new/models/cars_models/car_detail_values.dart';
import 'package:http/http.dart' as http;
import 'package:alshamel_new/helper/app_config.dart';
import 'package:alshamel_new/helper/http_exception.dart';
import 'package:flutter/cupertino.dart';

class CarItem with ChangeNotifier {
  final int? id;
  final String? title;
  final int? typeid;
  final int? manufactureid;
  final int? modelid;
  final int? manufactureyear;
  final int? registeryear;
  final int? km;
  final int? price;
  final String? mainphoto;
  final int? ownerid;
  final String? descriptions;
  final int? operationtypeid;
  final int? cityid;
  final String? address;
  final String? cityname;
  final String? operationtypename;
  final String? modelname;
  final String? companyname;
  final String? companylogo;
  final String? companysite;
  final String? typename;
  final String? phone1;
  final String? phone2;
  final String? phone3;
  final String? phone;
  List<String> _images = [];
  List<CarDetailValues> _details = [];

  CarItem(
      { this.id,
      this.title,
      this.typeid,
      this.manufactureid,
      this.modelid,
      this.manufactureyear,
      this.registeryear,
      this.km,
      this.price,
      this.mainphoto,
      this.ownerid,
      this.descriptions,
      this.operationtypeid,
      this.cityid,
      this.address,
      this.cityname,
      this.operationtypename,
      this.modelname,
      this.companyname,
      this.companylogo,
      this.companysite,
      this.typename,
      this.phone1,
      this.phone2,
      this.phone3,
      this.phone});

  List<String> get images {
    return [..._images];
  }

  List<CarDetailValues> get detailsvalues {
    return [..._details];
  }

  CarItem.fromjson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['cartname'],
        typeid = json['cartypeid'],
        manufactureid = json['carmanufactureid'],
        modelid = json['modelid'],
        manufactureyear = json['manufactureyear'],
        registeryear = json['registeryear'],
        km = json['km'],
        price = json['price'],
        mainphoto = json['mainphoto'],
        ownerid = json['ownerid'],
        descriptions = json['descriptions'],
        operationtypeid = json['operationtypeid'],
        cityid = json['cityid'],
        address = json['address'],
        cityname = json['city_name'],
        operationtypename = json['caroperationtype_name'],
        modelname = json['carmodel_name'],
        companyname = json['carmanufacture_name'],
        companylogo = json['companylogo'],
        companysite = json['companysite'],
        typename = json['cartype_name'],
        phone1 = json['phone1'],
        phone2 = json['phone2'],
        phone3 = json['phone3'],
        phone = json['phone'];

  Future<void> getCarDetails(int id) async {
    final Uri url = Uri.parse(AppConfig.APP_BASE_URL +
        '/api/cars/get_cardetails_values_by_carid');
    final jsondata = {
      'id': id,
    };
    final response = await http.post(
      url,
      body: jsonEncode(jsondata),
    );
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final List<CarDetailValues> loadeddetails = [];
      for (var unit in responseData) {
        loadeddetails.add(CarDetailValues.fromjson(unit));
      }
      _details = loadeddetails;
      notifyListeners();
    } else {
      throw HttpException('حدثت مشكلة مع السيرفر');
    }
  }

  Future<void> getImages(int id) async {
    final Uri url = Uri.parse(AppConfig.APP_BASE_URL +
        '/api/cars/get_carattachments_by_carid');
    final jsondata = {
      'id': id,
    };
    final response = await http.post(
      url,
      body: jsonEncode(jsondata),
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final List<String> loadedImages = [];
      for (var unit in responseData) {
        loadedImages.add(unit['attachmentlink']);
      }
      _images = loadedImages;
      notifyListeners();
    } else {
      throw HttpException('حدثت مشكلة مع السيرفر');
    }
  }
}
