import 'package:alshamel_new/home_page.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoardingScreen extends StatelessWidget {
  void _setonBoardViewed(context) async {
    int isViewed = 1;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('onBoard', isViewed);
    Navigator.of(context).pushNamed(HomePage.routName);
  }

  static String routeName = '/on-boarding';
  final List<PageViewModel> introPages = [
    PageViewModel(
      title: "زائرنا الغالي",
      body: "نرحب بكم في تطبيق الشامل الخاص بمكتب الشامل العقاري " +
          "نود إعلامكم أن حقوق النشر متاحة للجميع لكن لن ينشر أي إعلان إلا بعد أخذ الموافقة على النشر لضرورة جودة الخدمة علماً بأن جميع عمليات النشر والبحث مجانية ولا تتطلب أي رسوم",
      image: Center(
        child: Image.asset("assets/images/home.png", height: 175.0),
      ),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IntroductionScreen(
        pages: introPages,
        onDone: () => _setonBoardViewed(context),
        next: const Icon(Icons.navigate_next),
        done: const Text("تم", style: TextStyle(fontWeight: FontWeight.w600)),
        dotsDecorator: DotsDecorator(
            size: const Size.square(10.0),
            activeSize: const Size(10.0, 10.0),
            activeColor: Theme.of(context).accentColor,
            color: Colors.black26,
            spacing: const EdgeInsets.symmetric(horizontal: 3.0),
            activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0))),
      ),
    );
  }
}
