import 'dart:convert';
import 'dart:io';

import 'package:alshamel_new/helper/app_config.dart';
import 'package:alshamel_new/models/property_models.dart/detail_value.dart';
import 'package:alshamel_new/models/property_models.dart/extra_fields.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:alshamel_new/helper/http_exception.dart';

class PropertyItem with ChangeNotifier {
  List<DetailsValues> _details = [];
  List<ExtraFields> _extrafields = [];
  List<String> _images = [];
  List<File> _imgsForUpload = [];

  void setImgs(List<File> imgs) {
    this._imgsForUpload = imgs;
  }

  List<File> get getimgsForUpload {
    return _imgsForUpload;
  }

  final int? propertyId;
  final String? title;
  final String? publidhDate;
  final String? approveDate;
  final int? isApproved;
  final int? operationTypeId;
  final int? propertyTypeId;
  final dynamic price;
  final String? location;
  final int? cityId;
  final String? coordinates;
  final int? ownerId;
  final int? views;
  final int? areasize;
  final String? status;
  final String? mainPhoto;
  final String? notes;
  final String? cityName;
  final String? operationTypeName;
  final String? propertyTypeName;
  final int? propertyRegType;
  final int? propertyRegestrationTypeId;
  final String? propertyRegestrationTypeName;
  final String? phone1;
  final String? phone2;
  final String? phone3;

  PropertyItem({
     this.propertyId,
     this.title,
     this.publidhDate,
     this.approveDate,
     this.isApproved,
     this.operationTypeId,
     this.propertyTypeId,
     this.price,
     this.location,
     this.cityName,
     this.cityId,
     this.coordinates,
     this.ownerId,
     this.views,
     this.areasize,
     this.status,
     this.mainPhoto,
     this.notes,
     this.operationTypeName,
     this.propertyTypeName,
     this.propertyRegType,
     this.propertyRegestrationTypeId,
     this.propertyRegestrationTypeName,
     this.phone1,
     this.phone2,
     this.phone3,
  });
  List<DetailsValues> get details {
    return [..._details];
  }

  List<String> get images {
    return [..._images];
  }

  List<ExtraFields> get extrafields {
    return [..._extrafields];
  }

  PropertyItem.fromjson(Map<String, dynamic> json)
      : propertyId = json['id'],
        title = json['title'],
        publidhDate = json['created_at'],
        approveDate = json['approveDate'],
        isApproved = json['isApproved'],
        operationTypeId = json['operationTypeId'],
        propertyTypeId = json['propertyTypeId'],
        price = json['price'],
        location = json['location'],
        cityName = json['city_name'],
        cityId = json['cityId'],
        coordinates = json['coordinates'],
        ownerId = json['ownerid'],
        views = json['views'],
        areasize = json['areasize'],
        status = json['status'],
        mainPhoto = json['mainPhoto'],
        notes = json['notes'],
        operationTypeName = json['operationtypename'],
        propertyTypeName = json['typename'],
        propertyRegType = json['property_regestration_type_id'],
        propertyRegestrationTypeId = json['property_regestration_type_id'],
        propertyRegestrationTypeName = json['property_registration_type_name'],
        phone1 = json['phone'],
        phone2 = json['phone2'],
        phone3 = json['phone3'];

  Future<void> getPropertyDetails(int id) async {
    final Uri url = Uri.parse(AppConfig.APP_BASE_URL +
        '/api/property/get_property_details_values');
    final jsondata = {
      "id": id,
    };
    final response = await http.post(
      url,
      body: jsonEncode(jsondata),
    );
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final List<DetailsValues> loadeddetails = [];
      for (var unit in responseData) {
        loadeddetails.add(DetailsValues.fromjson(unit));
      }
      _details = loadeddetails;
      notifyListeners();
    } else {
      throw HttpException('حدثت مشكلة مع السيرفر');
    }
  }


  Future<void> getPropertyExtraFields(int id) async {
    final Uri url = Uri.parse(AppConfig.APP_BASE_URL +
        '/mobileapp/for_mobile/property/property_extra_field/select_property_extra_fields_for_mobile.php');
    final jsondata = {
      'propertyid': id,
    };
    final response = await http.post(
      url,
      body: json.encode(jsondata),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final List<ExtraFields> loadedextrafields = [];
      for (var unit in responseData) {
        loadedextrafields.add(ExtraFields.fromjson(unit));
      }
      _extrafields = loadedextrafields;
      notifyListeners();
    } else {
      throw HttpException('حدثت مشكلة مع السيرفر');
    }
  }

  Future<void> getImages(int id) async {
    final Uri url = Uri.parse(AppConfig.APP_BASE_URL +
        '/api/property/get_propertyattachments_by_propertyid');
    final jsondata = {
      'id': id,
    };
    final response = await http.post(
      url,
      body: jsonEncode(jsondata),
    );
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final List<String> loadedImages = [];
      for (var unit in responseData) {
        loadedImages.add(unit['url']);
      }
      _images = loadedImages;
      notifyListeners();
    } else {
      throw HttpException('حدثت مشكلة مع السيرفر');
    }
  }

  Future<void> addPropertyExtraFields({
    required String propertyid,
    required String fieldname,
    required String fieldvalue,
  }) async {
    final Uri url = Uri.parse(AppConfig.APP_BASE_URL +
        '/mobileapp/for_mobile/property/property_extra_field/insert_property_extra_fields_for_mobile.php');
    final json = {
      'propertyid': propertyid,
      'fieldname': fieldname,
      'fieldvalue': fieldvalue
    };
    final response = await http.post(
      url,
      body: jsonEncode(json),
    );
    //print(response.statusCode);
    if (response.statusCode != 200) {
      throw HttpException(
          'حدث خطأ أثناء عمليةإدخال المعلومات الاضافية للعقار ');
    }
    notifyListeners();
  }

  Future<void> addPropertyTypeDetails({
    required String detailsid,
    required int propertyid,
    required String detailvalue,
  }) async {
    final Uri url = Uri.parse(AppConfig.APP_BASE_URL +
        '/api/property/add_property_details_values');
    final json = {
      "id": propertyid,
      "detailsid": detailsid,
      "detailvalue": detailvalue
    };
    final response = await http.post(
      url,
      body: jsonEncode(json),
    );
    if (response.statusCode != 201) {
      throw HttpException('حدث خطأ أثناء عمليةإدخال تفاصيل العقار ');
    }
    notifyListeners();
  }

  Future<void> uploadImages({
    required int propertyid,
    required List<String> images,
  }) async {
    final Uri url = Uri.parse(AppConfig.APP_BASE_URL +
        '/api/property/add_propertyattachments');
    final jsondata = {
      "id": propertyid,
      "images": images,
    };
    final response = await http.post(
      url,
      body: jsonEncode(jsondata),
    );
    //print(response.statusCode);
    if (response.statusCode != 200) {
      throw HttpException('خطأ في تحميل الصور');
    }
    notifyListeners();
  }

  Future<void> increaseViews({
    required int propertyid,
  }) async {
    final Uri url = Uri.parse(AppConfig.APP_BASE_URL +
        '/api/property/edit_property_views');
    final json = {
      'id': propertyid,
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
