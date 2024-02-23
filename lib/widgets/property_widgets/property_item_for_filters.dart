import 'package:alshamel_new/widgets/property_widgets/property_review.dart';
import 'package:flutter/material.dart';
import 'package:alshamel_new/providers/property_providers/property_item.dart';
import 'package:provider/provider.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:intl/intl.dart' as intl1;

class PropertyItemForFilter extends StatelessWidget {
  const PropertyItemForFilter({
    @required this.height,
  });

  final height;

  @override
  Widget build(BuildContext context) {
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
          margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Container(
            height: height * .2,
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                AutoSizeText(
                  property.title??"",
                  overflow: TextOverflow.ellipsis,
                  textScaleFactor: MediaQuery.of(context).textScaleFactor,
                  minFontSize: 9,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                AutoSizeText(
                  property.location??"",
                  overflow: TextOverflow.ellipsis,
                  textScaleFactor: MediaQuery.of(context).textScaleFactor,
                  minFontSize: 9,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).primaryColorLight,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: new Container(
                        child: AutoSizeText(
                          '$price',
                          overflow: TextOverflow.ellipsis,
                          textScaleFactor:
                              MediaQuery.of(context).textScaleFactor,
                          minFontSize: 9,
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).accentColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      child: Container(
                        child: AutoSizeText(
                          '${property.areasize}',
                          overflow: TextOverflow.ellipsis,
                          textScaleFactor:
                              MediaQuery.of(context).textScaleFactor,
                          minFontSize: 9,
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).primaryColorLight,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
