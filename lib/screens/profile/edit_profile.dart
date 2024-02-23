import 'package:alshamel_new/providers/auth.dart';
import 'package:alshamel_new/providers/owner.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController displayFirstNameController = TextEditingController();
  TextEditingController displayLastNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  bool isLoading = false;

  Column buildDisplayNameField(Owner ownerdata) {
    return Column(
      textDirection: TextDirection.rtl,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(top: 12.0),
            child: Text(
              "الاسم الأول",
              style: TextStyle(color: Colors.grey),
            )),
        Directionality(
          textDirection: TextDirection.rtl,
          child: TextField(
            controller: displayFirstNameController,
            decoration: InputDecoration(
              hintText: ownerdata.currentUser!.firstname,
              //errorText: _displayFirstNameValid ? null : "الحقل فارغ",
            ),
          ),
        ),
        Padding(
            padding: EdgeInsets.only(top: 12.0),
            child: Text(
              "الاسم الأخير",
              style: TextStyle(color: Colors.grey),
            )),
        Directionality(
          textDirection: TextDirection.rtl,
          child: TextField(
            controller: displayLastNameController,
            decoration: InputDecoration(
              hintText: ownerdata.currentUser!.lastname,
              //errorText: _displayLastNameValid ? null : "الحقل فارغ",
            ),
          ),
        )
      ],
    );
  }

  Column buildPhoneField(Owner ownerdata) {
    return Column(
      textDirection: TextDirection.rtl,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 12.0),
          child: Text(
            "رقم الهاتف",
            style: TextStyle(color: Colors.grey),
          ),
        ),
        Directionality(
          textDirection: TextDirection.rtl,
          child: TextField(
            keyboardType: TextInputType.number,
            controller: phoneController,
            decoration: InputDecoration(
              hintText: ownerdata.currentUser!.phone,
              //errorText: _phoneValid ? null : "الحقل فارغ",
            ),
          ),
        )
      ],
    );
  }

  Column buildEmailField(Owner ownerdata) {
    return Column(
      textDirection: TextDirection.rtl,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 12.0),
          child: Text(
            "البريد الالكتروني",
            style: TextStyle(color: Colors.grey),
          ),
        ),
        Directionality(
          textDirection: TextDirection.rtl,
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            controller: emailController,
            decoration: InputDecoration(
              hintText: ownerdata.currentUser!.email,
              //errorText: _emailValid ? null : "البريد الالكتروني غير صالح",
            ),
          ),
        )
      ],
    );
  }

  updateProfileData(Owner ownerData) async {
    SnackBar snackbar = SnackBar(content: Text("تم تعديل المعلومات الشخصية"));
    try {
      await Provider.of<Owner>(context, listen: false)
          .updateOwnerInfo(
              ownerid: Provider.of<Auth>(context, listen: false).ownerId!,
              firstname: displayFirstNameController.text.isEmpty
                  ? ownerData.currentUser!.firstname!
                  : displayFirstNameController.text,
              lastname: displayLastNameController.text.isEmpty
                  ? ownerData.currentUser!.lastname!
                  : displayLastNameController.text,
              phone: phoneController.text.isEmpty
                  ? ownerData.currentUser!.phone!
                  : phoneController.text,
              email: emailController.text.isEmpty
                  ? ownerData.currentUser!.email!
                  : emailController.text)
          .then(
            (_) => ScaffoldMessenger.of(context).showSnackBar(snackbar),
          );
    } catch (error) {
      SnackBar snackbar = SnackBar(content: Text(error.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ownerData = Provider.of<Owner>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "تعديل المعلومات الشخصية",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.done,
              //size: 30.0,
              color: Colors.green,
            ),
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                    top: 16.0,
                    bottom: 8.0,
                  ),
                  child: CircleAvatar(
                    backgroundColor:
                        Theme.of(context).accentColor.withOpacity(0.7),
                    radius: 30.0,
                    child: Icon(
                      Icons.edit,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: <Widget>[
                      buildDisplayNameField(ownerData),
                      buildPhoneField(ownerData),
                      buildEmailField(ownerData),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton.icon(
                    onPressed: () => updateProfileData(ownerData),
                    icon: Icon(
                      Icons.check,
                      color: Theme.of(context).accentColor,
                    ),
                    label: Text(
                      "حفظ",
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.cancel, color: Colors.red),
                    label: Text(
                      "إلغاء",
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
