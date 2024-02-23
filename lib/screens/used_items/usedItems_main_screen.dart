import 'package:alshamel_new/providers/used_items_providers/used_item.dart';
import 'package:alshamel_new/providers/used_items_providers/used_item_type.dart';
import 'package:alshamel_new/providers/used_items_providers/used_items.dart';
import 'package:alshamel_new/widgets/used_items_widgets/usedItem_filtered_items.dart';
import 'package:alshamel_new/widgets/used_items_widgets/usedItem_widget.dart';
import 'package:alshamel_new/widgets/used_items_widgets/useditems_filters_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class UsedItemsMainScreen extends StatefulWidget {
  static const routeName = '/main-screen';
  @override
  _UsedItemsMainScreenState createState() => _UsedItemsMainScreenState();
}

class _UsedItemsMainScreenState extends State<UsedItemsMainScreen> {
  bool isloading = false;
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

  void _showAllItems(List<UsedItem> it) =>
      Provider.of<UsedItems>(context, listen: false).setFilters(filtered: it);

  Widget _categories(context, List<UsedItemType> items) {
    return Column(
      children: [
        AutoSizeText(
          'التصنيفات',
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
                crossAxisSpacing: 4.0,
                childAspectRatio: MediaQuery.of(context).size.width /
                    (MediaQuery.of(context).size.height / 1.5),
              ),
              reverse: true,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              itemBuilder: (BuildContext ctx, int index) {
                return AnimationConfiguration.staggeredGrid(
                  position: index,
                  duration: const Duration(milliseconds: 800),
                  columnCount: 2,
                  child: SlideAnimation(
                    horizontalOffset: 50.0,
                    child: FadeInAnimation(
                      child: ChangeNotifierProvider.value(
                        value: items[index],
                        child: InkWell(
                          onTap: () {
                            bool result = Provider.of<UsedItems>(context,
                                    listen: false)
                                .setFilters(type: items[index].useditemtypeid);
                            if (!result) {
                              _showErrorDialog('لا يوجد عناصر في هذه الفئة');
                            }
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.0)),
                            ),
                            color: Theme.of(context).backgroundColor,
                            elevation: 4.0,
                            child: Container(
                              padding: const EdgeInsets.all(4.0),
                              width: MediaQuery.of(context).size.width * .1,
                              height: MediaQuery.of(context).size.width * .1,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.0),
                                gradient: new LinearGradient(
                                  colors: [
                                    Theme.of(context).primaryColor,
                                    Theme.of(context).accentColor,
                                  ],
                                ),
                              ),
                              child: AutoSizeText(
                                items[index].usedtypename??"",
                                overflow: TextOverflow.ellipsis,
                                textScaleFactor:
                                    MediaQuery.of(context).textScaleFactor,
                                minFontSize: 9,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2!
                                    .copyWith(
                                      color: Colors.white,
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

  Widget _section(context, List<UsedItem> secitems, String title) {
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
                child: UsedItemWidget(),
              );
            },
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final topPadding = MediaQuery.of(context).padding.top;
    final bottomPading = MediaQuery.of(context).padding.bottom;
    final availableSpace = deviceHeight - topPadding - bottomPading;
    final containerHeight = availableSpace - AppBar().preferredSize.height;
    final bodysection1 = (containerHeight) * .06;
    //final bodysection2 = (containerHeight) * .94;
    final usedItemData = Provider.of<UsedItems>(context);
    List<UsedItemType> types =
        Provider.of<UsedItemType>(context, listen: false).types;

    return Container(
      margin: EdgeInsets.only(top: topPadding, bottom: bottomPading),
      height: containerHeight,
      child: Column(
        children: [
          Container(
            height: bodysection1,
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: UsedItemsFiltersBar(),
                ),
              ],
            ),
          ),
          Expanded(
            child: usedItemData.filtereditems.isNotEmpty
                ? UsedItemsFilteredItems()
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(5.0),
                    child: Column(
                      children: [
                        Container(
                          height: containerHeight * .3,
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: _categories(
                            context,
                            types,
                          ),
                        ),
                        Container(
                          height: containerHeight * .43,
                          margin: const EdgeInsets.symmetric(vertical: 4.0),
                          child: _section(
                            context,
                            usedItemData.items,
                            'إعلانات عامة',
                          ),
                        ),
                        Container(
                          height: containerHeight * .43,
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: _section(
                            context,
                            usedItemData.itemsByViews,
                            'الأكثر مشاهدة',
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
