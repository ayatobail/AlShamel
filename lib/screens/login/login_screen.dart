import 'package:alshamel_new/home_page.dart';
import 'package:alshamel_new/screens/login/forget_password_screen.dart';
import 'package:alshamel_new/screens/profile/main_profile.dart';
import 'package:flutter/material.dart';
import 'signup_screen.dart';
import 'package:provider/provider.dart';
import 'package:alshamel_new/providers/auth.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic> _authdata = {};
  void _showErrorDialog(String message) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text('فشل عملية تسجيل الدخول'),
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

  void _showSuccessDialog(String message) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.SUCCES,
      animType: AnimType.LEFTSLIDE,
      desc: message,
      btnOkIcon: Icons.check_circle,
      btnOkOnPress: () {
        Navigator.of(context).pushReplacementNamed(HomePage.routName);
      },
      btnOkColor: Theme.of(context).primaryColor,
      onDissmissCallback: (_) {
        Navigator.of(context).pushReplacementNamed(HomePage.routName);
      },
    ).show();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });

    try {
      await Provider.of<Auth>(context, listen: false).login(
        _authdata['phone'],
        _authdata['password'],
      );
      _showSuccessDialog('تم تسجيل الدخول');
    } catch (error) {
      var errorMessage = error.toString();
      _showErrorDialog(errorMessage);
    }

    setState(() {
      _isLoading = false;
    });
  }

  Widget _passwordTextField() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: TextFormField(
          textDirection: TextDirection.ltr,
          keyboardType: TextInputType.text,
          obscureText: true,
          decoration: InputDecoration(
            icon: Icon(Icons.lock_outline),
            labelText: 'كلمة السر',
          ),
          // ignore: missing_return
          validator: (String? value) {
            if (value!.isEmpty || value.length < 5) {
              return 'كلمة السر قصيرة جدا';
            }
          },
          onSaved: (value) {
            _authdata['password'] = value;
          },
        ),
      ),
    );
  }

  Widget _phoneNumberTextField() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: TextFormField(
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            icon: Icon(Icons.phone_android),
            labelText: 'رقم الهاتف',
          ),
          // ignore: missing_return
          validator: (String? value) {
            if (value!.isEmpty) {
              return 'هذا الحقل فارغ';
            }
          },
          onSaved: (value) {
            _authdata['phone'] = value;
          },
        ),
      ),
    );
  }

  Widget _forgetPassword() {
    return Container(
      alignment: Alignment.centerLeft,
      child: TextButton(
        onPressed: () => {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ForgetPasswordScreen()))
        },
        child: Text('نسيت كلمة السر؟',
            style: Theme.of(context).textTheme.bodyText2!.copyWith(
                color: Theme.of(context).accentColor,
                fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _submitButton() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: _isLoading == false
          ? TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  Theme.of(context).accentColor,
                ),
              ),
              child: Text(
                'تسجيل دخول',
                style: Theme.of(context)
                    .textTheme
                    .bodyText2!
                    .copyWith(color: Colors.white, fontSize: 20),
              ),
              onPressed: _submit,
            )
          : Center(child: CircularProgressIndicator()),
    );
  }

  Widget _createAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignUpPage()));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('إنشاء حساب',
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    color: Theme.of(context).accentColor,
                    fontWeight: FontWeight.bold)),
            SizedBox(
              width: 10,
            ),
            Text('ليس لديك حساب؟',
                style: Theme.of(context).textTheme.bodyText1),
          ],
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
    final auth = Provider.of<Auth>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: auth.isAuth
          ? MainProfileScreen()
          : Container(
              height: containerHeight,
              margin: EdgeInsets.only(top: topPadding, bottom: bottomPading),
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _phoneNumberTextField(),
                    _passwordTextField(),
                    _forgetPassword(),
                    _submitButton(),
                    _createAccountLabel(),
                  ],
                ),
              ),
            ),
    );
  }
}
