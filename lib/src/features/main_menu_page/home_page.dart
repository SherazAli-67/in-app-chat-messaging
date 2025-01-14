import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:in_app_messaging/src/features/chats/chats_pages/chat_messages_page.dart';
import 'package:in_app_messaging/src/features/story_view_page.dart';
import 'package:in_app_messaging/src/helpers/date_time_helper.dart';
import 'package:in_app_messaging/src/res/app_colors.dart';
import 'package:in_app_messaging/src/res/app_icons.dart';
import 'package:in_app_messaging/src/res/app_text_styles.dart';
import 'package:in_app_messaging/src/services/chat_service.dart';
import 'package:in_app_messaging/src/user_model.dart';
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
                      const SizedBox(height: 10,),

                      SizedBox(
                        height: 140,
                        child: StreamBuilder(
                          stream: UserService.allUsers,
                          builder: (ctx,snapshot){
                            if(snapshot.hasData){
                              return ListView.builder(
                                  itemCount: snapshot.requireData.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (ctx, index){
                                    UserModel user = snapshot.requireData[index];
                                    return StoryWidget(user: user,);
                                  });
                            }

                            return const SizedBox();

                          },
                        ),
                      )
                    ],
                  ),
                ),
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
                          return snapshot.requireData.isEmpty ? SizedBox(
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(AppIcons.icEmptyChats,),
                                  const SizedBox(height: 20,),
                                  Text('"No Conversations"', style: AppTextStyles.subHeadingTextStyle.copyWith(color: Colors.black, fontSize: 20),),
                                  const SizedBox(height: 10,),
                                  const Text('Start a conversation with your contacts to chat with friends and family.', textAlign: TextAlign.center, style: AppTextStyles.mediumTextStyle),

                                ],
                              ),
                            ),
                          ) : Column(
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
                        }
                        else if(snapshot.connectionState == ConnectionState.waiting){
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
    required this.user
  });
  final UserModel user;
  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=>  StoryViewPage(user: user,)));
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 15.0),
        child: Column(
          children: [
            CircleAvatar(
              backgroundColor: AppColors.amberYellowColor,
              radius: 40,
              child: CircleAvatar(
                radius: 37,
                backgroundColor: AppColors.amberYellowColor,
                backgroundImage: CachedNetworkImageProvider(user.userProfilePicture),
              ),
            ),
            const SizedBox(height: 10,),
            SizedBox(
                width: 100,
                child: Text(user.userName, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, color: Colors.white),))
          ],
        ),
      ),
    );
  }
}