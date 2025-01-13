import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String messageID;
  final String message;
  final String senderID;
  final String messageType;
  final bool readByRecipient;
  final Timestamp timeStamp;
  final List<AttachmentModel> attachments;

  MessageModel({
    required this.messageID,
    required this.message,
    required this.senderID,
    required this.messageType,
    required this.readByRecipient,
    required this.timeStamp,
    this.attachments = const [],
  });

  // Create MessageModel from a Map
  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      messageID: map['messageID'] ?? '',
      message: map['message'] ?? '',
      senderID: map['senderID'] ?? '',
      messageType: map['messageType'] ?? '',
      readByRecipient: map['readByRecipient'] ?? false,
      timeStamp: map['timeStamp'] ?? Timestamp.now(),
      attachments: (map['attachments'] as List<dynamic>?)
          ?.map((item) => AttachmentModel.fromMap(item as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }

  // Convert MessageModel to a Map
  Map<String, dynamic> toMap() {
    return {
      'messageID': messageID,
      'message': message,
      'senderID': senderID,
      'messageType': messageType,
      'readByRecipient': readByRecipient,
      'timeStamp': timeStamp,
      'attachments': attachments.map((attachment) => attachment.toMap()).toList(),
    };
  }
}

class AttachmentModel {
  String url;
  String title;

  AttachmentModel({
    required this.url,
    required this.title,
  });

  // Convert AttachmentModel object to Map
  Map<String, dynamic> toMap() {
    return {
      'url': url,
      'title': title,
    };
  }

  // Create AttachmentModel from Map
  factory AttachmentModel.fromMap(Map<String, dynamic> map) {
    return AttachmentModel(
      url: map['url'] ?? '',
      title: map['title'] ?? '',
    );
  }
}