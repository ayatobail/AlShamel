import 'package:alshamel_new/providers/car_providers/car_item.dart';
import 'package:alshamel_new/providers/car_providers/car_manufacture.dart';
import 'package:alshamel_new/providers/car_providers/car_type.dart';
import 'package:alshamel_new/providers/car_providers/cars.dart';
import 'package:alshamel_new/widgets/cars_widgets/car_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class CarsListsScreen extends StatefulWidget {
  final containerHeight;
  CarsListsScreen({this.containerHeight});

  @override
  _CarsListsScreenState createState() => _CarsListsScreenState();
}

class _CarsListsScreenState extends State<CarsListsScreen> {
  bool isloading = false;

  void _showAllItems(List<CarItem> it) =>
      Provider.of<Cars>(context, listen: false).setFilters(filtered: it);

  void _showErrorDialog(String message) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.INFO,
      animType: AnimType.BOTTOMSLIDE,
      customHeader: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(
          Icons.notifications,
          color: Theme.of(context).primaryColorLight,
        ),
      ),
      desc: message,
      btnOkOnPress: () {},
      btnOkColor: Theme.of(context).accentColor,
    ).show();
  }

  Widget _manufactures(context, List<CarManufacture> items) {
    return Column(
      children: [
        AutoSizeText(
          'حسب الطراز',
          overflow: TextOverflow.ellipsis,
          textDirection: TextDirection.rtl,
          textScaleFactor: MediaQuery.of(context).textScaleFactor,
          minFontSize: 9,
          style: Theme.of(context).textTheme.bodyText1!.copyWith(
                color: Theme.of(context).primaryColorLight,
                fontWeight: FontWeight.bold,
              ),
        ),
        Expanded(
          child: AnimationLimiter(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 5.0,
                childAspectRatio: MediaQuery.of(context).size.width /
                    (MediaQuery.of(context).size.height / 2),
              ),
              reverse: true,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              itemBuilder: (BuildContext ctx, int index) {
                return AnimationConfiguration.staggeredGrid(
                  position: index,
                  duration: const Duration(milliseconds: 1000),
                  columnCount: 2,
                  child: SlideAnimation(
                    horizontalOffset: 50.0,
                    child: FadeInAnimation(
                      child: ChangeNotifierProvider.value(
                        value: items[index],
                        child: InkWell(
                          onTap: () {
                            bool res = Provider.of<Cars>(context, listen: false)
                                .setFilters(
                                       manufacture: items[index].companyname);
                            if (!res)
                              _showErrorDialog(
                                  'لا يوجد مركبات متوفرة لهذا الطراز');
                          },
                          child: Card(
                            color: Colors.white,
                            shadowColor: Theme.of(context).accentColor,
                            elevation: 3.0,
                            child: Container(
                              width: MediaQuery.of(context).size.width * .2,
                              height: MediaQuery.of(context).size.width * .2,
                              alignment: Alignment.center,
                              margin: EdgeInsets.all(8.0),
                              padding: EdgeInsets.all(4.0),
                              child: items[index].companylogo!=null
                                  ? Image.network(
                                      items[index].companylogo!,
                                      fit: BoxFit.cover,
                                    )
                                  : AutoSizeText(
                                      items[index].companyname??"",
                                      overflow: TextOverflow.ellipsis,
                                      textScaleFactor: MediaQuery.of(context)
                                          .textScaleFactor,
                                      minFontSize: 9,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .copyWith(
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _section(context, List<CarItem> secitems, String title) {
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
            itemCount: (secitems.length),
            itemBuilder: (BuildContext ctx, int index) {
              return ChangeNotifierProvider.value(
                value: secitems[index],
                child: CarItemWidget(),
              );
            },
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final carsData = Provider.of<Cars>(context, listen: false);
    final carsManufacture = Provider.of<CarManufacture>(context, listen: false);
    List<CarType> types = Provider.of<CarType>(context, listen: false).carTypes;

    return Card(
      elevation: 4.0,
      shadowColor: Theme.of(context).accentColor,
      color: Theme.of(context).backgroundColor,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: [
            Container(
              height: widget.containerHeight * .43,
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: _manufactures(
                context,
                carsManufacture.carManufactures,
              ),
            ),
            Container(
              height: widget.containerHeight * .43,
              margin: const EdgeInsets.symmetric(vertical: 4.0),
              child: _section(
                context,
                carsData.newlyCars,
                'المركبات الأحدث',
              ),
            ),
            carsData.getSameType(types[0].typeid!).isNotEmpty
                ? Container(
                    height: widget.containerHeight * .43,
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: _section(
                      context,
                      carsData.getSameType(types[0].typeid!),
                      types[0].typename!,
                    ),
                  )
                : Container(),
            Container(
              height: widget.containerHeight * .43,
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: _section(
                context,
                carsData.items,
                'جميع المركبات',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
