import 'package:alshamel_new/providers/car_providers/car_item.dart';
import 'package:alshamel_new/providers/car_providers/cars.dart';
import 'package:alshamel_new/widgets/cars_widgets/car_item_for_filters.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CarFilteredItems extends StatelessWidget {
  const CarFilteredItems({
    @required this.height,
  });

  final height;

  @override
  Widget build(BuildContext context) {
    final carsData = Provider.of<Cars>(context, listen: false);
    List<CarItem> _filteredData = carsData.filtereditems;

    return Card(
      elevation: 6.0,
      shadowColor: Theme.of(context).accentColor,
      color: Theme.of(context).backgroundColor,
      child: Container(
        height: height,
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
                    onPressed: () => Provider.of<Cars>(context, listen: false)
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
                    child: CarItemForFilters(),
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
