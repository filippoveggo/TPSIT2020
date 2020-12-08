import 'dart:convert';

class MessageModel {
  final String username;
  final String content;
  MessageModel({
    this.username,
    this.content,
  });

  MessageModel copyWith({
    String username,
    String content,
  }) {
    return MessageModel(
      username: username ?? this.username,
      content: content ?? this.content,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'content': content,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return MessageModel(
      username: map['username'],
      content: map['content'],
    );
  }

  String toJson() => json.encode(toMap());

  factory MessageModel.fromJson(String source) =>
      MessageModel.fromMap(json.decode(source));

  @override
  String toString() => 'MessageModel(username: $username, content: $content)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is MessageModel && o.username == username && o.content == content;
  }

  @override
  int get hashCode => username.hashCode ^ content.hashCode;
}
