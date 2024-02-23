import 'package:alshamel_new/helper/http_exception.dart';
import 'package:alshamel_new/providers/auth.dart';
import 'package:alshamel_new/providers/property_providers/favorites.dart';
import 'package:alshamel_new/providers/used_items_providers/used_item.dart';
import 'package:alshamel_new/providers/used_items_providers/used_items.dart';
import 'package:alshamel_new/screens/used_items/usedItems_homepage_screen.dart';
import 'package:alshamel_new/widgets/used_items_widgets/usedItem_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:intl/intl.dart' as intl1;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';

class UsedItemReviewScreen extends StatelessWidget {
  static const routeName = '/usedItem-details';

  void _goBack(context) {
    Navigator.pop(context);
  }

  void _showErrorDialog(context, String error) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text(error),
              content: Text('يرجى إعادة المحاولة'),
              actions: <Widget>[
                TextButton(onPressed: () {}, child: Text('OK'))
              ],
            ));
  }

  void _showSuccessDialog(context, String message) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.SUCCES,
      animType: AnimType.LEFTSLIDE,
      desc: message,
      btnOkIcon: Icons.check_circle,
      btnOkOnPress: () {},
      btnOkColor: Theme.of(context).primaryColor,
      onDissmissCallback: (_) => {},
    ).show().then((_) => Navigator.pop(context));
  }

  void _sendReport(context, String repoMsg, int useditemid) async {
    try {
      await Provider.of<Auth>(context, listen: false)
          .sendMsgToAdmin(
              title: 'إبلاغ عن إعلان رقم $useditemid ', text: repoMsg,isreport: '1')
          .then((_) =>
              _showSuccessDialog(context, 'تم إرسال إبلاغك إلى الإدارة '));
    } catch (error) {
      var errorMessage = error.toString();
      _showErrorDialog(context, errorMessage);
    }
  }

  void _displayTextInputDialog(BuildContext context, int useditemid) {
    String? valueText;
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: TextField(
              textDirection: TextDirection.rtl,
              keyboardType: TextInputType.multiline,
              maxLines: 3,
              onChanged: (value) {
                valueText = value;
              },
              decoration: InputDecoration(
                  hintText: "أدخل سبب الإبلاغ",
                  hintTextDirection: TextDirection.rtl),
            ),
            actions: <Widget>[
              TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      Colors.red,
                    ),
                  ),
                  child: Text(
                    'إلغاء',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () => Navigator.pop(context)),
              TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    Theme.of(context).accentColor,
                  ),
                ),
                child: Text(
                  'إرسال',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () => _sendReport(context, valueText!, useditemid),
              ),
            ],
          );
        });
  }

  Widget report(context, int useditemid) {
    return TextButton.icon(
      onPressed: () => _displayTextInputDialog(context, useditemid),
      icon: Icon(
        Icons.report,
        color: Colors.red,
      ),
      label: Text(
        'إبلاغ',
        style: TextStyle(color: Colors.red),
      ),
    );
  }

  Widget makeListItem(context, dynamic name, dynamic details) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        AutoSizeText(
          name,
          overflow: TextOverflow.ellipsis,
          textScaleFactor: MediaQuery.of(context).textScaleFactor,
          style: Theme.of(context)
              .textTheme
              .bodyText1!
              .copyWith(fontWeight: FontWeight.bold),
          textDirection: TextDirection.rtl,
        ),
        AutoSizeText(
          details.toString(),
          //overflow: TextOverflow.ellipsis,
          textScaleFactor: MediaQuery.of(context).textScaleFactor,
          style: Theme.of(context).textTheme.bodyText2,
          textDirection: TextDirection.rtl,
        ),
        Divider(
          color: Theme.of(context).accentColor,
        )
      ],
    );
  }

  Widget listOfDetails(context, UsedItem useditem) {
    return Column(children: [
      makeListItem(
          context, 'البائع', '${useditem.firstname} '/*${useditem.lastname}*/' '),
      makeListItem(context, 'المشاهدات', useditem.views??0),
      makeListItem(context, 'ملاحظات', useditem.dimensions),
    ]);
  }

  Widget description(context, String desc) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        AutoSizeText(
          'الوصف',
          overflow: TextOverflow.ellipsis,
          textScaleFactor: MediaQuery.of(context).textScaleFactor,
          textDirection: TextDirection.rtl,
          style: Theme.of(context).textTheme.bodyText1!.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).accentColor),
        ),
        AutoSizeText(
          desc,
          //overflow: TextOverflow.ellipsis,
          textScaleFactor: MediaQuery.of(context).textScaleFactor,
          textDirection: TextDirection.rtl,
          style: Theme.of(context)
              .textTheme
              .bodyText2!
              .copyWith(color: Theme.of(context).primaryColorLight),
        ),
      ],
    );
  }

  Widget simpleDetailsContainer(context, UsedItem item) {
    return ListTile(
      leading: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: new LinearGradient(
              colors: [
                Theme.of(context).accentColor,
                Theme.of(context).primaryColorLight,
              ],
            )
            //color: Theme.of(context).primaryColorLight,
            ),
        padding: const EdgeInsets.all(10),
        child: AutoSizeText(
          'رقم الإعلان : ${item.useditemsid}',
          //overflow: TextOverflow.ellipsis,
          textScaleFactor: MediaQuery.of(context).textScaleFactor,
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .bodyText2!
              .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      title: AutoSizeText(
          '${item.title} (${item.usedtypename})',
          //overflow: TextOverflow.ellipsis,
          textScaleFactor: MediaQuery.of(context).textScaleFactor,
          textDirection: TextDirection.rtl,
          style: Theme.of(context).textTheme.bodyText1!.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor),

      ),
      subtitle: AutoSizeText(
        item.cityname??"",
        //overflow: TextOverflow.ellipsis,
        textScaleFactor: MediaQuery.of(context).textScaleFactor,
        textDirection: TextDirection.rtl,
        style: Theme.of(context).textTheme.bodyText1!.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColorLight),
      ),
    );
  }

  Widget contact(context, UsedItem item) {
    int? whatsupNum = item.phone;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        AutoSizeText(
          'للتواصل',
          overflow: TextOverflow.ellipsis,
          minFontSize: 9,
          textScaleFactor: MediaQuery.of(context).textScaleFactor,
          style: Theme.of(context).textTheme.bodyText1!.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColorLight),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            whatsupNum != null
                ? TextButton.icon(
                    icon: Icon(
                      Icons.message_outlined,
                      color: Theme.of(context).accentColor,
                    ),
                    label: AutoSizeText(
                      'محادثة',
                      overflow: TextOverflow.ellipsis,
                      textScaleFactor: MediaQuery.of(context).textScaleFactor,
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Theme.of(context).primaryColorLight),
                    ),
                    onPressed: () => launch(
                          'whatsapp://send?phone=+963$whatsupNum',
                        ))
                : Container(),
            TextButton.icon(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                    Theme.of(context).primaryColorLight),
              ),
              icon: Icon(Icons.phone_android_outlined,
                  color: Theme.of(context).accentColor),
              label: Text(whatsupNum.toString()!, style: TextStyle(color: Colors.white)),
              onPressed: () => launch('tel:$whatsupNum'),
            )
          ],
        )
      ],
    );
  }

  Widget makeIcons(IconData ic, String label, context) {
    return FittedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            ic,
            color: Theme.of(context).primaryColor,
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyText2,
          )
        ],
      ),
    );
  }

  void updateFavoState(int isfav, context, UsedItem item) async {
    final owner = Provider.of<Auth>(context, listen: false).ownerId;

    if (isfav == -1) {
      await Provider.of<Favorites>(context, listen: false)
          .insertFavoriteUsedItem(useditem: item, ownerid: owner!);
    } else {
      await Provider.of<Favorites>(context, listen: false)
          .deleteFavoriteUsedItem(useditemid: item.useditemsid!, ownerid: owner!);
    }
  }

  void _shareMessage(UsedItem item) async {
    String msg1 =
        'مرحبا بكم في تطبيق الشامل يسرّنا مشاركة إعلانات عامة معكم.\n';
    String msg2 = 'إعلان : ${item.title}\n';
    String msg3 = 'رقم الإعلان : ${item.useditemsid}\n';
    String msg4 = 'المدينة : ${item.cityname}\n';
    String msg5 = 'السعر : ${item.price}\n';
    String msg6 = 'لمشاهدة كامل التفاصيل .\n';
    String link =
        'https://alshamel-sy.com/mobile_view/used_items_dfetails/used_items_details.php?adsid=${item.useditemsid}';
    String contactUs = '\n\n لأي استفسار تواصل معنا على الرقم: ${item.phone}';
    String fullMsg = msg1 + msg2 + msg3 + msg4 + msg5 + msg6 + link + contactUs;
    var url = "https://wa.me/?text=$fullMsg";

    var encoded = Uri.encodeFull(url);
    await launch(encoded);
  }

  Widget fourIconsDetails(context, UsedItem item) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
          onTap: () => _shareMessage(item),
          child: makeIcons(Icons.share_outlined, 'مشاركة', context),
        ),
        Consumer<Favorites>(
          builder: (ctx, fav, child) => InkWell(
            onTap: Provider.of<Auth>(context, listen: false).isAuth
                ? () => updateFavoState(
                      fav.usedItemIsFavorite(item.useditemsid!),
                      ctx,
                      item,
                    )
                : () {},
            child: makeIcons(
                fav.usedItemIsFavorite(item.useditemsid!) != -1
                    ? Icons.favorite
                    : Icons.favorite_border_outlined,
                'حفظ في المفضلة',
                context),
          ),
        ),
        makeIcons(Icons.date_range, '${item.addeddate}', context),
      ],
    );
  }

  void _showAllItems(List<UsedItem> it, context) {
    Provider.of<UsedItems>(context, listen: false).setFilters(filtered: it);
    Navigator.of(context).pushNamed(UsedItemsHomePage.routeName);
  }

  Widget moreUsedItems(context, List<UsedItem> moreitems) {
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
              onPressed: () => _showAllItems(moreitems, context),
            ),
            AutoSizeText(
              'أدوات مستعملة من ذات الفئة',
              overflow: TextOverflow.ellipsis,
              textDirection: TextDirection.rtl,
              textScaleFactor: MediaQuery.of(context).textScaleFactor,
              minFontSize: 9,
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  color: Theme.of(context).primaryColorLight,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
        Expanded(
          child: ListView.builder(
            reverse: true,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: moreitems.length,
            itemBuilder: (BuildContext ctx, int index) {
              return ChangeNotifierProvider.value(
                value: moreitems[index],
                child: UsedItemWidget(),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget appBar(context) {
    return AppBar(
      leading: Container(),
      backgroundColor: Theme.of(context).primaryColor,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: IconButton(
            onPressed: () => _goBack(context),
            icon: Icon(
              Icons.arrow_forward,
              color: Theme.of(context).accentColor,
            ),
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

    final useditemid = ModalRoute.of(context)!.settings.arguments as int;

    return Scaffold(
      appBar: PreferredSize(preferredSize: Size.fromHeight(56),
      child: appBar(context)),
      body: FutureBuilder(
        future: Future.wait([
          Provider.of<UsedItems>(context, listen: false)
              .getUsedItemByID(useditemid),
          Provider.of<UsedItem>(context, listen: false)
              .increaseViews(itemid: useditemid)
        ]).catchError((Object e, StackTrace stackTrace) {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text('حدث خطأ'),
              content: Text(
                e.toString(),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                )
              ],
            ),
          );
        }, test: (e) => e is HttpException),
        builder: (BuildContext ctx, AsyncSnapshot snapshotData) {
          if (snapshotData.hasError) {
            return const Center(
              child: Text('تحقق من وجود الانترنت'),
            );
          }
          if (snapshotData.connectionState == ConnectionState.waiting) {
            return const Center(
              child: const CircularProgressIndicator(),
            );
          } else {
            UsedItem useditem =
                Provider.of<UsedItems>(context, listen: false).itemById;
            var priceFormat = intl1.NumberFormat.currency(symbol: '');
            int num = useditem.price!;
            String price = priceFormat.format(num);
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Card(
                    elevation: 6,
                    shadowColor: Theme.of(context).primaryColorLight,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(50),
                          bottomRight: Radius.circular(50)),
                    ),
                    child: Container(
                      //padding: const EdgeInsets.all(8),
                      width: containerHeight * .3,
                      height: containerHeight * .25,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(50),
                          bottomRight: Radius.circular(50),
                        ),
                        child: useditem.mainphoto!=null
                            ?CachedNetworkImage(
                          imageUrl: useditem.mainphoto!,
                          cacheKey: useditem.mainphoto!+DateTime.now().second.toString(),
                          fit: BoxFit.cover,
                        )
                       /* Image.network(
                          "https://alshamel.tadproducts.xyz${useditem.mainphoto}",
                                fit: BoxFit.fill,
                              )*/
                            : Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: SvgPicture.asset(
                                  'assets/images/shopping.svg',
                                  fit: BoxFit.contain,

                                  // height: devicewidth * .4,
                                ),
                              ),
                      ),
                    ),
                  ),
                  Card(
                    elevation: 3,
                    shadowColor: Theme.of(context).accentColor,
                    child: Container(
                      //height: containerHeight * .15,
                      padding: const EdgeInsets.all(8.0),
                      child: simpleDetailsContainer(context, useditem),
                    ),
                  ),
                  Card(
                    elevation: 3,
                    child: Container(
                      height: containerHeight * .1,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 8.0),
                      child: fourIconsDetails(context, useditem),
                    ),
                  ),
                  Card(
                    elevation: 3,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25.0, vertical: 20.0),

                      child: Center(child: listOfDetails(context, useditem)),
                    ),
                  ),
                  Card(
                    elevation: 3,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          AutoSizeText(
                            '$price S.P',
                            overflow: TextOverflow.ellipsis,
                            textScaleFactor:
                                MediaQuery.of(context).textScaleFactor,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(
                                    color: Theme.of(context).primaryColorLight),
                          ),
                          AutoSizeText(
                            'السعر',
                            overflow: TextOverflow.ellipsis,
                            textScaleFactor:
                                MediaQuery.of(context).textScaleFactor,
                            textDirection: TextDirection.rtl,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).accentColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                  useditem.description!.isEmpty
                      ? Container()
                      : Card(
                          elevation: 3,
                          child: Container(
                            width: double.infinity,
                            //height: containerHeight * .15,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 25.0, vertical: 10.0),
                            child: description(context, useditem.description??""),
                          ),
                        ),
                  Card(
                    elevation: 3,
                    child: Container(
                      //height: containerHeight * .2,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25.0, vertical: 20.0),
                      child: contact(context, useditem),
                    ),
                  ),
                  Provider.of<Auth>(context, listen: false).isAuth
                      ? Card(
                          elevation: 3,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: report(context, useditem.useditemsid!),
                          ),
                        )
                      : Container(),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    height: ((containerHeight) * .94) * .4,
                    child: Consumer<UsedItems>(
                      builder: (ctx, all, child) => moreUsedItems(
                        context,
                        all.getUsedItemsSameCategory(useditem.itemtypeid!),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
