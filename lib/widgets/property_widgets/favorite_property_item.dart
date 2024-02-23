import 'package:alshamel_new/providers/property_providers/property_item.dart';
import 'package:alshamel_new/widgets/property_widgets/property_review.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FavoritePropertyItem extends StatelessWidget {
  Widget simpleDetailsContainer(context, PropertyItem property) {
    return Container(
      child: ListTile(
        leading: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: new LinearGradient(
                colors: [
                  Theme.of(context).accentColor,
                  Theme.of(context).primaryColor,
                ],
              )
              //color: Theme.of(context).primaryColorLight,
              ),
          padding: const EdgeInsets.all(8),
          child: AutoSizeText(
            'رقم الإعلان ${property.propertyId}',
            overflow: TextOverflow.ellipsis,
            textScaleFactor: MediaQuery.of(context).textScaleFactor,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyText2!.copyWith(
                  color: Colors.white,
                ),
          ),
        ),
        title: AutoSizeText(
          property.propertyTypeName??"",
          overflow: TextOverflow.ellipsis,
          textScaleFactor: MediaQuery.of(context).textScaleFactor,
          textDirection: TextDirection.rtl,
          style: Theme.of(context)
              .textTheme
              .bodyText2!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        subtitle: AutoSizeText(
          property.cityName??"",
          overflow: TextOverflow.ellipsis,
          textScaleFactor: MediaQuery.of(context).textScaleFactor,
          textDirection: TextDirection.rtl,
          style: Theme.of(context).textTheme.bodyText2!.copyWith(
                color: Theme.of(context).primaryColorLight,
              ),
        ),
      ),
    );
  }

  Widget makeIcons(String asset, String label, String? value, context) {
    return FittedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            asset,
            fit: BoxFit.cover,
          ),
          AutoSizeText(
            label,
            overflow: TextOverflow.ellipsis,
            textScaleFactor: MediaQuery.of(context).textScaleFactor,
            style: Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 10),
          ),
          AutoSizeText(
            value == 'غير مذكور' ? '-' : value!,
            overflow: TextOverflow.ellipsis,
            textScaleFactor: MediaQuery.of(context).textScaleFactor,
            style: Theme.of(context).textTheme.bodyText2!.copyWith(
                  color: Theme.of(context).accentColor,
                  fontSize: 9,
                ),
          )
        ],
      ),
    );
  }

  Widget fourIconsDetails(context, PropertyItem property) {
    String? rooms;
    String? bathrooms;
    String? floor;
    for (var e in Provider.of<PropertyItem>(context, listen: false).details) {
      if (e.name == 'عدد الغرف') {
        rooms = e.value;
      } else if (e.name == 'حمامات') {
        bathrooms = e.value;
      } else if (e.name == 'الطابق') {
        floor = e.value;
      }
    }
    return Consumer<PropertyItem>(builder: (ctx, all, child) {
      all.getPropertyDetails(property.propertyId!);
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
        padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            makeIcons(
              'assets/images/bed.svg',
              'عدد الغرف',
              rooms != null ? rooms : '-',
              context,
            ),
            makeIcons(
              'assets/images/washroom.svg',
              'حمامات',
              bathrooms != null ? bathrooms : '-',
              context,
            ),
            makeIcons(
              'assets/images/shape-size-interface-symbol.svg',
              'المساحة',
              property.areasize != null ? property.areasize.toString()??"" : '-',
              context,
            ),
            makeIcons(
              'assets/images/building-with-big-windows.svg',
              'الطابق',
              floor != null ? floor : '-',
              context,
            )
          ],
        ),
      );
    });
  }

  Widget makeItem(context, PropertyItem property) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                simpleDetailsContainer(context, property),
                fourIconsDetails(context, property),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.all(5.0),
            width: MediaQuery.of(context).size.height * .18,
            height: MediaQuery.of(context).size.height * .18,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: property.mainPhoto!=null
                  ?
                    CachedNetworkImage(
                    imageUrl: property.mainPhoto??"",
                        cacheKey: property.mainPhoto!+DateTime.now().second.toString(),
                    fit:BoxFit.cover
                       )
            /*  Image.network(property.mainPhoto??"", fit: BoxFit.cover)*/
                  : Image.asset('assets/images/one.png', fit: BoxFit.cover),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final property = Provider.of<PropertyItem>(context, listen: false);
    return Stack(
      children: [
        InkWell(
          onTap: () {
            Navigator.of(context).pushNamed(PropertyReviewScreen.routeName,
                arguments: property.propertyId);
          },
          child: Card(
            margin: EdgeInsets.all(8.0),
            elevation: 6.0,
            shadowColor: Theme.of(context).accentColor.withOpacity(0.7),
            child: Container(
              height: MediaQuery.of(context).size.height * .22,
              child: makeItem(context, property),
            ),
          ),
        ),
      ],
    );
  }
}
