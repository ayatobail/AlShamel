import 'package:alshamel_new/providers/car_providers/car_item.dart';
import 'package:alshamel_new/screens/cars/car_review_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart' as intl1;

class CarItemForFilters extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final car = Provider.of<CarItem>(context, listen: false);
    var priceFormat = intl1.NumberFormat.currency(symbol: '');
    int num = int.parse(car.price.toString()!);
    String price = priceFormat.format(num);
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(
          CarReviewScreen.routeName,
          arguments: car,
        );
      },
      child: Card(
        color: Theme.of(context).primaryColor,
        elevation: 6.0,
        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Container(
          height: MediaQuery.of(context).size.height * .20,
          padding: const EdgeInsets.all(4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      AutoSizeText(
                        '${car.title} - ${car.registeryear}',
                        textDirection: TextDirection.rtl,
                        overflow: TextOverflow.ellipsis,
                        textScaleFactor: MediaQuery.of(context).textScaleFactor,
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).backgroundColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      AutoSizeText(
                        '${car.cityname} - ${car.km}كم',
                        overflow: TextOverflow.ellipsis,
                        textScaleFactor: MediaQuery.of(context).textScaleFactor,
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
                            child: AutoSizeText(
                              '$price S.P',
                              overflow: TextOverflow.ellipsis,
                              textScaleFactor:
                                  MediaQuery.of(context).textScaleFactor,
                              style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context).accentColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(5.0),
                width: MediaQuery.of(context).size.height * .18,
                height: MediaQuery.of(context).size.height * .18,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: car.mainphoto!=null
                      ? CachedNetworkImage(
                    imageUrl: car.mainphoto??"",
                    cacheKey: car.mainphoto!+DateTime.now().second.toString(),
                    fit: BoxFit.cover,
                  )
                      : Image.asset(
                          'assets/images/car.png',
                          fit: BoxFit.contain,
                        ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
