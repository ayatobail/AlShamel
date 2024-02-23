import 'package:flutter/material.dart';

class LocationPermissionScreen extends StatelessWidget {
  Widget _givePermissionButton(context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: TextButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            Theme.of(context).accentColor,
          ),
        ),
        child: Text(
          'إعطاء صلاحيات الموقع',
          style: Theme.of(context)
              .textTheme
              .bodyText2!
              .copyWith(color: Colors.white, fontSize: 20),
        ),
        onPressed: () {},
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final topPadding = MediaQuery.of(context).padding.top;
    final bottomPading = MediaQuery.of(context).padding.bottom;
    final containerHeight = deviceHeight - topPadding - bottomPading;
    return Scaffold(
      body: Container(
        height: containerHeight,
        margin: EdgeInsets.only(top: topPadding, bottom: bottomPading),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.location_history,
              size: 80,
              color: Theme.of(context).primaryColor,
            ),
            Column(
              children: [
                Text(
                  'مرحبا بك ! سعيدون لوجودك معنا',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                Text(
                  'لتحديد العقارات القريبة منك يرجى الموافقة ',
                  style: Theme.of(context).textTheme.bodyText2!.copyWith(
                        color: Theme.of(context).primaryColorLight,
                      ),
                ),
                Text(
                  'على إذن الدخول إلى الموقع',
                  style: Theme.of(context).textTheme.bodyText2!.copyWith(
                        color: Theme.of(context).primaryColorLight,
                      ),
                ),
              ],
            ),
            _givePermissionButton(context),
          ],
        ),
      ),
    );
  }
}
