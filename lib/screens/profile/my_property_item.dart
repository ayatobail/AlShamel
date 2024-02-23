import 'package:alshamel_new/helper/http_exception.dart';
import 'package:alshamel_new/providers/property_providers/property.dart';
import 'package:alshamel_new/screens/property/property_update_data.dart';
import 'package:alshamel_new/widgets/property_widgets/property_review.dart';
import 'package:flutter/material.dart';
import 'package:alshamel_new/providers/property_providers/property_item.dart';
import 'package:provider/provider.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MyPropertyItem extends StatelessWidget {
  const MyPropertyItem({
    @required this.height,
  });

  final height;

  void _showAlertDialog(context, int proId) {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            content: Text("هل تريد بالتأكيد حذف العقار؟"),
            actions: [
              TextButton(
                child: Text("إلغاء"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text("نعم"),
                onPressed: () async {
                  Navigator.of(context).pop();
                  try {
                    await Provider.of<Property>(context, listen: false)
                        .deleteProperty(proId: proId);
                  } on HttpException catch (error) {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text('فشل الحذف'),
                        content: Text(error.message.toString()),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('OK'),
                          )
                        ],
                      ),
                    );
                  }
                },
              )
            ],
          );
        });
  }

  void _didChange(context, val, PropertyItem p) async {
    if (val == 'Delete') {
      _showAlertDialog(context, p.propertyId!);
    } else if (val == 'ُEdit') {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PropertyUpdateScreen(p.propertyId!)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final property = Provider.of<PropertyItem>(context, listen: false);
    //print(property.cityName);
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(
          PropertyReviewScreen.routeName,
          arguments: property.propertyId,
        );
      },
      child: Stack(children: [
        Card(
          color: Colors.white,
          elevation: 6.0,
          shadowColor: Theme.of(context).primaryColorLight,
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
                          '${property.title}',
                          textDirection: TextDirection.rtl,
                          overflow: TextOverflow.ellipsis,
                          textScaleFactor:
                              MediaQuery.of(context).textScaleFactor,
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        AutoSizeText(
                          '${property.cityName}',
                          overflow: TextOverflow.ellipsis,
                          textScaleFactor:
                              MediaQuery.of(context).textScaleFactor,
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).primaryColorLight,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: AutoSizeText(
                                '${property.price} S.P',
                                overflow: TextOverflow.ellipsis,
                                textScaleFactor:
                                    MediaQuery.of(context).textScaleFactor,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context).accentColor,
                                ),
                              ),
                            ),
                            Flexible(
                              child: AutoSizeText(
                                '${property.areasize} م²',
                                overflow: TextOverflow.ellipsis,
                                textDirection: TextDirection.rtl,
                                textScaleFactor:
                                    MediaQuery.of(context).textScaleFactor,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context).primaryColor,
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
                    child: property.mainPhoto!=null
                        ?CachedNetworkImage(
                      imageUrl: property.mainPhoto??"",
                        cacheKey: property.mainPhoto!+DateTime.now().second.toString(),
                        fit: BoxFit.fill
                    )

                   /* Image.network(
                            property.mainPhoto??"",
                            fit: BoxFit.fill,
                          )*/
                        : Image.asset(
                            'assets/images/one.png',
                            fit: BoxFit.contain,
                          ),
                  ),
                )
              ],
            ),
          ),
        ),
        Positioned(
          top: 0.0,
          left: 0.0,
          child: PopupMenuButton(
            elevation: 20,
            icon: Icon(
              Icons.more_horiz,
              color: Theme.of(context).accentColor,
            ),
            shape: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Theme.of(context).backgroundColor, width: 1)),
            enabled: true,
            onSelected: (value) => _didChange(context, value, property),
            onCanceled: () {
              //do something
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text(
                  "تعديل",
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
                value: "ُEdit",
              ),
              PopupMenuItem(
                child: Text(
                  "حذف",
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
                value: "Delete",
              ),
            ],
          ),
        )
      ]),
    );
  }
}
