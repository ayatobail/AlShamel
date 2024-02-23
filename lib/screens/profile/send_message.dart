import 'package:alshamel_new/providers/auth.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class SendMessageScreen extends StatefulWidget {
  static const routeName = '/send-msg';
  @override
  _SendMessageScreenState createState() => _SendMessageScreenState();
}

class _SendMessageScreenState extends State<SendMessageScreen> {
  TextEditingController textController = new TextEditingController();
  void _showSuccessDialog(String message) {
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

  void _confirm() async {
    try {
      await Provider.of<Auth>(context, listen: false).sendMsgToAdmin(
          title: 'رسالة إلى الإدارة', text: textController.text, isreport: '0');
      _showSuccessDialog('تم إرسال رسالتك إلى الإدارة ');
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
          'إرسال',
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
    final deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        alignment: Alignment.center,
        height: containerHeight,
        margin: EdgeInsets.only(top: topPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Image.asset(
                'assets/images/logo.png',
                color: Colors.black54,
                fit: BoxFit.cover,
              ),
              alignment: Alignment.center,
              width: (deviceWidth * .6),
              height: (containerHeight * .15),
            ),
            SizedBox(
              height: containerHeight * .02,
            ),
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
                      keyboardType: TextInputType.multiline,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.message_outlined),
                        labelText: 'نص الرسالة',
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
