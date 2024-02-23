import 'package:alshamel_new/providers/property_providers/property.dart';
import 'package:alshamel_new/providers/property_providers/property_item.dart';
import 'package:alshamel_new/widgets/property_widgets/property_item_for_filters.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class FilteredItems extends StatelessWidget {
  const FilteredItems({
    @required this.height,
  });

  final height;

  @override
  Widget build(BuildContext context) {
    final propertyData = Provider.of<Property>(context);
    List<PropertyItem> _filteredData = propertyData.filteredItems;

    return _filteredData.isEmpty
        ? Container()
        : Container(
            height: height,
            child: Column(
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      TextButton(
                        child: AutoSizeText(
                          'حذف البحث',
                          overflow: TextOverflow.ellipsis,
                          textScaleFactor:
                              MediaQuery.of(context).textScaleFactor,
                          minFontSize: 9,
                          style: Theme.of(context).textTheme.bodyText1!.copyWith(
                              color: Theme.of(context).accentColor,
                              fontWeight: FontWeight.bold),
                        ),
                        onPressed: () =>
                            Provider.of<Property>(context, listen: false)
                                .clearFilters(),
                      ),
                      AutoSizeText(
                        'نتائج البحث',
                        overflow: TextOverflow.ellipsis,
                        textScaleFactor: MediaQuery.of(context).textScaleFactor,
                        minFontSize: 9,
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            color: Theme.of(context).primaryColorLight,
                            fontWeight: FontWeight.bold),
                      ),
                    ]),
                Expanded(
                  child: Card(
                    elevation: 6.0,
                    shadowColor: Theme.of(context).accentColor,
                    color: Theme.of(context).backgroundColor,
                    child: AnimationLimiter(
                      child: ListView.builder(
                        padding: EdgeInsets.all(0),
                        scrollDirection: Axis.vertical,
                        itemCount: _filteredData.length,
                        itemBuilder: (BuildContext ctx, int index) {
                          return AnimationConfiguration.staggeredList(
                            position: index,
                            duration: const Duration(milliseconds: 800),
                            child: ChangeNotifierProvider.value(
                              value: _filteredData[index],
                              child: SlideAnimation(
                                verticalOffset: 50.0,
                                child: FadeInAnimation(
                                  child: PropertyItemForFilter(height: height),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
  }
}
