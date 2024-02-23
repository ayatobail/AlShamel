import 'package:alshamel_new/providers/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:alshamel_new/providers/notifications.dart';

class NotificationScreen extends StatelessWidget {
  Future<void> getNotifications(BuildContext context) async {
    bool isAuth = Provider.of<Auth>(context, listen: false).isAuth;
    if (isAuth) {
      await Provider.of<Notifications>(context, listen: false)
          .getAllNotificationsByUsedID(
              Provider.of<Auth>(context, listen: false).ownerId!);
    } else {
      await Provider.of<Notifications>(context, listen: false)
          .getAllNotifications();
    }
  }

  void _readNotification(int id, context) async {
    await Provider.of<Notifications>(context, listen: false)
        .readNotification(notid: id);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getNotifications(context),
        builder: (BuildContext ctx, AsyncSnapshot snapshotData) {
          if (snapshotData.hasError) {
            return Center(
              child: Text('حدث خطأ الرجاء المحاولة مرة أخرى'),
            );
          } else if (snapshotData.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Consumer<Notifications>(
              child: CircleAvatar(
                radius: 40,
                backgroundColor: Colors.transparent,
                child: Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.contain,
                ),
              ),
              builder: (ctx, messageData, child) {
                if (messageData.notifications.length <= 0) {
                  return Center(child: Text('لا توجد اشعارات'));
                } else
                  return AnimationLimiter(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: messageData.notifications.length,
                      itemBuilder: (ctx, index) {
                        return AnimationConfiguration.staggeredList(
                          position: index,
                          duration: const Duration(milliseconds: 1000),
                          child: SlideAnimation(
                            verticalOffset: 50.0,
                            child: FadeInAnimation(
                              child: Card(
                                elevation: 4,
                                child: Provider.of<Auth>(context, listen: false)
                                        .isAuth
                                    ? ListTile(
                                        onTap: () async {
                                          _readNotification(
                                              messageData.notifications[index]
                                                  .notificationsid!,
                                              context);
                                          AwesomeDialog(
                                            context: context,
                                            dialogType: DialogType.INFO,
                                            animType: AnimType.RIGHSLIDE,
                                            customHeader: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Icon(
                                                Icons.notifications_active,
                                                color: Theme.of(context)
                                                    .accentColor,
                                              ),
                                            ),
                                            headerAnimationLoop: false,
                                            title: messageData
                                                .notifications[index].title,
                                            desc: messageData
                                                .notifications[index].body,
                                            btnOkOnPress: () {},
                                            btnOkColor: Theme.of(context)
                                                .primaryColorLight,
                                          )..show();
                                        },
                                        leading: child,
                                        title: Text(messageData
                                            .notifications[index].title!),
                                        subtitle: Text(
                                          messageData
                                              .notifications[index].senddate!,
                                        ),
                                        trailing: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons
                                                  .notifications_active_outlined,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                            messageData.notifications[index]
                                                        .isread ==
                                                    '0'
                                                ? Text('غير مقروء')
                                                : Text('مقروء',
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .accentColor)),
                                          ],
                                        ),
                                      )
                                    : ListTile(
                                        onTap: () async {
                                          AwesomeDialog(
                                            context: context,
                                            dialogType: DialogType.INFO,
                                            animType: AnimType.RIGHSLIDE,
                                            customHeader: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Icon(
                                                Icons.notifications_active,
                                                color: Theme.of(context)
                                                    .accentColor,
                                              ),
                                            ),
                                            headerAnimationLoop: false,
                                            title: messageData
                                                .notifications[index].title,
                                            desc: messageData
                                                .notifications[index].body,
                                            btnOkOnPress: () {},
                                            btnOkColor: Theme.of(context)
                                                .primaryColorLight,
                                          )..show();
                                        },
                                        leading: child,
                                        title: Text(messageData
                                            .notifications[index].title!),
                                        subtitle: Text(
                                          messageData
                                              .notifications[index].senddate!,
                                        ),
                                        trailing: Icon(
                                          Icons.notifications_active_outlined,
                                          color: Theme.of(context).primaryColor,
                                        ),
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
        });
  }
}
