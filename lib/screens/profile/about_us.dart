import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsScreen extends StatelessWidget {
  static String routName = '/about-us';

  Widget _contactMember({BuildContext? ctx, String? name, String? phone}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextButton.icon(
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all(Theme.of(ctx!).primaryColorLight),
          ),
          icon: Icon(Icons.phone_android_outlined,
              color: Theme.of(ctx).accentColor),
          label: Text(phone!, style: TextStyle(color: Colors.white)),
          onPressed: () => launch('tel:$phone'),
        ),
        AutoSizeText(
          name??"",
          overflow: TextOverflow.ellipsis,
          textScaleFactor: MediaQuery.of(ctx).textScaleFactor,
          textAlign: TextAlign.center,
          style: Theme.of(ctx).textTheme.bodyText1!.copyWith(
              color: Theme.of(ctx).primaryColor, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final topPadding = MediaQuery.of(context).padding.top;
    final bottomPading = MediaQuery.of(context).padding.bottom;
    final availableSpace = deviceHeight - topPadding - bottomPading;
    final deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: topPadding, bottom: bottomPading),
        height: availableSpace,
        width: deviceWidth,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                child: Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.cover,
                ),
                alignment: Alignment.center,
                width: (deviceWidth * .6),
                height: (availableSpace * .15),
              ),
              SizedBox(
                height: availableSpace * .05,
              ),
              Container(
                child: Column(children: [
                  _contactMember(
                    ctx: context,
                    name: 'أمجد',
                    phone: '0988859414',
                  ),
                  _contactMember(
                    ctx: context,
                    name: 'أحمد',
                    phone: '0998444958',
                  ),
                  _contactMember(
                    ctx: context,
                    name: 'عامر',
                    phone: '0991478922',
                  ),
                  SizedBox(
                    height: availableSpace * .1,
                  ),
                  AutoSizeText(
                    'عنوان المكتب : حمص - مقابل حديقة الدبلان',
                    overflow: TextOverflow.ellipsis,
                    textScaleFactor: MediaQuery.of(context).textScaleFactor,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold),
                  ),
                ]),
              )
            ]),
      ),
    );
  }
}
