import 'package:alshamel_new/providers/auth.dart';
import 'package:alshamel_new/providers/used_items_providers/used_item.dart';
import 'package:alshamel_new/providers/used_items_providers/used_items.dart';
import 'package:alshamel_new/screens/used_items/usedItem_update_screen.dart';
import 'package:alshamel_new/widgets/used_items_widgets/usedItem_for_filters.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyUsedItemsScreen extends StatefulWidget {
  static String routeName = '/myuseditems';
  @override
  _MyUsedItemsScreenState createState() => _MyUsedItemsScreenState();
}

class _MyUsedItemsScreenState extends State<MyUsedItemsScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    setState(
      () {
        _isLoading = true;
      },
    );
    Future.wait([
      Provider.of<UsedItems>(context, listen: false).getAllUsedItems(),
    ]).then(
      (_) => setState(
        () {
          _isLoading = false;
        },
      ),
    );
    super.initState();
  }

  void _showAlertDialog(context, int usedid) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text("هل تريد بالتأكيد حذف العنصر؟"),
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
                  await Provider.of<UsedItems>(context, listen: false)
                      .deleteUsedItem(id: usedid);
                },
              )
            ],
          );
        });
  }

  void _didChange(context, val, UsedItem p) async {
    if (val == 'Delete') {
      _showAlertDialog(context, p.useditemsid!);
    } else if (val == 'ُEdit') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UsedItemsUpdateScreen(
            usedItemId: p.useditemsid,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    int id = Provider.of<Auth>(context, listen: false).ownerId!;
    Provider.of<UsedItems>(context, listen: false).usedItemsByOwnerID(id);
    var appBar2 = AppBar(
      leading: Icon(
        Icons.shopping_bag_sharp,
        color: Theme.of(context).accentColor,
      ),
      actions: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          child: Text(
            'أدواتي المستعملة',
            textDirection: TextDirection.rtl,
            style: Theme.of(context)
                .textTheme
                .bodyText1!
                .copyWith(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
    final deviceHeight = MediaQuery.of(context).size.height;
    final topPadding = MediaQuery.of(context).padding.top;
    final bottomPading = MediaQuery.of(context).padding.bottom;
    final availableSpace = deviceHeight - topPadding - bottomPading;
    final containerHeight = availableSpace - appBar2.preferredSize.height;
    return Scaffold(
      appBar: appBar2,
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Consumer<UsedItems>(
              builder: (ctx, c, child) => c.itemsByOwner.isEmpty
                  ? Container(
                      child: Center(
                      child: Text('لا يوجد عناصر'),
                    ))
                  : Container(
                      height: containerHeight,
                      margin: const EdgeInsets.all(8),
                      child: ListView.builder(
                        padding: EdgeInsets.all(0),
                        scrollDirection: Axis.vertical,
                        itemCount: (c.itemsByOwner.length),
                        itemBuilder: (BuildContext ctx, int index) {
                          return ChangeNotifierProvider.value(
                            value: c.itemsByOwner[index],
                            child: Stack(children: [
                              UsedItemForFilters(),
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
                                          color:
                                              Theme.of(context).backgroundColor,
                                          width: 1)),
                                  enabled: true,
                                  onSelected: (value) => _didChange(
                                      ctx, value, c.itemsByOwner[index]),
                                  onCanceled: () {
                                    //do something
                                  },
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                      child: Text(
                                        "تعديل",
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor),
                                      ),
                                      value: "ُEdit",
                                    ),
                                    PopupMenuItem(
                                      child: Text(
                                        "حذف",
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor),
                                      ),
                                      value: "Delete",
                                    ),
                                  ],
                                ),
                              )
                            ]),
                          );
                        },
                      ),
                    ),
            ),
    );
  }
}
