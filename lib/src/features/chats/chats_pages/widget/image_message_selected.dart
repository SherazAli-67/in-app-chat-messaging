import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:in_app_messaging/src/res/app_icons.dart';
import '../../../../widgets/loading_widget.dart';
import 'write_message_textfield_widget.dart';

class MessagesImageSelectedPage extends StatefulWidget {
  const MessagesImageSelectedPage({super.key, required this.files, required this.messageTextController, required this.focusNode, required this.onDiscardTap, required this.roomID, required this.receiverID});
  final List<PlatformFile> files;
  final TextEditingController messageTextController;
  final FocusNode focusNode;
  final VoidCallback onDiscardTap;
  final String roomID;
  final String receiverID;
  @override
  State<MessagesImageSelectedPage> createState() => _MessagesImageSelectedPageState();
}

class _MessagesImageSelectedPageState extends State<MessagesImageSelectedPage> {

  bool sendingMessage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child:  Stack(
          children: [
            Column(
              children: [
                Expanded(child: Stack(
                  alignment: Alignment.center,
                  children: [
                    PageView.builder(
                        itemCount: widget.files.length,
                        itemBuilder: (ctx, index){
                          PlatformFile file = widget.files[index];
                          if(file.name.endsWith('.pdf')){
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(AppIcons.icPDF, colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn), height: 100,),
                                const SizedBox(height: 10,),
                                Text(file.name, style: const TextStyle(color: Colors.white,fontSize: 16),)
                              ],
                            );
                          }else{
                            return Image.file(File(file.path!));
                          }
                        }),
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 28.0),
                        child: IconButton(onPressed: widget.onDiscardTap, icon: const Icon(Icons.close)),
                      ),
                    ),
                  ],
                )),
                const SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(child: WriteMessageTextField(messageController: widget.messageTextController, focusNode: widget.focusNode, isImageMessage: true,)),
                      const SizedBox(width: 10,),
                      InkWell(
                          onTap:sendMessage,
                          child: SvgPicture.asset(AppIcons.icSend))
                    ],
                  ),
                )
              ],
            ),
            if(sendingMessage)
              Container(
                height: double.infinity,
                width: double.infinity,
                color: Colors.black45,
                child: const LoadingWidget()
              )
          ],
        ),
      ),
    );
  }



  void sendMessage() async{
  /*  setState(()=> sendingMessage = true);
    String message = widget.messageTextController.text.trim();

    try{
      await ChatService.sendAttachmentMessage(message: message, files: widget.files, roomID: widget.roomID, receiverID: widget.roomID);
    }catch(e){
      debugPrint("Exception while sending attachment messages: ${e.toString()}");
    }

    widget.messageTextController.clear();
    widget.onDiscardTap();
    setState(()=> sendingMessage = false);*/
  }
}