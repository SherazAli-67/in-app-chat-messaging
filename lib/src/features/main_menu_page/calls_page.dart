import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:in_app_messaging/src/models/chat_model.dart';
import 'package:in_app_messaging/src/res/app_colors.dart';
import 'package:in_app_messaging/src/res/app_icons.dart';
import 'package:in_app_messaging/src/services/chat_service.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

import '../../res/app_text_styles.dart';
import '../../widgets/loading_widget.dart';

class CallsPage extends StatelessWidget{
  const CallsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding:  EdgeInsets.all(10.0),
              child: Text("Beep Calls", style: AppTextStyles.subHeadingTextStyle,),
            ),
            const SizedBox(height: 20,),
            Expanded(
              child: StreamBuilder(
                stream: ChatService.getUserChats,
                builder: (ctx, snapshot){
                  if(snapshot.hasData){
                    return ListView.builder(
                        itemCount: snapshot.requireData.length,
                        itemBuilder: (ctx, index){
                      ChatModel chat = snapshot.requireData[index];
                      return Column(
                        children: [
                          ListTile(
                            leading: CircleAvatar(
                              backgroundImage: CachedNetworkImageProvider(chat.remoteUser.userProfilePicture),
                            ),
                            title: Text(chat.remoteUser.userName, style: AppTextStyles.subHeadingTextStyle,),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _buildZegoSendCallInvitationButton(chat, isVideoCall: false),
                                const SizedBox(width: 10,),
                                _buildZegoSendCallInvitationButton(chat, isVideoCall: true),
                              ],
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                          ),
                          const Divider(color: AppColors.dividerDarkColor,)
                        ],
                      );
                    });
                  }else if(snapshot.connectionState == ConnectionState.waiting){
                    return const LoadingWidget();
                  }else if(snapshot.hasError){
                    return Center(child: Text(snapshot.error.toString(), style: AppTextStyles.smallTextStyle,));
                  }
              
                  return const SizedBox();
                },
              ),
            ),
          ],
        )
      ),
    );
  }

  ZegoSendCallInvitationButton _buildZegoSendCallInvitationButton(ChatModel chat, {required bool isVideoCall}) {
    return ZegoSendCallInvitationButton(
      isVideoCall: isVideoCall,
      //You need to use the resourceID that you created in the subsequent steps.
      //Please continue reading this document.
      resourceID: "zegouikit_call",
      invitees: [
        ZegoUIKitUser(
          id: chat.remoteUser.userID,
          name: chat.remoteUser.userName,
        ),
      ],
      icon: isVideoCall ? ButtonIcon(icon: SvgPicture.asset( AppIcons.icVideo, colorFilter: const ColorFilter.mode(AppColors.unSelectedGreyColor, BlendMode.srcIn),)) : ButtonIcon(icon: SvgPicture.asset(AppIcons.icCall)),
      iconSize: const Size(24, 24),
      buttonSize: const Size(25, 25),
      callID: chat.roomID,
    );
  }

}