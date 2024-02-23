import 'package:alshamel_new/providers/auth.dart';
import 'package:alshamel_new/providers/messages.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:auto_size_text/auto_size_text.dart';

class MessagingScreen extends StatelessWidget {
  Future<void> getMessages(BuildContext context) async {
    await Provider.of<Messages>(context, listen: false).getAllMessagesByUsedID(
        Provider.of<Auth>(context, listen: false).ownerId!);
  }

  void _goBack(context) => Navigator.pop(context);

  @override
  Widget build(BuildContext context) {
    final ownerid = Provider.of<Auth>(context, listen: false).ownerId;
    var appBar2 = AppBar(
      leading: Container(),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: IconButton(
            onPressed: () => _goBack(context),
            icon: Icon(
              Icons.arrow_forward,
              color: Theme.of(context).accentColor,
            ),
          ),
        ),
      ],
      title: Text(
        'المحادثات',
        style: Theme.of(context)
            .textTheme
            .bodyText1!
            .copyWith(fontWeight: FontWeight.bold),
        textAlign: TextAlign.right,
      ),
    );

    return Scaffold(
      appBar: appBar2,
      body: Container(
          child: !Provider.of<Auth>(context, listen: false).isAuth
              ? Container(
                  child: Center(
                    child: Text('ميزة الرسائل تظهر عند تسجيل الدخول'),
                  ),
                )
              : FutureBuilder(
                  future: getMessages(context),
                  builder: (BuildContext ctx, AsyncSnapshot snapshotData) {
                    if (snapshotData.hasError) {
                      print(snapshotData.error.toString());
                      return Center(
                        child: Text('حدث خطأ الرجاء المحاولة مرة أخرى'),
                      );
                    } else if (snapshotData.connectionState ==
                        ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return Consumer<Messages>(
                        builder: (ctx, messageData, child) {
                          if (messageData.messages.length <= 0) {
                            return Center(child: Text('لا توجد محادثات'));
                          } else
                            return AnimationLimiter(
                              child: ListView.builder(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 25.0, vertical: 10.0),
                                itemCount: messageData.messages.length,
                                itemBuilder: (ctx, index) {
                                  return AnimationConfiguration.staggeredList(
                                    position: index,
                                    duration: const Duration(milliseconds: 800),
                                    child: SlideAnimation(
                                      verticalOffset: 50.0,
                                      child: FadeInAnimation(
                                        child: Card(
                                          shape: messageData.messages[index]
                                                      .senderid !=
                                                  ownerid
                                              ? RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  20),
                                                          topRight:
                                                              Radius.circular(
                                                                  20),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  20)),
                                                )
                                              : RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  20),
                                                          topRight:
                                                              Radius.circular(
                                                                  20),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  20))),
                                          color: messageData.messages[index]
                                                      .senderid !=
                                                  ownerid
                                              ? Theme.of(context)
                                                  .accentColor
                                                  .withOpacity(0.7)
                                              : Theme.of(context)
                                                  .backgroundColor
                                                  .withOpacity(0.7),
                                          elevation: 6.0,
                                          child: ListTile(
                                            onTap: () async {
                                              AwesomeDialog(
                                                context: context,
                                                dialogType: DialogType.INFO,
                                                animType: AnimType.RIGHSLIDE,
                                                customHeader: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Icon(
                                                    Icons.message_sharp,
                                                    color: Theme.of(context)
                                                        .accentColor,
                                                  ),
                                                ),
                                                headerAnimationLoop: false,
                                                title: messageData
                                                    .messages[index].title,
                                                desc: messageData
                                                    .messages[index].body,
                                                btnOkOnPress: () {},
                                                btnOkColor: Theme.of(context)
                                                    .primaryColorLight,
                                              )..show();
                                            },
                                            leading: child,
                                            title: AutoSizeText(
                                                messageData
                                                    .messages[index].title??"",
                                                textDirection: messageData
                                                            .messages[index]
                                                            .senderid ==
                                                        ownerid
                                                    ? TextDirection.rtl
                                                    : TextDirection.ltr,
                                                overflow: TextOverflow.ellipsis,
                                                textScaleFactor:
                                                    MediaQuery.of(context)
                                                        .textScaleFactor,
                                                minFontSize: 9,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1),
                                            subtitle: AutoSizeText(
                                                messageData
                                                    .messages[index].body??"",
                                                textDirection: messageData
                                                            .messages[index]
                                                            .senderid ==
                                                        ownerid
                                                    ? TextDirection.rtl
                                                    : TextDirection.ltr,
                                                overflow: TextOverflow.ellipsis,
                                                textScaleFactor:
                                                    MediaQuery.of(context)
                                                        .textScaleFactor,
                                                minFontSize: 9,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText2),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                        },
                      );
                    }
                  })),
    );
  }
}
