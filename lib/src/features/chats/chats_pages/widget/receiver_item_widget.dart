import 'package:flutter/material.dart';
import 'package:in_app_messaging/src/res/app_colors.dart';
import 'package:in_app_messaging/src/res/app_text_styles.dart';
import 'package:in_app_messaging/src/services/chat_service.dart';
import 'package:intl/intl.dart';

import '../../../../models/message_model.dart';

class ReceiverChatItemWidget extends StatefulWidget{
  final MessageModel message;
  final String roomID;
  final Size size;
  const ReceiverChatItemWidget({super.key,required this.roomID, required this.message, required this.size,});

  @override
  State<ReceiverChatItemWidget> createState() => _ReceiverChatItemWidgetState();
}

class _ReceiverChatItemWidgetState extends State<ReceiverChatItemWidget> {
  @override
  void initState() {
    super.initState();
    if(!widget.message.readByRecipient){
      ChatService.updateReadByRecipientTrue(roomID: widget.roomID, messageID: widget.message.messageID);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: widget.size.width*0.7,
        ),
        child:

       /* widget.message.messageType == messageTypeAttachment
            ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.message.attachments.map((attachment) {
                return attachment.title.contains('.pdf') ? GestureDetector(
                  onTap: ()async{
                    Uri uri = Uri.parse(attachment.url);
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri);
                    } else {
                      throw 'Could not launch ${attachment.url}';
                    }
                  },
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SvgPicture.asset(icPdf),
                          const SizedBox(width: 10,),
                          SizedBox(
                              width: widget.size.width*0.5,
                              child: Text(attachment.title))
                        ],),
                    ),
                  ),
                ) : Padding(
                  padding: const EdgeInsets.only(bottom: 5.0, left: 8),
                  child: ClipRRect(borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(imageUrl: attachment.url,)),);
              }
              ).toList(),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.grey)
                  ),
                  child: Text( widget.message.message, textAlign: TextAlign.start, style: smallTextStyle.copyWith(color: Colors.white),)),
            )
          ],
        )
            : */

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              margin: const EdgeInsets.all(10,),
              decoration: BoxDecoration(
                  color: AppColors.receiverMsgBgColor,
                  borderRadius: BorderRadius.circular(99),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.message.message, textAlign: TextAlign.end, style: AppTextStyles.mediumTextStyle.copyWith(color: Colors.black)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Text(DateFormat('hh:mm a',).format(widget.message.timeStamp.toDate()), style: AppTextStyles.smallTextStyle.copyWith( fontSize: 10)),
            ),

          ],
        ),
      ),
    );
  }
}