import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:in_app_messaging/src/res/app_colors.dart';
import 'package:in_app_messaging/src/res/app_icons.dart';
import 'package:in_app_messaging/src/res/app_text_styles.dart';
import 'package:in_app_messaging/src/services/chat_service.dart';
import '../../../models/message_model.dart';
import '../../../user_model.dart';
import '../../../widgets/loading_widget.dart';
import 'widget/image_message_selected.dart';
import 'widget/receiver_item_widget.dart';
import 'widget/sender_item_widget.dart';
import 'widget/write_message_textfield_widget.dart';

class ChatMessagesPage extends StatefulWidget{
  final UserModel user;
  final String roomID;
  const ChatMessagesPage({super.key, required this.user,required this.roomID});

  @override
  State<ChatMessagesPage> createState() => _ChatMessagesPageState();
}

class _ChatMessagesPageState extends State<ChatMessagesPage> {
  late TextEditingController _messageController;
  late FocusNode _focusNode;
  bool sendingMessage = false;
  late String currentUID;
  late Size size;
  bool showImagesPage = false;
  late List<PlatformFile> selectedFiles;
  @override
  void initState() {
    _messageController = TextEditingController();
    _focusNode = FocusNode();
    currentUID = FirebaseAuth.instance.currentUser!.uid;
    super.initState();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _focusNode.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    return showImagesPage ? MessagesImageSelectedPage(files: selectedFiles, messageTextController: _messageController, focusNode: _focusNode, onDiscardTap: _onDiscardImageSendTap, roomID: widget.roomID, receiverID: widget.user.userID,) : Scaffold(
      body: Stack(
        children: [
          Image.asset(AppIcons.chatBgWallPaper, width: double.infinity, fit: BoxFit.cover,),
          Column(
            children: [
              Padding(padding: const EdgeInsets.only(left: 20, right: 20, top: 45), child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 5),
                leading: CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(widget.user.userProfilePicture),
                ),
                title: Text(widget.user.userName,style: AppTextStyles.subHeadingTextStyle.copyWith(fontWeight: FontWeight.w600),),
                subtitle: const Text("Online"),
                trailing: PopupMenuButton(
                  icon: const Icon(Icons.more_vert_rounded),
                  itemBuilder: (BuildContext context) {
                    return [
                    ];
                  },),
              ),),
              const SizedBox(height: 20,),
              Expanded(
                  child: Card(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(topRight: Radius.circular(25), topLeft: Radius.circular(25))
                    ),
                    margin: EdgeInsets.zero,
                    color: Colors.white,
                    child: StreamBuilder(
                      stream: ChatService.getChatMessages(roomID: widget.roomID),
                      builder: (ctx, snapshot){
                        if(snapshot.hasData){
                          List<MessageModel> messages = snapshot.data!;
                          messages.reversed;
                          messages.sort((a, b) => b.timeStamp.compareTo(a.timeStamp));
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                Expanded(child: ListView.builder(
                                    itemCount: messages.length,
                                    reverse: true,
                                    itemBuilder: (ctx, index){
                                      MessageModel message = messages[index];
                                      if(message.senderID == currentUID){
                                        return SenderChatItemWidget(message: message, size:  size, );
                                      }

                                      return ReceiverChatItemWidget(roomID: widget.roomID, message: message, size:  size,);
                                    })),

                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 20),
                                        child: Row(
                                          children: [
                                            Expanded(child: WriteMessageTextField(messageController: _messageController, focusNode: _focusNode)),
                                            const SizedBox(width: 10,),
                                            sendingMessage ? const LoadingWidget() :
                                            Row(
                                              children: [
                                                _buildSendMessageButton(onTap: onSendMessage, icon: AppIcons.icSend,),
                                              ],
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          );
                        }
                        return const LoadingWidget();
                      },
                    ),
                  )
              ),
            ],
          )
        ],
      ),
    );
  }
  GestureDetector _buildSendMessageButton({required VoidCallback onTap, required String icon}) {
    return GestureDetector(
        onTap: onTap,
        child: SvgPicture.asset(icon,
          colorFilter:  const ColorFilter.mode(AppColors.amberYellowColor, BlendMode.srcIn),
        ));
  }

  void onSendMessage()async{

    String message = _messageController.text.trim();
    if (message.isEmpty) {
      return;
    }
    setState(()=> sendingMessage = true);
    String messageID = DateTime.now().toString();

    String senderID = currentUID;
    String messageType ='text';
    Timestamp timestamp = Timestamp.now();
    MessageModel messageModel = MessageModel(messageID: messageID, message: message, senderID: senderID, messageType: messageType, readByRecipient: false, timeStamp: timestamp);
    try{
      await ChatService.sendMessage(roomID: widget.roomID, message: messageModel, userID: widget.user.userID);
      _messageController.clear();
    }catch(e){
      debugPrint("Exception while sending message: ${e.toString()}");
    }
    setState(()=> sendingMessage = false);
  }

/*  void _pickImage()async {

    FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true);
    if(result != null && result.files.isNotEmpty){
      showImagesPage = true;
      selectedFiles = result.files;
      setState(() {});
    }
  }*/

  void _onDiscardImageSendTap(){
    showImagesPage = false;
    selectedFiles = [];
    setState(() {});
  }
}


