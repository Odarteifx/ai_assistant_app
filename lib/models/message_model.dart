// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String message;
  final String messageId;
  final Timestamp timestamp;
  Message({
    required this.message,
    required this.messageId,
    required this.timestamp,
  });

  Message copyWith({
    String? message,
    String? messageId,
    Timestamp? timestamp,
  }) {
    return Message(
      message: message ?? this.message,
      messageId: messageId ?? this.messageId,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'message': message,
      'messageId': messageId,
      'timestamp': timestamp.toDate().toIso8601String(),
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      message: map['message'] as String,
      messageId: map['messageId'] as String,
      timestamp: Timestamp.fromDate(DateTime.parse(map['timestamp'] as String)),
    );
  }

  String toJson() => json.encode(toMap());

  factory Message.fromJson(String source) =>
      Message.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'Message(message: $message, messageId: $messageId, timestamp: $timestamp)';

  @override
  bool operator ==(covariant Message other) {
    if (identical(this, other)) return true;

    return other.message == message &&
        other.messageId == messageId &&
        other.timestamp == timestamp;
  }

  @override
  int get hashCode =>
      message.hashCode ^ messageId.hashCode ^ timestamp.hashCode;
}
