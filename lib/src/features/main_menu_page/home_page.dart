import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:in_app_messaging/src/features/chats/chats_pages/chat_messages_page.dart';
import 'package:in_app_messaging/src/helpers/date_time_helper.dart';
import 'package:in_app_messaging/src/res/app_colors.dart';
import 'package:in_app_messaging/src/res/app_icons.dart';
import 'package:in_app_messaging/src/res/app_text_styles.dart';
import 'package:in_app_messaging/src/services/chat_service.dart';
import 'package:in_app_messaging/src/widgets/loading_widget.dart';

import '../../services/user_services.dart';

class HomePage extends StatelessWidget{
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(AppIcons.chatBgWallPaper, width: double.infinity, fit: BoxFit.cover,),
        SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      StreamBuilder(
                        stream: UserService.currentUserStream,
                        builder: (_, snapshot) {
                          String userName = '';
                          if(snapshot.hasData){
                            userName = snapshot.requireData.data()!['userName'];
                          }
                          return RichText(text: TextSpan(
                              children: [
                                TextSpan(
                                    text: "Welcome back, ", style: AppTextStyles.subHeadingTextStyle.copyWith(fontFamily: 'Inter', fontSize: 20)
                                ),
                                TextSpan(
                                    text: userName, style: AppTextStyles.subHeadingTextStyle.copyWith(fontFamily: 'Inter', fontSize: 24, fontWeight: FontWeight.w700)
                                ),
                              ]
                          ));
                        }
                      ),
                      const SizedBox(height: 20,),
                      SizedBox(
                        height: 75,
                        child: ListView.builder(
                            itemCount: 10,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (ctx, index){
                          return const StoryWidget();
                        }),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 20,),
                Expanded(child: SizedBox(
                  height: double.infinity,
                  child: Card(
                    color: Colors.white,
                    margin: EdgeInsets.zero,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))
                    ),
                    child: StreamBuilder(
                      stream: ChatService.getUserChats,
                      builder: (_, snapshot) {
                        if(snapshot.hasData){
                          return Column(
                            children: snapshot.requireData.map((chat){
                              return Column(
                                children: [
                                  ListTile(
                                    leading: CircleAvatar(
                                      backgroundImage: CachedNetworkImageProvider(
                                        chat.remoteUser.userProfilePicture
                                      ),
                                    ),
                                    title: Text(chat.remoteUser.userName, style: AppTextStyles.subHeadingTextStyle.copyWith(color: Colors.black),),
                                    subtitle: chat.lastMessage != null
                                      ? Text(
                                          chat.lastMessage!.message,
                                          style: AppTextStyles.mediumTextStyle,
                                        )
                                      : const SizedBox(),
                                    trailing: chat.lastMessage != null ? Text(DateTimeHelper.timeAgo(chat.lastMessage!.timeStamp,), style: AppTextStyles.mediumTextStyle.copyWith(color: Colors.black)) : const SizedBox(),
                                    onTap: (){
                                      Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=> ChatMessagesPage(user: chat.remoteUser, roomID: chat.roomID)));
                                    },
                                ),
                                  const Divider(color: AppColors.dividerLightColor,)
                                ],
                              );
                            }).toList(),
                          );
                        }else if(snapshot.connectionState == ConnectionState.waiting){
                          return const LoadingWidget();
                        }else if(snapshot.hasError){
                          return Center(child: Text(snapshot.error.toString(), style: AppTextStyles.smallTextStyle,));
                        }

                        return const SizedBox();
                      }
                    ),
                  ),
                ))
              ],
        ))
      ],
    );
  }
  
}

class StoryWidget extends StatelessWidget {
  const StoryWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const CircleAvatar(
      backgroundColor: AppColors.amberYellowColor,
      radius: 45,
      child: CircleAvatar(
        radius: 35,
        backgroundColor: AppColors.amberYellowColor,
        backgroundImage: CachedNetworkImageProvider("https://images.unsplash.com/photo-1697017690254-5a4b64320721?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mzh8fEhhcHB5JTIwcGVvcGxlfGVufDB8fDB8fHww"),
      ),
    );
  }
}