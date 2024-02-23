import 'package:alshamel_new/screens/login/location_permission_screen.dart';
import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';

class CodeConfirmationScreen extends StatefulWidget {
  @override
  _CodeConfirmationScreenState createState() => _CodeConfirmationScreenState();
}

class _CodeConfirmationScreenState extends State<CodeConfirmationScreen> {
  Widget _confirmButton(context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(
        horizontal: 30,
      ),
      child: TextButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            Theme.of(context).primaryColor,
          ),
        ),
        child: Text(
          'تأكيد',
          style: Theme.of(context)
              .textTheme
              .bodyText2!
              .copyWith(color: Colors.white, fontSize: 20),
        ),
        onPressed: () => {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => LocationPermissionScreen()))
        },
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
      resizeToAvoidBottomInset: false,
      body: Container(
        color: Theme.of(context).accentColor,
        alignment: Alignment.center,
        height: containerHeight,
        margin: EdgeInsets.only(top: topPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.message_outlined,
              size: 75,
              color: Theme.of(context).primaryColor,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'تأكيد رقم الهاتف',
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  'ستصلك رسالة التأكيد في أقل من دقيقة',
                  style: Theme.of(context).textTheme.bodyText2!.copyWith(
                        color: Colors.white,
                      ),
                ),
              ],
            ),
            Container(
              height: containerHeight * .3,
              margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 30),
                        child: const Text('ُEnter Your OTP Code Here:'),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 30,
                        ),
                        alignment: Alignment.centerLeft,
                        child: OTPTextField(
                          length: 4,
                          width: MediaQuery.of(context).size.width,
                          fieldWidth: 35,
                          style: const TextStyle(fontSize: 17),
                          textFieldAlignment: MainAxisAlignment.spaceAround,
                          fieldStyle: FieldStyle.underline,
                          onCompleted: (pin) {
                            print("Completed: " + pin);
                          },
                        ),
                      ),
                    ],
                  ),
                  _confirmButton(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
