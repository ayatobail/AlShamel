import 'package:alshamel_new/helper/http_exception.dart';
import 'package:alshamel_new/home_page.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'package:provider/provider.dart';
import 'package:alshamel_new/providers/auth.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic> _authdata = {};
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('فشل عملية إنشاء الحساب '),
        content: Text(message),
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
      btnOkOnPress: () =>
          Navigator.of(context).pushReplacementNamed(HomePage.routName),
      btnOkColor: Theme.of(context).primaryColor,
      onDissmissCallback: (_) =>
          Navigator.of(context).pushReplacementNamed(HomePage.routName),
    ).show();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    if (_formKey.currentState!.validate()) {
      try {
        await Provider.of<Auth>(context, listen: false).signup(
          _authdata['firstname'],
          _authdata['lastname'],
          _authdata['phone'],
          _authdata['email'],
          _authdata['password'],
        );
        _showSuccessDialog('تم إنشاء الحساب');
      } on HttpException catch (error) {
        var errorMessage = error.toString();

        _showErrorDialog(errorMessage);
      } catch (error) {
        var errorMessage = error.toString();
        _showErrorDialog(errorMessage);
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  Widget _buildTextFields() {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: TextFormField(
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                icon: Icon(Icons.person_outlined),
                labelText: 'الاسم الأول',
              ),
              // ignore: missing_return
              validator: (String? value) {
                if (value!.isEmpty) {
                  return 'هذا الحقل فارغ';
                }
              },
              onSaved: (value) {
                _authdata['firstname'] = value;
              },
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: TextFormField(
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                icon: Icon(Icons.person_outlined),
                labelText: 'الاسم الأخير',
              ),
              // ignore: missing_return
              validator: (value) {
                if (value!.isEmpty) {
                  return 'هذا الحقل فارغ';
                }
              },
              onSaved: (value) {
                _authdata['lastname'] = value;
              },
            ),
          ),
        ),
        Container(
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
              validator: ( value) {
                if (value!.isEmpty) {
                  return 'هذا الحقل فارغ';
                }
              },
              onSaved: (value) {
                _authdata['phone'] = value;
              },
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: TextFormField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                icon: Icon(Icons.email_outlined),
                labelText: 'البريد االكتروني',
              ),
              // ignore: missing_return
              validator: ( value) {
                if (value!.isEmpty || !value.contains('@')) {
                  return 'الايميل غير صالح';
                }
              },
              onSaved: (value) {
                _authdata['email'] = value;
              },
            ),
          ),
        ),
        Container(
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
              validator: (value) {
                if (value!.isEmpty || value.length < 5) {
                  return 'كلمة السر قصيرة جدا';
                }
              },
              onSaved: (value) {
                _authdata['password'] = value;
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _submitButton() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: _isLoading == true
          ? Center(child: CircularProgressIndicator())
          : TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  Theme.of(context).accentColor,
                ),
              ),
              child: Text(
                'إنشاء حساب',
                style: Theme.of(context)
                    .textTheme
                    .bodyText2!
                    .copyWith(color: Colors.white, fontSize: 20),
              ),
              onPressed: _submit,
            ),
    );
  }

  Widget _loginAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 20),
        padding: const EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'تسجيل دخول',
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  color: Theme.of(context).accentColor,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'لديك حساب ؟',
              style: Theme.of(context).textTheme.bodyText1,
            ),
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: containerHeight,
        margin: EdgeInsets.only(top: topPadding, bottom: bottomPading),
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(child: _buildTextFields()),
              _submitButton(),
              _loginAccountLabel(),
            ],
          ),
        ),
      ),
    );
  }
}
