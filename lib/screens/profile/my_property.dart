import 'package:alshamel_new/providers/auth.dart';
import 'package:alshamel_new/providers/property_providers/property.dart';
import 'package:alshamel_new/screens/profile/my_property_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyPropertyScreen extends StatefulWidget {
  static String routeName = '/myproperty';
  @override
  _MyPropertyScreenState createState() => _MyPropertyScreenState();
}

class _MyPropertyScreenState extends State<MyPropertyScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    int id = Provider.of<Auth>(context, listen: false).ownerId!;
    setState(
      () {
        _isLoading = true;
      },
    );
    Future.wait([
      Provider.of<Property>(context, listen: false).getAllProperty(),
      Provider.of<Property>(context, listen: false).getAllPropertyByOwnerID(id),
    ]).then(
      (_) => setState(
        () {
          _isLoading = false;
        },
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var appBar2 = AppBar(
      leading: Icon(
        Icons.home_filled,
        color: Theme.of(context).accentColor,
      ),
      actions: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          child: Text(
            'عقاراتي',
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
          : Consumer<Property>(
              builder: (ctx, p, child) => Container(
                height: containerHeight,
                margin: const EdgeInsets.all(8),
                child: ListView.builder(
                  padding: EdgeInsets.all(0),
                  scrollDirection: Axis.vertical,
                  itemCount: (p.propertyByOwner.length),
                  itemBuilder: (BuildContext ctx, int index) {
                    return ChangeNotifierProvider.value(
                      value: p.propertyByOwner[index],
                      child: MyPropertyItem(
                        height: containerHeight,
                      ),
                    );
                  },
                ),
              ),
            ),
    );
  }
}
