import '../user_model.dart';
import 'message_model.dart';

class ChatModel {
  UserModel remoteUser;
  String roomID;
  MessageModel? lastMessage;
  ChatModel({required this.remoteUser, required this.roomID, this.lastMessage});
}