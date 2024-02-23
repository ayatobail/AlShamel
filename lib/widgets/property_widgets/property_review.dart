import 'package:alshamel_new/helper/http_exception.dart';
import 'package:alshamel_new/providers/property_providers/property.dart';
import 'package:alshamel_new/providers/property_providers/property_item.dart';
import 'package:alshamel_new/screens/property/property_details_screen.dart';
import 'package:alshamel_new/widgets/property_widgets/carousel_slider_images.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:intl/intl.dart' as intl1;

class PropertyReviewScreen extends StatefulWidget {
  static const routeName = '/property-review';

  @override
  _PropertyReviewScreenState createState() => _PropertyReviewScreenState();
}

class _PropertyReviewScreenState extends State<PropertyReviewScreen> {
  void _goBack(context) {
    Navigator.pop(context);
  }

  Widget getpropertyOnMap(propertyitem) {
    try {
      final coordinates = propertyitem.coordinates.split(',');
      final double lat = double.parse(coordinates[0]);
      final double lng = double.parse(coordinates[1]);
      final location = LatLng(lat, lng);
      return new GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(location!.latitude, location!.longitude),
          zoom: 20,
        ),
        mapType: MapType.normal,
        markers: {
          Marker(
            markerId: MarkerId(propertyitem.propertyId.toString()),
            position: LatLng(
              location.latitude,
              location.longitude,
            ),
          )
        },
      );
    } catch (error) {
      return new GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(34, 36),
          zoom: 16,
        ),
        mapType: MapType.normal,
      );
    }
  }

  void _goToPropertyDetails(context, PropertyItem property) {
    Navigator.of(context).pushNamed(
      PropertyDetailsScreen.routeName,
      arguments: property,
    );
  }

  Widget simpleDetailsContainer(context, PropertyItem property) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: ListTile(
        leading: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: new LinearGradient(
                colors: [
                  Theme.of(context).accentColor,
                  Theme.of(context).primaryColorLight,
                ],
              )
              //color: Theme.of(context).primaryColorLight,
              ),
          padding: const EdgeInsets.all(10),
          child: AutoSizeText(
            'رقم الإعلان : ${property.propertyId}',
            overflow: TextOverflow.ellipsis,
            textScaleFactor: MediaQuery.of(context).textScaleFactor,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .bodyText2!
                .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          reverse: true,
          child: AutoSizeText(
            property.title??"",
            overflow: TextOverflow.ellipsis,
            textScaleFactor: MediaQuery.of(context).textScaleFactor,
            textDirection: TextDirection.rtl,
            style: Theme.of(context)
                .textTheme
                .bodyText1!
                .copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        subtitle: AutoSizeText(
          '${property.location}-${property.cityName}',
          overflow: TextOverflow.ellipsis,
          textScaleFactor: MediaQuery.of(context).textScaleFactor,
          textDirection: TextDirection.rtl,
          style: Theme.of(context).textTheme.bodyText2!.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColorLight),
        ),
      ),
    );
  }

  Widget makeIcons(String asset, String label, String value, context) {
    return FittedBox(
      child: Column(
        children: [
          SvgPicture.asset(
            asset,
            fit: BoxFit.cover,
          ),
          AutoSizeText(
            label,
            overflow: TextOverflow.ellipsis,
            textScaleFactor: MediaQuery.of(context).textScaleFactor,
            style: Theme.of(context).textTheme.bodyText2,
          ),
          AutoSizeText(
            value,
            //overflow: TextOverflow.ellipsis,
            textDirection: TextDirection.rtl,
            textScaleFactor: MediaQuery.of(context).textScaleFactor,
            style: Theme.of(context).textTheme.bodyText2!.copyWith(
                  color: Theme.of(context).accentColor,
                  fontWeight: FontWeight.bold,
                ),
          )
        ],
      ),
    );
  }

  Widget fourIconsDetails(containerHeight, context, PropertyItem property) {
    String rooms="";
    String bathrooms="";    String floor="";
    for (var e in Provider.of<PropertyItem>(context, listen: false).details) {
      if (e.name == 'عدد الغرف') {
        rooms = e.value;
      } else if (e.name == 'الحمامات') {
        bathrooms = e.value;
      } else if (e.name == 'الطابق') {
        floor = e.value;
      }
    }
    return Container(
      height: containerHeight * .15,
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          makeIcons(
            'assets/images/bed.svg',
            'عدد الغرف',
            rooms != null ? rooms : '-',
            context,
          ),
          makeIcons(
            'assets/images/washroom.svg',
            'الحمامات',
            bathrooms != null ? bathrooms : '-',
            context,
          ),
          makeIcons(
            'assets/images/shape-size-interface-symbol.svg',
            'المساحة',
            property.areasize != null ? '${property.areasize} م²' : '-',
            context,
          ),
          makeIcons(
            'assets/images/building-with-big-windows.svg',
            'الطابق',
            floor != null||floor.isNotEmpty ? floor : '-',
            context,
          )
        ],
      ),
    );
  }

  Widget appBar(context) {
    return AppBar(leading: Container(), actions: [
      Padding(
        padding: const EdgeInsets.only(right: 20),
        child: IconButton(
          onPressed: () => _goBack(context),
          icon: Icon(
            Icons.arrow_forward,
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
    ]);
  }

  void _showErrorDialog(String title, String message, onPressed) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: onPressed,
            child: Text('OK'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final topPadding = MediaQuery.of(context).padding.top;
    final bottomPading = MediaQuery.of(context).padding.bottom;
    final availableSpace = deviceHeight - topPadding - bottomPading;
    final containerHeight = availableSpace - AppBar().preferredSize.height;

    final propertyId = ModalRoute.of(context)!.settings.arguments as int;

    return Scaffold(
      appBar: PreferredSize(preferredSize: Size.fromHeight(56),
      child: appBar(context)),
      body: FutureBuilder(
        future: Future.wait([
          Provider.of<Property>(context, listen: false)
              .getPropertyByID(propertyId),
          Provider.of<PropertyItem>(context, listen: false)
              .getImages(propertyId),
          Provider.of<PropertyItem>(context, listen: false)
              .getPropertyDetails(propertyId),
          /*Provider.of<PropertyItem>(context, listen: false)
              .getPropertyExtraFields(propertyId),*/
          Provider.of<PropertyItem>(context, listen: false)
              .increaseViews(propertyid: propertyId),
        ]).catchError((Object e, StackTrace stackTrace) {
          _showErrorDialog(
            'حدث خطأ',
            e.toString(),
            () {
              Navigator.of(context).pop();
            },
          );
        }, test: (e) => e is HttpException),
        builder: (BuildContext ctx, AsyncSnapshot snapshotData) {
          if (snapshotData.hasError) {
            return Container(
              child: Center(
                child: Text('تحقق من وجود الانترنت'),
              ),
            );
          }
          if (snapshotData.connectionState == ConnectionState.waiting) {
            return const Center(
              child: const CircularProgressIndicator(),
            );
          } else {
            final property =
                Provider.of<Property>(context, listen: false).itemById;
            var priceFormat = intl1.NumberFormat.currency(symbol: '');

            int num = int.parse(property.price.toString()!.split('.')[0]);
            String price = priceFormat.format(num);

            return Container(
              height: containerHeight,
              child: Column(
                children: [
                  Container(
                    height: containerHeight * .3,
                    color: Theme.of(context).primaryColorLight,
                    child: property.coordinates != null
                        ? getpropertyOnMap(property)
                        : Container(),
                  ), // for google map
                  CarouselSliderImages(
                    containerHeight: containerHeight * .3,
                    images: Provider.of<PropertyItem>(context, listen: false)
                        .images,
                  ), // for photos
                  Container(
                    height: containerHeight * .1,
                    child: simpleDetailsContainer(context, property),
                  ),
                  Divider(
                    color: Colors.grey,
                    endIndent: 50,
                    indent: 50,
                  ),
                  fourIconsDetails(containerHeight, context, property),
                  Container(
                    height: containerHeight * .1,
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () =>
                              _goToPropertyDetails(context, property),
                          child: AutoSizeText(
                            'المزيد من التفاصيل',
                            overflow: TextOverflow.ellipsis,
                            textScaleFactor:
                                MediaQuery.of(context).textScaleFactor,
                            style:
                                Theme.of(context).textTheme.bodyText2!.copyWith(
                                      color: Theme.of(context).accentColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                        ),
                        AutoSizeText(
                          '$price S.P',
                          overflow: TextOverflow.ellipsis,
                          textScaleFactor:
                              MediaQuery.of(context).textScaleFactor,
                          style: Theme.of(context).textTheme.bodyText2,
                        )
                      ],
                    ),
                  ) // last row in screen
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
