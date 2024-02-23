import 'package:alshamel_new/models/property_models.dart/detail_value.dart';
import 'package:alshamel_new/models/property_models.dart/extra_fields.dart';
import 'package:alshamel_new/providers/auth.dart';
import 'package:alshamel_new/providers/property_providers/favorites.dart';
import 'package:alshamel_new/providers/property_providers/property.dart';
import 'package:alshamel_new/providers/property_providers/property_item.dart';
import 'package:alshamel_new/screens/property/property_homepage_screen.dart';
import 'package:alshamel_new/widgets/property_widgets/carousel_slider_images.dart';
import 'package:alshamel_new/widgets/property_widgets/property_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:intl/intl.dart' as intl1;

class PropertyDetailsScreen extends StatelessWidget {
  static const routeName = '/property-details';
  void _goBack(context) {
    Navigator.pop(context);
  }

  Widget simpleDetailsContainer(context, PropertyItem property) {
    return ListTile(
      leading: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
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
          'رقم الإعلان : ${property.propertyId}',
          overflow: TextOverflow.ellipsis,
          textScaleFactor: MediaQuery.of(context).textScaleFactor,
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .bodyText2!
              .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      title: AutoSizeText(
        property.propertyTypeName??"",
        //overflow: TextOverflow.ellipsis,
        textScaleFactor: MediaQuery.of(context).textScaleFactor,
        textDirection: TextDirection.rtl,
        style: Theme.of(context).textTheme.bodyText1!.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColorLight),
      ),
      subtitle: AutoSizeText(
        property.operationTypeName??"",
        //overflow: TextOverflow.ellipsis,
        textScaleFactor: MediaQuery.of(context).textScaleFactor,
        textDirection: TextDirection.rtl,
        style: Theme.of(context).textTheme.bodyText1!.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColorLight),
      ),
    );
  }

  Widget addressDetails(context, PropertyItem property) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Icon(
          Icons.pin_drop_outlined,
          color: Theme.of(context).accentColor,
          size: 60,
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              AutoSizeText(
                property.cityName??"",
                //overflow: TextOverflow.ellipsis,
                textScaleFactor: MediaQuery.of(context).textScaleFactor,
                textAlign: TextAlign.right,
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColorLight),
              ),
              AutoSizeText(
                property.location??"",
                //overflow: TextOverflow.ellipsis,
                textScaleFactor: MediaQuery.of(context).textScaleFactor,
                textAlign: TextAlign.right,
                style: Theme.of(context).textTheme.bodyText2!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColorLight),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget makeListItem(context, String name, dynamic details) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        AutoSizeText(
          name,
          //overflow: TextOverflow.ellipsis,
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

  Widget listOfDetails(context, PropertyItem property) {
    var priceFormat = intl1.NumberFormat.currency(symbol: '');
    int num = int.parse(property.price.toString()!.split('.')[0]);
    String price = priceFormat.format(num);
    final List<DetailsValues>? details =
        Provider.of<PropertyItem>(context, listen: false).details;
    return Column(children: [
      makeListItem(context, 'المساحة ', '${property.areasize} م²'),
      makeListItem(context, 'السعر', price),
      ...details!.map((e) => makeListItem(context, e!.name!, e!.value!)),
      makeListItem(context, 'المشاهدات', property.views??0),
      makeListItem(context, 'نوع الاكساء ', property.status),
      makeListItem(context, 'الملاحظات ', property.notes),
    ]);
  }

  Widget additionalInfo(context) {
    final List<ExtraFields> extra =
        Provider.of<PropertyItem>(context, listen: false).extrafields;
    //print(extra.length);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        AutoSizeText(
          'معلومات إضافية',
          overflow: TextOverflow.ellipsis,
          textScaleFactor: MediaQuery.of(context).textScaleFactor,
          style: Theme.of(context).textTheme.bodyText1!.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColorLight),
        ),
        ...extra.map((e) => makeListItem(context, e.name, e.value))
      ],
    );
  }

  Widget contact(context, PropertyItem property) {
    String? whatsupNum;
    if (property.phone3 != '0' && property.phone3.toString()!.startsWith('09')) {
      whatsupNum = property.phone3!;
    }
    if (property.phone2 != '0' && property.phone2.toString()!.startsWith('09')) {
      whatsupNum = property.phone2!;
    }
    if (property.phone1 != '0' && property.phone1.toString()!.startsWith('09')) {
      whatsupNum = property.phone1!;
    }
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
                          'whatsapp://send?phone=+963${whatsupNum.toString()!.substring(1)}}',
                        ))
                : Container(),
            property.phone1 == '0' &&
                    property.phone2 == '0' &&
                    property.phone3 == '0'
                ? Container(
                    child: Text('لا تتوفر أرقام للتواصل'),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      property.phone1 != '0'
                          ? TextButton.icon(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Theme.of(context).primaryColorLight),
                              ),
                              icon: Icon(Icons.phone_android_outlined,
                                  color: Theme.of(context).accentColor),
                              label: Text(property.phone1.toString(),
                                  style: TextStyle(color: Colors.white)),
                              onPressed: () => launch('tel:${property.phone1}'))
                          : Container(),
                      property.phone2 != '0'
                          ? TextButton.icon(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Theme.of(context).primaryColorLight)),
                              icon: Icon(Icons.phone_android_outlined,
                                  color: Theme.of(context).accentColor),
                              label: Text(property.phone2.toString(),
                                  style: TextStyle(color: Colors.white)),
                              onPressed: () => launch('tel:${property.phone2}'),
                            )
                          : Container(),
                      property.phone3 != '0'
                          ? TextButton.icon(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Theme.of(context).primaryColorLight)),
                              icon: Icon(Icons.phone_android_outlined,
                                  color: Theme.of(context).accentColor),
                              label: Text(property.phone3.toString(),
                                  style: TextStyle(color: Colors.white)),
                              onPressed: () => launch('tel:${property.phone3}'))
                          : Container(),
                    ],
                  ),
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

  void updateFavoState(int isfav, context, PropertyItem propertyItem) async {
    final owner = Provider.of<Auth>(context, listen: false).ownerId;
    print('Update Fvs');
    if (isfav == -1) {
      await Provider.of<Favorites>(context, listen: false)
          .insertFavoriteProperty(property: propertyItem, ownerid: owner!);
    } else {
      await Provider.of<Favorites>(context, listen: false)
          .deleteFavoriteProperty(
              propertyid: propertyItem.propertyId!, ownerid: owner!);
    }
  }

  void _shareMessage(PropertyItem property) async {
    String msg1 = 'مرحبا بكم في تطبيق الشامل يسرّنا مشاركة عقار معكم.\n';
    String msg2 = ' إعلان : ${property.title}\n';
    String msg3 = 'رقم إعلان العقار : ${property.propertyId}\n';

    String msg4 = 'المدينة : ${property.cityName}\n';
    String msg5 = 'السعر : ${property.price}\n';
    String msg6 = 'لمشاهدة كامل تفاصيل العقار .\n\n';

    String link =
        'https://alshamel-sy.com/mobile_view/property_details/property_details.php?akarid=${property.propertyId}';
    String contactUs =
        '\n\n لأي استفسار تواصل معنا على الرقم: ${property.phone1}';
    String fullMsg = msg1 + msg2 + msg3 + msg4 + msg5 + msg6 + link + contactUs;
    var url = "https://wa.me/?text=$fullMsg";

    var encoded = Uri.encodeFull(url);
    await launch(encoded);
  }

  Widget fourIconsDetails(context, PropertyItem property) {
    var length2 =
        Provider.of<PropertyItem>(context, listen: false).images.length;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
          onTap: () => _shareMessage(property),
          child: makeIcons(Icons.share_outlined, 'مشاركة', context),
        ),
        Consumer<Favorites>(
          builder: (ctx, fav, child) => InkWell(
            onTap: Provider.of<Auth>(context, listen: false).isAuth
                ? () => updateFavoState(
                    fav.proisFavorite(property.propertyId!), ctx, property)
                : () {},
            child: makeIcons(
                fav.proisFavorite(property.propertyId!) != -1
                    ? Icons.favorite
                    : Icons.favorite_border_outlined,
                'حفظ في المفضلة',
                context),
          ),
        ),
        makeIcons(Icons.camera_enhance_outlined, '$length2', context),
        makeIcons(Icons.date_range_outlined, property.approveDate??"", context),
      ],
    );
  }

  void _showAllItems(List<PropertyItem> it, context) {
    Provider.of<Property>(context, listen: false).setFilters(filtered: it);
    Navigator.of(context).pushNamed(PropertyHomePage.routeName);
  }

  void _showSuccessDialog(context, String message) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.SUCCES,
      animType: AnimType.LEFTSLIDE,
      desc: message,
      btnOkIcon: Icons.check_circle,
      btnOkOnPress: () {
        //Navigator.of(context).pop();
      },
      btnOkColor: Theme.of(context).primaryColor,
      onDissmissCallback: (_) => {},
    ).show().then((_) => Navigator.pop(context));
  }

  void _showErrorDialog(context, String error) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text(error),
              content: Text('يرجى إعادة المحاولة'),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      //Navigator.of(context).pop();
                    },
                    child: Text('OK'))
              ],
            ));
  }

  void _sendReport(context, String repoMsg, String propertyId) async {
    //print('إبلاغ عن عقار رقم $propertyId ');
    try {
      await Provider.of<Auth>(context, listen: false)
          .sendMsgToAdmin(
              title: 'إبلاغ عن عقار رقم $propertyId ', text: repoMsg,isreport: '1')
          .then((_) =>
              _showSuccessDialog(context, 'تم إرسال إبلاغك إلى الإدارة '));
    } catch (error) {
      var errorMessage = error.toString();
      print(errorMessage);
      _showErrorDialog(context, errorMessage);
    }
  }

  void _displayTextInputDialog(BuildContext context, String propertyId) {
    String? valueText;
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            //title: Text('إرسال إبلاغ'),
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
                onPressed: () => _sendReport(context, valueText!, propertyId),
              ),
            ],
          );
        });
  }

  Widget report(context, String propertyId) {
    return TextButton.icon(
      onPressed: () => _displayTextInputDialog(context, propertyId),
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

  Widget moreProperty(context, List<PropertyItem> allProperty) {
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
              onPressed: () => _showAllItems(allProperty, context),
            ),
            AutoSizeText(
              'عقارات في ذات المدينة',
              overflow: TextOverflow.ellipsis,
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
            itemCount: allProperty.length,
            itemBuilder: (BuildContext ctx, int index) {
              return ChangeNotifierProvider.value(
                  value: allProperty[index], child: PropertyItemWidget());
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

    final propertyItem =
        ModalRoute.of(context)!.settings.arguments as PropertyItem;

    return Scaffold(
        appBar:PreferredSize(preferredSize: Size.fromHeight(56),
        child: appBar(context)),
        body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CarouselSliderImages(
                  containerHeight: containerHeight * .3,
                  images:
                      Provider.of<PropertyItem>(context, listen: false).images,
                ),
                Card(
                  elevation: 3,
                  child: Container(
                    alignment: Alignment.center,
                    //height: containerHeight * .15,
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: simpleDetailsContainer(context, propertyItem),
                  ),
                ),
                Card(
                  elevation: 3,
                  child: Container(
                    //height: containerHeight * .1,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 8.0),
                    child: fourIconsDetails(context, propertyItem),
                  ),
                ),
                Card(
                    elevation: 2,
                    shadowColor: Theme.of(context).accentColor,
                    child: Container(
                      color: Theme.of(context).backgroundColor,
                      width: double.infinity,
                      //height: containerHeight * .2,
                      padding: EdgeInsets.symmetric(horizontal: 25.0,vertical: 20),
                      child: addressDetails(context, propertyItem),
                    )),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient: new LinearGradient(
                        colors: [
                          Theme.of(context).primaryColor,
                          Theme.of(context).accentColor,
                        ],
                      )
                      //color: Theme.of(context).primaryColorLight,
                      ),
                  padding: const EdgeInsets.all(10),
                  child: AutoSizeText(
                    'نوع الملكية / ${propertyItem.propertyRegestrationTypeName}',
                    overflow: TextOverflow.ellipsis,
                    textScaleFactor: MediaQuery.of(context).textScaleFactor,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyText2!.copyWith(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                Card(
                  elevation: 3,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25.0, vertical: 20.0),
                    child: listOfDetails(
                      context,
                      propertyItem,
                    ),
                  ),
                ),
                Provider.of<PropertyItem>(context, listen: false)
                        .extrafields
                        .isEmpty
                    ? Container()
                    : Card(
                        elevation: 3,
                        child: Container(
                          width: double.infinity,
                          //height: containerHeight * .3,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25.0, vertical: 10.0),
                          child: additionalInfo(context),
                        ),
                      ),
                Card(
                  elevation: 3,
                  child: Container(
                    //height: containerHeight * .35,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25.0, vertical: 20.0),
                    child: contact(context, propertyItem),
                  ),
                ),
                Provider.of<Auth>(context, listen: false).isAuth
                    ? Card(
                        elevation: 3,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: report(context, propertyItem.propertyId.toString()??""),
                        ),
                      )
                    : Container(),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  height: ((containerHeight) * .94) * .4,
                  //padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
                  child: Consumer<Property>(
                    builder: (ctx, allProperty, child) => moreProperty(
                      context,
                      allProperty.getPropertySameCity(propertyItem.cityName!),
                    ),
                  ),
                ),
              ],
            )));
  }
}
