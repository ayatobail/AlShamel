import 'package:alshamel_new/providers/property_providers/property.dart';
import 'package:alshamel_new/providers/property_providers/property_item.dart';
import 'package:alshamel_new/widgets/property_widgets/property_filtered_items.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:alshamel_new/widgets/property_widgets/property_item.dart';
import 'package:auto_size_text/auto_size_text.dart';

class PropertyListsScreen extends StatefulWidget {
  final containerHeight;
  PropertyListsScreen(this.containerHeight);

  @override
  _PropertyListsScreenState createState() => _PropertyListsScreenState();
}

class _PropertyListsScreenState extends State<PropertyListsScreen> {
  final _controller = ScrollController();
  bool isloading = false;

  @override
  void didChangeDependencies() async {
    setState(() {
      isloading = true;
    });
    Future.wait([
      Provider.of<Property>(
        context,
        listen: false,
      ).getAllProperty()
    ]);

    setState(() {
      isloading = false;
    });
    super.didChangeDependencies();
  }

  void _showAllItems(List<PropertyItem> it) {
    setState(() {
      Provider.of<Property>(context, listen: false).setFilters(filtered: it);
    });
  }

  Widget _section(context, List<PropertyItem> secitems, String title) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton(
              child: AutoSizeText(
                'مشاهدة الكل',
                overflow: TextOverflow.ellipsis,
                textScaleFactor: MediaQuery.of(context).textScaleFactor,
                minFontSize: 9,
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    color: Theme.of(context).accentColor,
                    fontWeight: FontWeight.bold),
              ),
              onPressed: () => _showAllItems(secitems),
            ),
            AutoSizeText(
              title,
              overflow: TextOverflow.ellipsis,
              textScaleFactor: MediaQuery.of(context).textScaleFactor,
              minFontSize: 9,
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    color: Theme.of(context).primaryColorLight,
                    fontWeight: FontWeight.bold,
                  ),
            )
          ],
        ),
        Expanded(
          child: ListView.builder(
            reverse: true,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: (secitems.length / 2).round(),
            itemBuilder: (BuildContext ctx, int index) {
              return ChangeNotifierProvider.value(
                value: secitems[index],
                child: PropertyItemWidget(),
              );
            },
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final propertyData = Provider.of<Property>(context);
    return isloading
        ? Center(
            child: const CircularProgressIndicator(),
          )
        : propertyData.filteredItems.isNotEmpty
            ? FilteredItems(
                height: widget.containerHeight * .7,
              )
            : Container(
                color: Theme.of(context).backgroundColor,
                child: SingleChildScrollView(
                  controller: _controller,
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    children: [
                      Container(
                        height: widget.containerHeight * .43,
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: _section(
                          context,
                          propertyData.items,
                          'المعروض حديثاً',
                        ),
                      ),
                      Container(
                        height: widget.containerHeight * .43,
                        margin: const EdgeInsets.symmetric(vertical: 4.0),
                        child: _section(
                          context,
                          propertyData.getAllPropertyOrderedByViews,
                          'الأكثر مشاهدة',
                        ),
                      ),
                      Container(
                        height: widget.containerHeight * .43,
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: _section(
                          context,
                          propertyData.items,
                          'جميع العقارات',
                        ),
                      ),
                    ],
                  ),
                ),
              );
  }
}
