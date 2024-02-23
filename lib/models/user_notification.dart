class UserNotification {
  final int? notificationsid;
  final String? title;
  final String? body;
  final String? senddate;
  final String? isread;

  UserNotification({
    required this.notificationsid,
    required this.body,
    required this.title,
    required this.senddate,
    required this.isread,
  });

  @override
  bool operator ==(other) {
    return (other is UserNotification) &&
        other.notificationsid == notificationsid;
  }

  @override
  int get hashCode => notificationsid.hashCode;

  UserNotification.fromjson(Map<String, dynamic> json)
      : notificationsid = json['id'],
        title = json['title'],
        body = json['text'],
        senddate = json['created_at'],
        isread = json['is_read'];

  Map<String, dynamic> toJson() {
    return {
      "id": this.notificationsid,
      "title": this.title,
      "body": this.body,
      "senddate": this.senddate,
      "isread": this.isread
    };
  }

  UserNotification.fromjsonforowner(Map<String, dynamic> json)
      : notificationsid = json['id'],
        title = json['title'],
        body = json['text'],
        senddate = json['created_at'],
        isread = json['is_read'];
}
