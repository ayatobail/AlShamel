class UserMessage {
  final int? msgid;
  final String? title;
  final String? body;
  final String? senddate;
  final int? senderid;
  final int? receiverid;

  UserMessage(
      {required this.msgid,
      required this.body,
      required this.title,
      required this.senddate,
      required this.senderid,
      required this.receiverid});

  @override
  bool operator ==(other) {
    return (other is UserMessage) && other.msgid == msgid;
  }

  @override
  int get hashCode => msgid.hashCode;

  UserMessage.fromjson(Map<String, dynamic> json)
      : msgid = json['id'],
        title = json['title'],
        body = json['text'],
        senddate = json['created_at'],
        senderid = json['senderid'],
        receiverid = json['reciver_id'];
}
