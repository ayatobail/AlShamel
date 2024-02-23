import 'package:alshamel_new/providers/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ForgetPasswordScreen extends StatefulWidget {
  @override
  _ForgetPasswordScreenState createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  TextEditingController textController = new TextEditingController();

  void _showErrorDialog(String error) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text(error),
              content: Text('يرجى إعادة المحاولة'),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'))
              ],
            ));
  }

  Widget _header() {
    return Column(
      children: [
        Text(
          'نسيت كلمة المرور؟',
          style: Theme.of(context)
              .textTheme
              .bodyText1!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        Text(
          'أدخل البريد الالكتروني',
          style: Theme.of(context).textTheme.bodyText2!.copyWith(
                color: Theme.of(context).primaryColorLight,
              ),
        ),
      ],
    );
  }

  void _confirm() async {
    try {
      await Provider.of<Auth>(context, listen: false)
          .forgetPassword(textController.text)
          .then((_) {
        SnackBar snackbar = SnackBar(
            content:
                Text("تم إرسال كلمة سر جديدة إلى البريد الالكتروني الخاص بك"));
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
      });
    } catch (error) {
      var errorMessage = error.toString();
      _showErrorDialog(errorMessage);
    }
  }

  Widget _confirmButton(context) {
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
          'تأكيد',
          style: Theme.of(context)
              .textTheme
              .bodyText2!
              .copyWith(color: Colors.white, fontSize: 20),
        ),
        onPressed: _confirm,
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
        alignment: Alignment.center,
        height: containerHeight * .7,
        margin: EdgeInsets.only(top: topPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _header(),
            Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: TextField(
                      controller: textController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.person_outline),
                        labelText: 'البريد الالكتروني / رقم الهاتف',
                      ),
                    ),
                  ),
                ),
                _confirmButton(context),
              ],
            )
          ],
        ),
      ),
    );
  }
}
