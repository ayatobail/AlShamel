import 'package:alshamel_new/providers/auth.dart';
import 'package:alshamel_new/providers/car_providers/car_item.dart';
import 'package:alshamel_new/providers/car_providers/cars.dart';
import 'package:alshamel_new/providers/owner.dart';
import 'package:alshamel_new/providers/property_providers/favorites.dart';
import 'package:alshamel_new/screens/cars/cars_homepage_screen.dart';
import 'package:alshamel_new/widgets/cars_widgets/car_item_widget.dart';
import 'package:alshamel_new/widgets/property_widgets/carousel_slider_images.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart' as intl1;
import 'package:awesome_dialog/awesome_dialog.dart';

class CarReviewScreen extends StatelessWidget {
  static const routeName = '/car-details';

  void _goBack(context) {
    Navigator.pop(context);
  }

  void _showDialog({required String alertType, required BuildContext context, required String message}) {
    alertType == 'success'
        ? AwesomeDialog(
            context: context,
            dialogType: DialogType.SUCCES,
            animType: AnimType.LEFTSLIDE,
            desc: message,
            btnOkIcon: Icons.check_circle,
            btnOkOnPress: () {},
            btnOkColor: Theme.of(context).primaryColor,
            onDissmissCallback: (_) => {},
          ).show().then((_) => Navigator.pop(context))
        : showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text(message),
              content: Text('يرجى إعادة المحاولة'),
              actions: <Widget>[
                TextButton(onPressed: () {}, child: Text('OK'))
              ],
            ),
          );
  }

  void _sendReport(BuildContext context, String repoMsg, String carid) async {
    try {
      await Provider.of<Auth>(context, listen: false)
          .sendMsgToAdmin(title: 'إبلاغ عن مركبة رقم $carid ', text: repoMsg,isreport: '1')
          .then((_) => _showDialog(
                alertType: 'success',
                context: context,
                message: 'تم إرسال إبلاغك إلى الإدارة ',
              ));
    } catch (error) {
      var errorMessage = error.toString();
      _showDialog(
        alertType: 'error',
        context: context,
        message: errorMessage,
      );
    }
  }

  void _displayTextInputDialog(BuildContext context, String carid) {
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
                onPressed: () => _sendReport(context, valueText!, carid),
              ),
            ],
          );
        });
  }

  Widget report(context, String carid) {
    return TextButton.icon(
      onPressed: () => _displayTextInputDialog(context, carid),
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

  Widget carmodel(context, CarItem caritem) {
    return Card(
      elevation: 3,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  gradient: new LinearGradient(
                    colors: [
                      Theme.of(context).accentColor,
                      Theme.of(context).primaryColor,
                    ],
                  )
                  //color: Theme.of(context).primaryColorLight,
                  ),
              padding: const EdgeInsets.all(8),
              child: AutoSizeText(
                '${caritem.modelname}',
                overflow: TextOverflow.ellipsis,
                textScaleFactor: MediaQuery.of(context).textScaleFactor,
                textDirection: TextDirection.rtl,
                minFontSize: 3,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyText2!
                    .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  gradient: new LinearGradient(
                    colors: [
                      Theme.of(context).primaryColor,
                      Theme.of(context).accentColor,
                    ],
                  )
                  //color: Theme.of(context).primaryColorLight,
                  ),
              padding: const EdgeInsets.all(8),
              child: AutoSizeText(
                '${caritem.companyname}',
                overflow: TextOverflow.ellipsis,
                minFontSize: 3,
                textScaleFactor: MediaQuery.of(context).textScaleFactor,
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyText2!
                    .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget description(context, String desc) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        AutoSizeText(
          'وصف للمركبة',
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

  Widget address(context, String address) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        AutoSizeText(
          'موقع المركبة بالتفصيل',
          overflow: TextOverflow.ellipsis,
          textScaleFactor: MediaQuery.of(context).textScaleFactor,
          textDirection: TextDirection.rtl,
          style: Theme.of(context).textTheme.bodyText1!.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).accentColor),
        ),
        AutoSizeText(
          address,
          overflow: TextOverflow.ellipsis,
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

  Widget simpleDetailsContainer(context, CarItem car) {
    return ListTile(
      leading: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).primaryColor,
        ),
        padding: const EdgeInsets.all(10),
        child: AutoSizeText(
          'رقم الإعلان : ${car.id}',
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
            '${car.title} (${car.typename})',
            //overflow: TextOverflow.ellipsis,
            textScaleFactor: MediaQuery.of(context).textScaleFactor,
            textDirection: TextDirection.rtl,
            style: Theme.of(context).textTheme.bodyText1!.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor),
          ),
      subtitle: AutoSizeText(
        car.operationtypename??"",
        //overflow: TextOverflow.ellipsis,
        textScaleFactor: MediaQuery.of(context).textScaleFactor,
        textDirection: TextDirection.rtl,
        style: Theme.of(context).textTheme.bodyText1!.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColorLight),
      ),
    );
  }

  Widget makeItem(context, String name, String value, String icon) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          child: SvgPicture.network(
            icon,
            fit: BoxFit.cover,
          ),
        ),
        FittedBox(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AutoSizeText(
                name,
                overflow: TextOverflow.ellipsis,
                minFontSize: 9,
                textScaleFactor: MediaQuery.of(context).textScaleFactor,
                textDirection: TextDirection.rtl,
                style: Theme.of(context)
                    .textTheme
                    .bodyText2!
                    .copyWith(fontWeight: FontWeight.bold, fontSize: 12),
              ),
              AutoSizeText(
                value,
                overflow: TextOverflow.ellipsis,
                textScaleFactor: MediaQuery.of(context).textScaleFactor,
                textDirection: TextDirection.rtl,
                style:
                    Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 9),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget makeItem2(context, String name, String value, String icon) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          child: Image.asset(
            icon,
            fit: BoxFit.cover,
          ),
        ),
        FittedBox(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AutoSizeText(
                name,
                overflow: TextOverflow.ellipsis,
                textScaleFactor: MediaQuery.of(context).textScaleFactor,
                textDirection: TextDirection.rtl,
                minFontSize: 9,
                style: Theme.of(context)
                    .textTheme
                    .bodyText2!
                    .copyWith(fontWeight: FontWeight.bold, fontSize: 12),
              ),
              AutoSizeText(
                value,
                overflow: TextOverflow.ellipsis,
                textScaleFactor: MediaQuery.of(context).textScaleFactor,
                textDirection: TextDirection.rtl,
                style:
                    Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 9),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget gridOfDetails(context, CarItem carItem) {
    return GridView(
        padding: EdgeInsets.all(8.0),
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 5.0,
          childAspectRatio: MediaQuery.of(context).size.width /
              (MediaQuery.of(context).size.height / 4),
        ),
        children: [
          makeItem2(
              context, 'الموقع', carItem.cityname??"", 'assets/images/pin-3.png'),
          makeItem2(context, 'موديل سنة', carItem.manufactureyear.toString()??"",
              'assets/images/modelyear.png'),
          makeItem2(context, 'المسافة المقطوعة', carItem.km.toString()??"",
              'assets/images/test.png'),
          ...Provider.of<CarItem>(context, listen: false).detailsvalues.map(
              (e) => makeItem(context, e.detailsname, e.value, e.cartypeicon))
        ]);
  }

  Widget contact(context, CarItem car) {
    String ?whatsupNum;
    // if (car.phone3 != '0' && car.phone3.startsWith('09')) {
    //   whatsupNum = car.phone3;
    // }
    // if (car.phone2 != '0' && car.phone2.startsWith('09')) {
    //   whatsupNum = car.phone2;
    // }
    // if (car.phone1 != '0' && car.phone1.startsWith('09')) {
    //   whatsupNum = car.phone1;
    // }
    if (car.phone != '0' && car.phone!.startsWith('09')) {
      whatsupNum = car.phone;
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
                          'whatsapp://send?phone=+963${whatsupNum!.substring(1)}}',
                        ))
                : Container(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                car.phone != '0' && car.phone != null
                    ? TextButton.icon(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Theme.of(context).primaryColorLight),
                        ),
                        icon: Icon(Icons.phone_android_outlined,
                            color: Theme.of(context).accentColor),
                        label: Text(car.phone??"",
                            style: TextStyle(color: Colors.white)),
                        onPressed: () => launch('tel:${car.phone}'))
                    : Container(),
                // car.phone1 != '0' && car.phone1 != null
                //     ? TextButton.icon(
                //         style: ButtonStyle(
                //           backgroundColor: MaterialStateProperty.all(
                //               Theme.of(context).primaryColorLight),
                //         ),
                //         icon: Icon(Icons.phone_android_outlined,
                //             color: Theme.of(context).accentColor),
                //         label: Text(car.phone1,
                //             style: TextStyle(color: Colors.white)),
                //         onPressed: () => launch('tel:${car.phone1}'))
                //     : Container(),
                // car.phone2 != '0'
                //     ? TextButton.icon(
                //         style: ButtonStyle(
                //             backgroundColor: MaterialStateProperty.all(
                //                 Theme.of(context).primaryColorLight)),
                //         icon: Icon(Icons.phone_android_outlined,
                //             color: Theme.of(context).accentColor),
                //         label: Text(car.phone2,
                //             style: TextStyle(color: Colors.white)),
                //         onPressed: () => launch('tel:${car.phone2}'),
                //       )
                //     : Container(),
                // car.phone3 != '0'
                //     ? TextButton.icon(
                //         style: ButtonStyle(
                //             backgroundColor: MaterialStateProperty.all(
                //                 Theme.of(context).primaryColorLight)),
                //         icon: Icon(Icons.phone_android_outlined,
                //             color: Theme.of(context).accentColor),
                //         label: Text(car.phone3,
                //             style: TextStyle(color: Colors.white)),
                //         onPressed: () => launch('tel:${car.phone3}'))
                //     : Container(),
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

  void updateFavoState(int isfav, context, CarItem car) async {
    final owner = Provider.of<Auth>(context, listen: false).ownerId;
    print('Update Fvs');
    if (isfav == -1) {
      await Provider.of<Favorites>(context, listen: false)
          .insertFavoriteCar(car: car, ownerid: owner!);
    } else {
      await Provider.of<Favorites>(context, listen: false)
          .deleteFavoriteCar(carid: car.id!, ownerid: owner!);
    }
  }

  void _shareMessage(CarItem car) async {
    String msg1 = 'مرحبا بكم في تطبيق الشامل يسرّنا مشاركة مركبة معكم.\n';
    String msg2 = ' إعلان : ${car.title}\n';
    String msg3 = 'رقم إعلان المركبة : ${car.id}\n';
    String msg4 = 'المدينة : ${car.cityname}\n';
    String msg5 = 'السعر : ${car.price}\n';
    String msg6 = 'لمشاهدة كامل تفاصيل المركبة.\n';

    String link =
        'https://alshamel-sy.com/mobile_view/car_details/car_details.php?carid=${car.id}';
    String contactUs = '\n\n لأي استفسار تواصل معنا على الرقم: ${car.phone1}';
    String fullMsg = msg1 + msg2 + msg3 + msg4 + msg5 + msg6 + link + contactUs;
    var url = "https://wa.me/?text=$fullMsg";

    var encoded = Uri.encodeFull(url);
    await launch(encoded);
  }

  Widget fourIconsDetails(context, CarItem car) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
          onTap: () => _shareMessage(car),
          child: makeIcons(Icons.share_outlined, 'مشاركة', context),
        ),
        Consumer<Favorites>(
          builder: (ctx, fav, child) => InkWell(
            onTap: Provider.of<Auth>(context, listen: false).isAuth
                ? () => updateFavoState(fav.carIsFavorite(car.id!), ctx, car)
                : () {},
            child: makeIcons(
                fav.carIsFavorite(car.id!) != -1
                    ? Icons.favorite
                    : Icons.favorite_border_outlined,
                'حفظ في المفضلة',
                context),
          ),
        ),
        makeIcons(
            Icons.camera_enhance_outlined,
            '${Provider.of<CarItem>(context, listen: false).images.length}',
            context),
      ],
    );
  }

  void _showAllItems(List<CarItem> it, context) {
    Provider.of<Cars>(context, listen: false).setFilters(filtered: it);
    Navigator.of(context).pushNamed(CarsHomePage.routeName);
  }

  Widget moreCars(context, List<CarItem> allCars) {
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
              onPressed: () => _showAllItems(allCars, context),
            ),
            AutoSizeText(
              'سيارات في ذات المدينة',
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
            itemCount: allCars.length,
            itemBuilder: (BuildContext ctx, int index) {
              return ChangeNotifierProvider.value(
                value: allCars[index],
                child: CarItemWidget(),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget appBar(context)  {
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

    final caritem = ModalRoute.of(context)!.settings.arguments as CarItem;
    var priceFormat = intl1.NumberFormat.currency(symbol: '');
    int num = int.parse(caritem.price.toString()??"");
    String price = priceFormat.format(num);
    //print(caritem.id);
    return Scaffold(
      appBar: PreferredSize(preferredSize: Size.fromHeight(56),
      child: appBar(context)),
      body: FutureBuilder(
        future: Future.wait([
          Provider.of<CarItem>(context, listen: false)
              .getCarDetails(caritem.id!),
          Provider.of<CarItem>(context, listen: false).getImages(
            caritem.id!,
          ),
          Provider.of<Owner>(context, listen: false)
              .getOwnerInfo(caritem.ownerid!)
        ]),
        builder: (BuildContext ctx, AsyncSnapshot snapshotData) {
          if (snapshotData.connectionState == ConnectionState.waiting) {
            return const Center(
              child: const CircularProgressIndicator(),
            );
          } else
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CarouselSliderImages(
                    containerHeight: containerHeight * .3,
                    images: Provider.of<CarItem>(context, listen: false).images,
                  ),
                  Card(
                    elevation: 3,
                    shadowColor: Theme.of(context).accentColor,
                    child: Container(
                      //height: containerHeight * .15,
                      //padding: const EdgeInsets.all(5),
                      child: simpleDetailsContainer(context, caritem),
                    ),
                  ),
                  carmodel(context, caritem),
                  Card(
                    elevation: 3,
                    child: Container(
                      height: containerHeight * .1,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 8.0),
                      child: fourIconsDetails(context, caritem),
                    ),
                  ),
                  Card(
                    elevation: 3.0,
                    shadowColor: Theme.of(context).accentColor,
                    child: Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      height: containerHeight * .35,
                      child: gridOfDetails(
                        context,
                        caritem,
                      ),
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
                  caritem.address == null
                      ? Container()
                      : Card(
                          elevation: 3,
                          child: Container(
                            width: double.infinity,
                            height: containerHeight * .15,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 25.0, vertical: 10.0),
                            child: address(context, caritem.address??""),
                          ),
                        ),
                  caritem.descriptions!.isEmpty
                      ? Container()
                      : Card(
                          elevation: 3,
                          child: Container(
                            width: double.infinity,
                            height: containerHeight * .15,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 25.0, vertical: 10.0),
                            child: description(context, caritem.descriptions??""),
                          ),
                        ),
                  Card(
                    elevation: 3,
                    child: Container(
                      //height: containerHeight * .35,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25.0, vertical: 20.0),
                      child: contact(context, caritem),
                    ),
                  ),
                  Provider.of<Auth>(context, listen: false).isAuth
                      ? Card(
                          elevation: 3,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: report(context, caritem.id.toString()??""),
                          ),
                        )
                      : Container(),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    height: ((containerHeight) * .94) * .4,
                    //padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
                    child: Consumer<Cars>(
                      builder: (ctx, allCars, child) => moreCars(
                        context,
                        allCars.getCarsSameCity(caritem.cityid!),
                      ),
                    ),
                  ),
                ],
              ),
            );
        },
      ),
    );
  }
}
