import 'package:alshamel_new/providers/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class ChangePasswordScreen extends StatefulWidget {
  static const routeName = '/change-password';
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  TextEditingController oldPasswordController = new TextEditingController();
  TextEditingController newPasswordController = new TextEditingController();
  TextEditingController confirmPasswordController = new TextEditingController();

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
      ),
    );
  }

  void _showSuccessDialog(String message) {
    AwesomeDialog(
        context: context,
        dialogType: DialogType.SUCCES,
        animType: AnimType.LEFTSLIDE,
        desc: message,
        btnOkIcon: Icons.check_circle,
        btnOkOnPress: () {
          Navigator.of(context).pop();
        },
        btnOkColor: Theme.of(context).primaryColor,
        onDissmissCallback: (_) => Navigator.of(context).pop()).show();
  }

  void _confirm() async {
    if (oldPasswordController.text.isEmpty) {
      _showErrorDialog('أدخل كلمة المرور القديمة');
    } else if (newPasswordController.text.isEmpty) {
      _showErrorDialog('أدخل كلمة المرور الجديدة');
    } else if (confirmPasswordController.text.isEmpty) {
      _showErrorDialog('أدخل تأكيد كلمة المرورالجديدة');
    } else if (newPasswordController.text.length < 5) {
      _showErrorDialog('اختر كلمة مرور بعدد أحرف أكثر');
    } else if (confirmPasswordController.text != newPasswordController.text) {
      _showErrorDialog('تأكيد كلمة المرور خاطئ');
    } else {
      try {
        await Provider.of<Auth>(context, listen: false).changePassword(
            oldPasswordController.text, newPasswordController.text);
        _showSuccessDialog('تم تغيير كلمة المرور');
      } catch (error) {
        var errorMessage = error.toString();
        _showErrorDialog(errorMessage);
      }
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

  Widget _maketextField(TextEditingController controller, String label) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: TextField(
          controller: controller,
          keyboardType: TextInputType.text,
          decoration:
              InputDecoration(icon: Icon(Icons.lock_outline), labelText: label),
        ),
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
        height: containerHeight,
        margin: EdgeInsets.only(top: topPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AutoSizeText(
              'تغيير كلمة المرور؟',
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            _maketextField(oldPasswordController, 'كلمة المرور القديمة'),
            _maketextField(newPasswordController, 'كلمة المرور الجديدة'),
            _maketextField(
                confirmPasswordController, 'تأكيد كلمة المرور الجديدة'),
            _confirmButton(context),
          ],
        ),
      ),
    );
  }
}
