import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:in_app_messaging/src/res/app_strings.dart';
import 'package:in_app_messaging/src/services/user_services.dart';
import 'package:in_app_messaging/src/user_model.dart';

import '../models/chat_model.dart';
import '../models/message_model.dart';

class ChatService{
  static final chatColRef = FirebaseFirestore.instance.collection(chatsCollection);
  static final userColRef = FirebaseFirestore.instance.collection(usersCollection);

  static Stream<List<UserModel>> get frequentlyContactedChats {
    String currentUID = FirebaseAuth.instance.currentUser!.uid;
    return chatColRef
        .doc(currentUID)
        .collection(chatsCollection)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => UserModel.fromMap(doc.data())).toList());
  }

  static Stream<List<UserModel>> get getAllChats {
    String currentUID = FirebaseAuth.instance.currentUser!.uid;
    return userColRef.where("userID", isNotEqualTo: currentUID)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc)=> UserModel.fromMap(doc.data())).toList());
  }

  static Future<String?> createChatRoom({required UserModel chatUser, })async{
    String currentUID = FirebaseAuth.instance.currentUser!.uid;
    String roomID = '${currentUID}_${chatUser.userID}';



    bool isCreated = false;
    try{
      //Check if the chat exists already
      DocumentSnapshot docSnap = await chatColRef.doc(roomID).get();
      if(docSnap.exists){
        return roomID;
      }else {
        String reverseRoomID = '${chatUser.userID}_$currentUID';
        DocumentSnapshot docSnap = await chatColRef.doc(reverseRoomID).get();
        if(docSnap.exists){
          return reverseRoomID;
        }
      }
      await chatColRef.doc(roomID).get().then((value) async {
        if(!value.exists){
          UserModel? currentUser = await UserService.getCurrentUser();
          Timestamp createdAt = Timestamp.now();
          Map<String, dynamic> chatMap = {
            currentUID: currentUser!.toMap(),
            chatUser.userID: chatUser.toMap(),
            roomID : roomID,
            createdAtKey : createdAt
          };
          await FirebaseFirestore.instance.collection(chatsCollection).doc(roomID).set(chatMap);
          isCreated = true;
          debugPrint("ChatService: createChatRoom invoked: chat created");
          // NotificationService.sendNotification(receiverID: userID, senderName: doctor.name);
        }
      });
    }catch(e){
      debugPrint("Exception while creating room: ${e.toString()}");
    }


    return isCreated ? roomID : null;
  }

  static Stream<List<ChatModel>> get getUserChats {
    String currentUID = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance
        .collection(chatsCollection)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs
            .where((doc) => doc.id.split('_').contains(currentUID))
            .map((doc) {
          final docID =  doc.id;
          List<String> userIDs =  docID.split('_');
          String remoteUID = userIDs.where((userID) => userID != FirebaseAuth.instance.currentUser!.uid).first;
          UserModel remoteUser = UserModel.fromMap(doc.data()[remoteUID]);
          MessageModel? lastMessage = doc.data()[lastMessageKey] != null
              ? MessageModel.fromMap(doc.data()[lastMessageKey])
              : null;
          final chatModel = ChatModel(remoteUser: remoteUser, roomID: docID, lastMessage: lastMessage);
          return chatModel;
        },)
            .toList()
          ..sort((a, b) {
            final aTimeStamp =
                a.lastMessage?.timeStamp ?? Timestamp.fromMillisecondsSinceEpoch(0);
            final bTimeStamp =
                b.lastMessage?.timeStamp ?? Timestamp.fromMillisecondsSinceEpoch(0);
            return bTimeStamp.compareTo(aTimeStamp);
          }));;


  }

  static Future<void> sendMessage({required String roomID,required MessageModel message, required String userID}) async{

    await chatColRef.doc(roomID).collection(messagesCollection).doc(message.messageID).set(message.toMap());
    chatColRef.doc(roomID).update({
      lastMessageKey: message.toMap()
    });

  }

  static Stream<List<MessageModel>> getChatMessages({required String roomID}) {
    return FirebaseFirestore.instance.collection(chatsCollection).doc(roomID).collection(messagesCollection)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => MessageModel.fromMap(doc.data()))
        .toList());
  }

  static void updateReadByRecipientTrue({required String roomID, required String messageID}) async{
    await chatColRef.doc(roomID).collection(messagesCollection).doc(messageID).update({
      'readByRecipient' : true
    });
  }

  static Stream<int> getUnReadMessagesCount({required String roomID}) {
    String currentUID = FirebaseAuth.instance.currentUser!.uid;
    return chatColRef
        .doc(roomID)
        .collection(messagesCollection)
        .where('readByRecipient', isEqualTo: false) // Unread messages
        .snapshots()
        .map((snapshot) {
      // Filter messages where senderID != currentUID
      final unreadMessages = snapshot.docs.where((doc) {
        final data = doc.data();
        return data['senderID'] != currentUID;
      }).toList();
      return unreadMessages.length; // Return count of filtered messages
    });
  }

/*
  static Future<void> sendAttachmentMessage({required String message, required List<PlatformFile> files, required String roomID, required String receiverID})async{

    */
/* if (message.isEmpty) {
      return;
    }*//*

    //
    String messageID = DateTime.now().toString();

    String senderID = FirebaseAuth.instance.currentUser!.uid;
    String messageType = messageTypeAttachment;
    Timestamp timestamp = Timestamp.now();
    final firebaseStorage = FirebaseStorage.instance;
    final List<AttachmentModel> attachments = [];
    for (var file in files) {
      debugPrint("Path: ${file.name}");
      final storageRef = firebaseStorage.ref().child('chatMessages/${file.name}');
      await storageRef.putFile(File(file.path!));
      final downloadUrl = await storageRef.getDownloadURL();
      attachments.add(AttachmentModel(url: downloadUrl, title: file.name));
    }
    MessageModel messageModel = MessageModel(messageID: messageID, message: message, senderID: senderID, messageType: messageType, readByRecipient: false, timeStamp: timestamp, attachments: attachments);
    try{
      await ChatsService.sendMessage(roomID: roomID, message: messageModel, userID: receiverID);

    }catch(e){
      debugPrint("Exception while sending message: ${e.toString()}");
    }
    //
  }
*/
}