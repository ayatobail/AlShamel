import 'package:alshamel_new/providers/used_items_providers/used_item.dart';
import 'package:alshamel_new/screens/used_items/usedItem_review_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:intl/intl.dart' as intl1;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';

class UsedItemWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final devicewidth = MediaQuery.of(context).size.width;
    final usedItem = Provider.of<UsedItem>(context, listen: false);
    var priceFormat = intl1.NumberFormat.currency(symbol: '');
    int num = usedItem.price!;
    String price = priceFormat.format(num);

    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(
          UsedItemReviewScreen.routeName,
          arguments: usedItem.useditemsid,
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
                    child: usedItem.mainphoto!=null
                        ?CachedNetworkImage(
                      imageUrl: usedItem.mainphoto!,
                      cacheKey: usedItem.mainphoto!+DateTime.now().second.toString(),
                      height: devicewidth * .4,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    )
                   /* Image.network(
                      "https://alshamel.tadproducts.xyz${usedItem.mainphoto}",
                            height: devicewidth * .4,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          )*/
                        : SvgPicture.asset(
                    'assets/images/shopping.svg',
                            fit: BoxFit.contain,
                            // height: devicewidth * .4,
                          ),
                  ),
                ),
              ),
              Container(
                color: Theme.of(context).backgroundColor,
                child: Padding(
                  padding: EdgeInsets.all(6.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      AutoSizeText(
                        usedItem.title??"",
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
                        usedItem.cityname??"",
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
                              '$price S.P',
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
