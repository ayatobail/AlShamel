import 'package:alshamel_new/providers/auth.dart';
import 'package:alshamel_new/providers/property_providers/favorites.dart';
import 'package:alshamel_new/widgets/used_items_widgets/usedItem_for_filters.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:auto_size_text/auto_size_text.dart';

class UsedItemsFavoritesScreen extends StatelessWidget {
  void _showAlertDialog(context, int useditemid) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text("حذف العنصر من المفضلة؟"),
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
                      .deleteFavoriteUsedItem(
                          useditemid: useditemid,
                          ownerid: Provider.of<Auth>(context, listen: false)
                              .ownerId!);

                  //makeChange();
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final owner = Provider.of<Auth>(context, listen: false).ownerId;
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
              .getAllFavoriteUsedItems(owner!),
        ]),
        builder: (BuildContext ctx, AsyncSnapshot snapshotData) {
          if (snapshotData.connectionState == ConnectionState.waiting) {
            return const Center(
              child: const CircularProgressIndicator(),
            );
          } else {
            return Consumer<Favorites>(
              builder: (ctx, favs, child) => favs.usedItemfavs.isNotEmpty
                  ? Container(
                      margin: const EdgeInsets.all(8),
                      child: ListView.builder(
                        padding: const EdgeInsets.only(top: 0),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: favs.usedItemfavs.length,
                        itemBuilder: (BuildContext ctx, int index) {
                          return ChangeNotifierProvider.value(
                            value: favs.usedItemfavs[index],
                            child: InkWell(
                              onLongPress: () => _showAlertDialog(context,
                                  favs.usedItemfavs[index].useditemsid!),
                              child: Container(
                                child: UsedItemForFilters(),
                              ),
                            ),
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
