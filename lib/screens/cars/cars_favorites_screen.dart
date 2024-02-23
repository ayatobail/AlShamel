import 'package:alshamel_new/providers/auth.dart';
import 'package:alshamel_new/providers/property_providers/favorites.dart';
import 'package:alshamel_new/widgets/cars_widgets/car_item_for_filters.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:auto_size_text/auto_size_text.dart';

class CarsFavoritesScreen extends StatelessWidget {
  void _showAlertDialog(context, int carid) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text("حذف المركبة من المفضلة؟"),
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
                await Provider.of<Favorites>(context, listen: false)
                    .deleteFavoriteCar(
                        carid: carid,
                        ownerid:
                            Provider.of<Auth>(context, listen: false).ownerId!);
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final int owner = Provider.of<Auth>(context, listen: false).ownerId!;
    var appBar2 = AppBar(
      leading: Icon(
        Icons.star,
        color: Theme.of(context).primaryColorLight,
      ),
      actions: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          child: Text(
            'المفضلة',
            textDirection: TextDirection.rtl,
            style: Theme.of(context)
                .textTheme
                .bodyText1!
                .copyWith(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
    return Scaffold(
      appBar: appBar2,
      body: FutureBuilder(
        future: Future.wait([
          Provider.of<Favorites>(context, listen: false)
              .getAllFavoriteCars(owner!),
        ]),
        builder: (BuildContext ctx, AsyncSnapshot snapshotData) {
          if (snapshotData.connectionState == ConnectionState.waiting) {
            return const Center(
              child: const CircularProgressIndicator(),
            );
          } else {
            return Consumer<Favorites>(
              builder: (ctx, favs, child) => favs.carfavos.isNotEmpty
                  ? Container(
                      margin: const EdgeInsets.all(8),
                      child: ListView.builder(
                        padding: const EdgeInsets.only(top: 0),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: favs.carfavos.length,
                        itemBuilder: (BuildContext ctx, int index) {
                          return ChangeNotifierProvider.value(
                            value: favs.carfavos[index],
                            child: InkWell(
                                onLongPress: () => _showAlertDialog(
                                    context, favs.carfavos[index].id!),
                                child: Container(child: CarItemForFilters())),
                          );
                        },
                      ),
                    )
                  : Container(
                      child: Center(
                        child: AutoSizeText(
                          'لا يوجد عناصر في المفضلة',
                          textDirection: TextDirection.rtl,
                          overflow: TextOverflow.ellipsis,
                          textScaleFactor:
                              MediaQuery.of(context).textScaleFactor,
                          minFontSize: 9,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2!
                              .copyWith(color: Theme.of(context).primaryColor),
                        ),
                      ),
                    ),
            );
          }
        },
      ),
    );
  }
}
