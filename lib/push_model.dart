class PushMessage {
  final String? title;
  final String? body;
  final Map<String, dynamic> data;

  PushMessage({this.title, this.body, required this.data});

  factory PushMessage.fromMap(Map<dynamic, dynamic> map) {
    return PushMessage(
      title: map['title'],
      body: map['body'],
      data: Map<String, dynamic>.from(map['data'] ?? {}),
    );
  }
}
