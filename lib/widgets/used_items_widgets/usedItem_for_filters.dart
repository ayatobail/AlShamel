import 'package:alshamel_new/providers/used_items_providers/used_item.dart';
import 'package:alshamel_new/screens/used_items/usedItem_review_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:intl/intl.dart' as intl1;
import 'package:flutter_svg/svg.dart';
import 'package:cached_network_image/cached_network_image.dart';

class UsedItemForFilters extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final useditem = Provider.of<UsedItem>(context, listen: false);
    var priceFormat = intl1.NumberFormat.currency(symbol: '');
    int num = useditem.price!;
    String price = priceFormat.format(num);
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(
          UsedItemReviewScreen.routeName,
          arguments: useditem.useditemsid,
        );
      },
      child: Card(
        color: Theme.of(context).primaryColorLight,
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
                        '${useditem.title}',
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
                        '${useditem.cityname}',
                        overflow: TextOverflow.ellipsis,
                        textScaleFactor: MediaQuery.of(context).textScaleFactor,
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).primaryColor,
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
                  child: useditem.mainphoto!=null
                      ? CachedNetworkImage(
                    imageUrl: useditem.mainphoto!,
                    cacheKey: useditem.mainphoto!+DateTime.now().second.toString(),
                    fit: BoxFit.cover,
                  )
                 /* Image.network(
                          "https://alshamel.tadproducts.xyz${useditem.mainphoto}",
                          fit: BoxFit.fill,
                        )*/
                      : Container(
                          color: Colors.white,
                          padding: const EdgeInsets.all(20.0),
                          child: SvgPicture.asset(
                            'assets/images/shopping.svg',

                            fit: BoxFit.fill,
                            // height: devicewidth * .4,
                          ),
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
