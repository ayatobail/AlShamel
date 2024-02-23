import 'package:alshamel_new/providers/auth.dart';
import 'package:alshamel_new/providers/car_providers/car_item.dart';
import 'package:alshamel_new/providers/car_providers/cars.dart';
import 'package:alshamel_new/screens/cars/cars_update_screen.dart';
import 'package:alshamel_new/widgets/cars_widgets/car_item_for_filters.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyCarsScreen extends StatefulWidget {
  static String routeName = '/mycars';
  @override
  _MyCarsScreenState createState() => _MyCarsScreenState();
}

class _MyCarsScreenState extends State<MyCarsScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    setState(
      () {
        _isLoading = true;
      },
    );
    Future.wait([
      Provider.of<Cars>(context, listen: false).getAllCars(),
    ]).then(
      (_) => setState(
        () {
          _isLoading = false;
        },
      ),
    );
    super.initState();
  }

  void _showAlertDialog(context, int carid) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text("هل تريد بالتأكيد حذف المركبة؟"),
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
                  await Provider.of<Cars>(context, listen: false)
                      .deleteCar(carid: carid);
                },
              )
            ],
          );
        });
  }

  void _didChange(context, val, CarItem p) async {
    if (val == 'Delete') {
      _showAlertDialog(context, p.id!);
    } else if (val == 'ُEdit') {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => CarsUpdateScreen(p.id!)));
    }
  }

  @override
  Widget build(BuildContext context) {
    int id = Provider.of<Auth>(context, listen: false).ownerId!;
    Provider.of<Cars>(context, listen: false).carByOwnerID(id);
    var appBar2 = AppBar(
      leading: Icon(
        Icons.train,
        color: Theme.of(context).accentColor,
      ),
      actions: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          child: Text(
            'سياراتي',
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
          : Consumer<Cars>(
              builder: (ctx, c, child) => c.carsByOwner.isEmpty
                  ? Container(
                      child: Center(
                      child: Text('لا يوجد عناصر'),
                    ))
                  : Container(
                      height: containerHeight,
                      // color: Colors.amber,
                      margin: const EdgeInsets.all(8),
                      child: ListView.builder(
                        padding: EdgeInsets.all(0),
                        scrollDirection: Axis.vertical,
                        itemCount: (c.carsByOwner.length),
                        itemBuilder: (BuildContext ctx, int index) {
                          return ChangeNotifierProvider.value(
                            value: c.carsByOwner[index],
                            child: Stack(children: [
                              CarItemForFilters(),
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
                                      ctx, value, c.carByOwnerID(id)[index]),
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
