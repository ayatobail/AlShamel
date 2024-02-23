import 'package:alshamel_new/helper/location_helper.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as Loc;
import 'package:flutter/rendering.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'dart:async';

class MapToPickLocationScreen extends StatefulWidget {
  @override
  _MapToPickLocationScreenState createState() =>
      _MapToPickLocationScreenState();
}

class _MapToPickLocationScreenState extends State<MapToPickLocationScreen> {
  LatLng? _pickedLocation;
  LatLng? _curLocation;
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController? mapController;

  Future<void> _getcurrentplace() async {
    final locData = await Loc.Location().getLocation();
    setState(() {
      _curLocation = LatLng(locData.latitude!, locData.longitude!);
    });
  }

  @override
  void initState() {
    _getcurrentplace();
    super.initState();
  }

  void _selectLocation(LatLng position) {
    setState(() {
      _pickedLocation = position;
    });
  }

  Future<void> updateLocation(double lat, double lng) async {
    if (lat != null && lng != null) {
      mapController = await _controller.future;

      mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(lat, lng),
            zoom: 16.0,
          ),
        ),
      );
    }
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
      GoogleMapsPlaces _places = GoogleMapsPlaces(
        apiKey: LocationHelper.GOOGLE_API_KEY,
        apiHeaders: await GoogleApiHeaders().getHeaders(),
      );
      PlacesDetailsResponse detail =
          await _places.getDetailsByPlaceId(p.placeId!);
      final lat = detail.result.geometry!.location.lat;
      final lng = detail.result.geometry!.location.lng;
      print(lat);
      print(lng);
      updateLocation(lat, lng);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).accentColor,
        title: Text(
          'حدد موقع العقار على الخريطة',
          textAlign: TextAlign.center,
          textDirection: TextDirection.rtl,
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.check,
              color: _pickedLocation == null ? Colors.grey : Colors.white,
            ),
            onPressed: _pickedLocation == null
                ? () => Navigator.of(context).pop(_curLocation)
                : () => Navigator.of(context).pop(_pickedLocation),
          )
        ],
      ),
      body: _curLocation == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                      _curLocation!.latitude,
                      _curLocation!.longitude,
                    ),
                    zoom: 16,
                  ),
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                    mapController = controller;
                  },
                  myLocationEnabled: true,
                  onTap: _selectLocation,
                  markers: _pickedLocation == null
                      ? {}
                      : {
                          Marker(
                            markerId: MarkerId('m1'),
                            position: _pickedLocation!,
                          ),
                        },
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
              ],
            ),
    );
  }
}
