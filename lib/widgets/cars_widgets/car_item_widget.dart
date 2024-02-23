import 'package:alshamel_new/providers/car_providers/car_item.dart';
import 'package:alshamel_new/screens/cars/car_review_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart' as intl1;

class CarItemWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final devicewidth = MediaQuery.of(context).size.width;
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
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(15),
                      topLeft: Radius.circular(15),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                    child: car.mainphoto!=null
                        ? CachedNetworkImage(
                      imageUrl: car.mainphoto??"",
                      cacheKey: car.mainphoto!+DateTime.now().second.toString(),
                      height: devicewidth * .4,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    )/*Image.network(
                            car.mainphoto??"",
                            height: devicewidth * .4,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          )*/
                        : Image.asset(
                            'assets/images/car.png',
                            height: devicewidth * .4,
                            width: double.infinity,
                            fit: BoxFit.contain,
                          ),
                  ),
                ),
              ),
              Container(
                child: Padding(
                  padding: EdgeInsets.all(6.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      AutoSizeText(
                        car.title??"",
                        textDirection: TextDirection.rtl,
                        overflow: TextOverflow.ellipsis,
                        textScaleFactor: MediaQuery.of(context).textScaleFactor,
                        minFontSize: 9,
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      AutoSizeText(
                        '${car.cityname}-${car.km}كم',
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
                              price,
                              overflow: TextOverflow.ellipsis,
                              textScaleFactor:
                                  MediaQuery.of(context).textScaleFactor,
                              //minFontSize: 9,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2!
                                  .copyWith(
                                    fontSize: 12,
                                    color: Theme.of(context).accentColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                          Flexible(
                            child: AutoSizeText(
                              car.operationtypename??"",
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
