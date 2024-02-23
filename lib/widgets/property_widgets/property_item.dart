import 'package:alshamel_new/providers/property_providers/property_item.dart';
import 'package:alshamel_new/widgets/property_widgets/property_review.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart' as intl1;

class PropertyItemWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final devicewidth = MediaQuery.of(context).size.width;
    final property = Provider.of<PropertyItem>(context, listen: false);
    var priceFormat = intl1.NumberFormat.currency(symbol: '');
    int num = int.parse(property.price.toString()!.split('.')[0]);
    String price = priceFormat.format(num);
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(
          PropertyReviewScreen.routeName,
          arguments: property.propertyId,
        );
      },
      child: Card(
        color: Colors.white,
        elevation: 6.0,
        margin: const EdgeInsets.all(4.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Container(
          width: devicewidth * .4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  child: property.mainPhoto!=null
                      ?CachedNetworkImage(
                    imageUrl: property.mainPhoto!,
                    cacheKey: property.mainPhoto!+DateTime.now().second.toString(),
                    height: devicewidth * .4,
                    width: double.infinity,
                    fit: BoxFit.fitWidth,
                  )
                  /*Image.network(
                          property.mainPhoto!,
                          height: devicewidth * .4,
                          width: double.infinity,
                          fit: BoxFit.fitWidth,
                        )*/
                      : Image.asset(
                          'assets/images/one.png',
                          height: devicewidth * .4,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    AutoSizeText(
                      property.title??"",
                      textDirection: TextDirection.rtl,
                      overflow: TextOverflow.ellipsis,
                      textScaleFactor: MediaQuery.of(context).textScaleFactor,
                      minFontSize: 9,
                      style: Theme.of(context).textTheme.bodyText2!.copyWith(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    AutoSizeText(
                      property.location??"",
                      textDirection: TextDirection.rtl,
                      overflow: TextOverflow.ellipsis,
                      textScaleFactor: MediaQuery.of(context).textScaleFactor,
                      minFontSize: 9,
                      style: Theme.of(context).textTheme.bodyText2!.copyWith(
                            color: Theme.of(context).primaryColorLight,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: AutoSizeText(
                            '$price',
                            overflow: TextOverflow.ellipsis,
                            textScaleFactor:
                                MediaQuery.of(context).textScaleFactor,
                            minFontSize: 9,
                            style:
                                Theme.of(context).textTheme.bodyText2!.copyWith(
                                      fontSize: 12,
                                      color: Theme.of(context).accentColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                        ),
                        Flexible(
                          child: AutoSizeText(
                            '${property.areasize} م²',
                            textDirection: TextDirection.rtl,
                            overflow: TextOverflow.ellipsis,
                            textScaleFactor:
                                MediaQuery.of(context).textScaleFactor,
                            minFontSize: 9,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2!
                                .copyWith(
                                  fontSize: 12,
                                  color: Theme.of(context).primaryColorLight,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
