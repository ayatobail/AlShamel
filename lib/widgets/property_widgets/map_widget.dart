import 'dart:async';

import 'package:alshamel_new/helper/location_helper.dart';
import 'package:alshamel_new/helper/location_update.dart';
import 'package:alshamel_new/marker_helper/Gist.dart';
import 'package:alshamel_new/providers/property_providers/property.dart';
import 'package:alshamel_new/providers/property_providers/property_item.dart';
import 'package:alshamel_new/widgets/property_widgets/property_review.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:location/location.dart' as Loc;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:typed_data';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:flutter/rendering.dart';

class GoogleMapWidget extends StatefulWidget {
  //LatLng curLocation;
  @override
  _GoogleMapWidgetState createState() => _GoogleMapWidgetState();
}

class _GoogleMapWidgetState extends State<GoogleMapWidget> {
  BitmapDescriptor? imageInMemory;
  LatLng? curLocation;
  LatLng? tempLocation;
  Uint8List? markerIcon;
  BitmapDescriptor? customIcon;
  bool temp = false;
  bool isloading = true, inside = false;
  Completer<GoogleMapController> _controller = Completer();
  late GoogleMapController mapController;

  List<Marker> markers = [];
  List<PropertyItem>? _properties;

  Future<void> _getcurrentplace() async {
    tempLocation = LatLng(34.7324, 36.7137);
    Loc.Location location = Loc.Location();
    try {
      final pos = await Loc.Location().getLocation();
      setState(() {
        curLocation = LatLng(pos.latitude!, pos.longitude!);
      });
    } catch (e) {
      //print(e);
      if (e.hashCode == 'PERMISSION_DENIED') {
        setState(() {
          curLocation = tempLocation;
        });
      }
    }
  }

  bool isLoading = false;

  List<Widget> markerWidgets(
    List<PropertyItem> listOfPro,
  ) {
    return listOfPro
        .map((c) => _getMarkerWidget(priceValidation(c.price)))
        .toList();
  }

  String priceValidation(num1) {
    int num = int.parse(num1.split('.')[0]);
    if (num > 999 && num < 99999) {
      return "${(num / 1000)} ألف";
    } else if (num > 99999 && num < 999999) {
      return "${(num / 1000)} ألف";
    } else if (num > 999999 && num < 999999999) {
      return "${(num / 1000000).toStringAsFixed(0)} مليون";
    } else if (num > 999999999) {
      return "${(num / 1000000000).toStringAsFixed(0)} مليار";
    }
    return "${(num).toStringAsFixed(1)} ليرة";
  }

  List<Marker> mapBitmapsToMarkers(
      List<PropertyItem> propertyItems, List<Uint8List> bitmaps) {
    List<Marker> markersList = [];

    bitmaps.asMap().forEach((i, bmp) {
      final property = propertyItems[i];
      //print(property.coordinates);
      if (property.coordinates!.isNotEmpty) {
        final coordinates = property.coordinates!.split(',');

        final double lat = double.parse(coordinates[0])!;
        final double lng = double.parse(coordinates[1])!;
        // location = LatLng(lat, lng);
        markersList.add(Marker(
          markerId: MarkerId(property.price.toString()??""),
          position: LatLng(lat, lng),
          icon: BitmapDescriptor.fromBytes(bmp),
          onTap: () => _onTapMarkerWidget(property),
        ));
      }
    });
    return markersList;
  }

  Widget _getMarkerWidget(String name) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3, vertical: 1.5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Theme.of(context).accentColor, width: 1),
          color: Theme.of(context).primaryColor,
          shape: BoxShape.rectangle,
        ),
        child: Text(
          name,
          textDirection: TextDirection.rtl,
          style: TextStyle(
              fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  void initState() {
    Provider.of<Property>(
      context,
      listen: false,
    ).getAllPropertyFake().then((properties) {
      setState(() {
        _properties = properties;
      });
      MarkerGenerator(markerWidgets(_properties!), (bitmaps) {
        setState(() {
          markers = mapBitmapsToMarkers(_properties!, bitmaps);
        });
      }).generate(context);
    });

    _getcurrentplace();
    super.initState();
  }

  void _onTapMarkerWidget(property) {
    Navigator.of(context).pushNamed(PropertyReviewScreen.routeName,
        arguments: property.propertyId);
  }

  Future<void> _handlePressButton() async {
    // show input autocomplete with selected mode
    // then get the Prediction selected
    Prediction? p = await PlacesAutocomplete.show(
      mode: Mode.overlay,
      types: [],
      radius: 10000000,
      strictbounds: false,
      context: context,
      apiKey: LocationHelper.GOOGLE_API_KEY,
      decoration: InputDecoration(
        hintText: 'Search',
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
      ),
      components: [Component(Component.country, "SY")],
    );

    displayPrediction(p!);
  }

  Future<void> displayPrediction(Prediction p) async {
    if (p != null) {
      // get detail (lat/lng)
      GoogleMapsPlaces _places = GoogleMapsPlaces(
        apiKey: LocationHelper.GOOGLE_API_KEY,
        apiHeaders: await GoogleApiHeaders().getHeaders(),
      );
      PlacesDetailsResponse detail =
          await _places.getDetailsByPlaceId(p.placeId??"");
      final lat = detail.result.geometry!.location.lat;
      final lng = detail.result.geometry!.location.lng;
      Provider.of<LocationUpdate>(context, listen: false).set(lat, lng);
      updateLocation();
    }
  }

  Future<void> updateLocation() async {
    final lat = Provider.of<LocationUpdate>(context, listen: false).getLocLat;
    final lng = Provider.of<LocationUpdate>(context, listen: false).getLocLng;

    if (lat != null && lng != null) {
      mapController = await _controller.future;
      mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(lat, lng),
        zoom: 14.0,
      )));
    }
   // Provider.of<LocationUpdate>(context, listen: false).set(0.0, 0.0);
  }

  @override
  Widget build(BuildContext context) {
    final propertyData = Provider.of<Property>(context);

    List<PropertyItem> listOf = [];
    if (propertyData.noFilteredData == -1) {
      MarkerGenerator(
          markerWidgets(
            listOf,
          ), (bitmaps) {
        setState(() {
          markers = mapBitmapsToMarkers(listOf, bitmaps);
        });
      }).generate(context);
    } else if (propertyData.noFilteredData == 1) {
      MarkerGenerator(markerWidgets(propertyData.filteredItems), (bitmaps) {
        setState(() {
          markers = mapBitmapsToMarkers(propertyData.filteredItems, bitmaps);
        });
      }).generate(context);
    }
    updateLocation();
    return Container(
      child: curLocation == null
          ? Center(child: CircularProgressIndicator())
          : Stack(children: [
              GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: CameraPosition(
                  //target: LatLng(curLocation.latitude, curLocation.longitude),
                  target: LatLng(
                    curLocation!.latitude,
                    curLocation!.longitude,
                  ),
                  zoom: 16,
                ),
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                  mapController = controller;
                },
                myLocationEnabled: true,
                markers: markers.toSet(),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.only(bottomRight: Radius.circular(30)),
                    color: Colors.black45,
                  ),
                  child: TextButton.icon(
                    onPressed: _handlePressButton,
                    icon: Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                    label: Text(''),
                  ),
                ),
              ),
            ]),
    );
  }
}
