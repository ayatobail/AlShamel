import 'package:flutter/cupertino.dart';

class LocationUpdate with ChangeNotifier {
  double? lat;
  double? lng;

  set(double lat1, double lng1) {
    this.lat = lat1;
    this.lng = lng1;
  }

  get getLocLat {
    return this.lat;
  }

  get getLocLng {
    return this.lng;
  }
}
