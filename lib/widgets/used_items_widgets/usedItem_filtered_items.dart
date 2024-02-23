import 'package:alshamel_new/providers/used_items_providers/used_item.dart';
import 'package:alshamel_new/providers/used_items_providers/used_items.dart';
import 'package:alshamel_new/widgets/used_items_widgets/usedItem_for_filters.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UsedItemsFilteredItems extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<UsedItem> _filteredData =
        Provider.of<UsedItems>(context, listen: false).filtereditems;
    return Card(
      elevation: 6.0,
      shadowColor: Theme.of(context).accentColor,
      color: Theme.of(context).backgroundColor,
      child: Container(
        //height: height,
        color: Theme.of(context).backgroundColor,
        child: Column(
          children: [
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  TextButton(
                    child: Text(
                      'حذف البحث',
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          color: Theme.of(context).accentColor,
                          fontWeight: FontWeight.bold),
                    ),
                    onPressed: () =>
                        Provider.of<UsedItems>(context, listen: false)
                            .clearFilters(),
                  ),
                  Text(
                    'نتائج البحث',
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        color: Theme.of(context).primaryColorLight,
                        fontWeight: FontWeight.bold),
                  ),
                ]),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(0),
                scrollDirection: Axis.vertical,
                itemCount: _filteredData.length,
                itemBuilder: (BuildContext ctx, int index) {
                  return ChangeNotifierProvider.value(
                    value: _filteredData[index],
                    child: UsedItemForFilters(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
