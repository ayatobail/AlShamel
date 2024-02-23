import 'package:flutter/cupertino.dart';

class CarDetailValues with ChangeNotifier {
  final String value;
  final String detailsname;
  final String cartypeicon;

  CarDetailValues(this.value, this.detailsname, this.cartypeicon);

  CarDetailValues.fromjson(Map<String, dynamic> json)
      : value = json['value'],
        detailsname = json['name'],
        cartypeicon = json['logo'];
}
