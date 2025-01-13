import 'package:flutter/material.dart';
import 'package:in_app_messaging/src/res/app_colors.dart';
import 'package:in_app_messaging/src/res/app_text_styles.dart';
import 'package:intl/intl.dart';

import '../../../../models/message_model.dart';
class SenderChatItemWidget extends StatelessWidget{
  final MessageModel message;
  final Size size;
  const SenderChatItemWidget({super.key, required this.message,required this.size,});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.width*0.7,
      child: Align(
        alignment: Alignment.topRight,
        child:  Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ConstrainedBox(constraints: BoxConstraints(maxWidth: size.width*0.7,),
                  child:

             /*     message.messageType == messageTypeAttachment
                      ? Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        children: message.attachments
                            .map((attachment){
                          return attachment.title.contains('.pdf') ? GestureDetector(
                            onTap: ()async{
                              debugPrint("On tap");
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
                                child: Row(children: [
                                  SvgPicture.asset(icPdf),
                                  const SizedBox(width: 10,),
                                  SizedBox(
                                      width: size.width*0.5,
                                      child: Text(attachment.title))
                                ],),
                              ),
                            ),
                          ) : Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: CachedNetworkImage(imageUrl: attachment.url,)),
                          );
                        })
                            .toList(),
                      ),
                      if(message.message.isNotEmpty)
                        Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: primaryColor)
                            ),
                            child: Text(message.message, style: smallTextStyle.copyWith(color: Colors.white),))
                    ],
                  )
                      : */

                  Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: AppColors.senderMsgBgColor,
                          borderRadius: BorderRadius.circular(99),
                          border: Border.all(color: AppColors.amberYellowColor)
                      ),
                      child: Text(message.message, style: AppTextStyles.mediumTextStyle.copyWith(color: Colors.black))),
                ),
                Row(
                  children: [
                    Text(DateFormat('hh:mm a',).format(message.timeStamp.toDate()), style: AppTextStyles.smallTextStyle.copyWith( fontSize: 10)),
                    const SizedBox(width: 2,),
                    Icon(Icons.done_all, size: 15, color: message.readByRecipient ? Colors.green : Colors.grey),

                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}