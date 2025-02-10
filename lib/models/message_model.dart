// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderId;
  final String message;
  final String messageId;
  final Timestamp timestamp;
  Message({
    required this.senderId,
    required this.message,
    required this.messageId,
    required this.timestamp,
  });

  Message copyWith({
    String? senderId,
    String? message,
    String? messageId,
    Timestamp? timestamp,
  }) {
    return Message(
      senderId: senderId ?? this.senderId,
      message: message ?? this.message,
      messageId: messageId ?? this.messageId,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'senderId': senderId,
      'message': message,
      'messageId': messageId,
      'timestamp': timestamp.toDate().toIso8601String(),
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      senderId: map['senderId'] as String,
      message: map['message'] as String,
      messageId: map['messageId'] as String,
      timestamp: Timestamp.fromDate(DateTime.parse(map['timestamp'] as String)),
    );
  }

  String toJson() => json.encode(toMap());

  factory Message.fromJson(String source) =>
      Message.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Message(senderId: $senderId, message: $message, messageId: $messageId, timestamp: $timestamp)';
  }

  @override
  bool operator ==(covariant Message other) {
    if (identical(this, other)) return true;

    return other.senderId == senderId &&
        other.message == message &&
        other.messageId == messageId &&
        other.timestamp == timestamp;
  }

  @override
  int get hashCode {
    return senderId.hashCode ^
        message.hashCode ^
        messageId.hashCode ^
        timestamp.hashCode;
  }
}
