import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:in_app_messaging/src/features/chats/chats_pages/chat_messages_page.dart';
import 'package:in_app_messaging/src/models/chat_model.dart';
import 'package:in_app_messaging/src/res/app_colors.dart';
import 'package:in_app_messaging/src/res/app_text_styles.dart';
import 'package:in_app_messaging/src/services/chat_service.dart';
import 'package:in_app_messaging/src/user_model.dart';
import 'package:in_app_messaging/src/widgets/loading_widget.dart';

class SelectUserToChat extends StatefulWidget{
  const SelectUserToChat({super.key});

  @override
  State<SelectUserToChat> createState() => _SelectUserToChatState();
}

class _SelectUserToChatState extends State<SelectUserToChat> {
  bool _isLoading = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Align(
                    alignment: Alignment.center,
                    child: Text("New Chat", style: AppTextStyles.subHeadingTextStyle.copyWith(fontSize: 20, fontWeight: FontWeight.w600),)),
                const SizedBox(height: 20,),
                StreamBuilder(stream: ChatService.getUserChats, builder: (_, snapshot){
                  if(snapshot.hasData && snapshot.requireData.isNotEmpty){
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text("Recently contacted", style:  AppTextStyles.subHeadingTextStyle.copyWith(fontSize: 20),),
                        ),
                        Card(
                          child: Column(
                            children: snapshot.requireData.map((chat){
                              UserModel user = chat.remoteUser;
                              return Column(
                                children: [
                                  ListTile(
                                    leading: CircleAvatar(
                                      backgroundImage: CachedNetworkImageProvider(
                                        user.userProfilePicture
                                      ),
                                    ),
                                    title: Text(user.userName, style: AppTextStyles.subHeadingTextStyle,),
                                    onTap: (){
                                      Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=> ChatMessagesPage(user: user, roomID: chat.roomID)));
                                    },
                                  ),
                                  const Divider(color: AppColors.dividerDarkColor,)
                                ],
                              );
                            }).toList(),
                          ),
                        )
                      ],
                    );
                  }else if(snapshot.connectionState == ConnectionState.waiting){
                    return const LoadingWidget();
                  }else if(snapshot.hasError){
                    return Center(child: Text(snapshot.error.toString()),);
                  }

                  return const SizedBox();
                }),
                const SizedBox(height: 20,),
                StreamBuilder(stream: ChatService.getAllChats, builder: (_, snapshot){
                  if(snapshot.hasData && snapshot.requireData.isNotEmpty){
                    List<UserModel> allContacts = snapshot.requireData;
                    allContacts.sort((a, b)=> a.userName.compareTo(b.userName));
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                           Text("All Contacts", style: AppTextStyles.subHeadingTextStyle.copyWith(fontSize: 20),),
                          const SizedBox(height: 10,),
                          Card(
                            elevation: 1,
                            // color: AppColors.unSelectedGreyColor,
                            margin: EdgeInsets.zero,

                            child: Column(
                              children: snapshot.requireData.map((user){
                                return Column(
                                  children: [
                                    ListTile(
                                      leading: CircleAvatar(
                                        backgroundImage: CachedNetworkImageProvider(
                                            user.userProfilePicture
                                        ),
                                      ),
                                      title: Text(user.userName, style: AppTextStyles.subHeadingTextStyle,),
                                      onTap: ()async{
                                        setState(() =>_isLoading = true);
                                        String? roomID = await ChatService.createChatRoom(chatUser: user);
                                        if(roomID != null){
                                          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx)=> ChatMessagesPage(user: user, roomID: roomID)));
                                        }else {
                                          //Failed to create chat room
                                        }
                                      },
                                    ),
                                    const Divider(color: AppColors.dividerDarkColor,),
                                  ],
                                );
                              }).toList(),
                            ),
                          )
                        ],
                      ),
                    );
                  }else if(snapshot.connectionState == ConnectionState.waiting){
                    return const LoadingWidget();
                  }else if(snapshot.hasError){
                    return Center(child: Text(snapshot.error.toString()),);
                  }

                  return const SizedBox();
                }),

              ],
            ),
            if(_isLoading)
              Container(
                height: double.infinity,
                width: double.infinity,
                color: Colors.black45,
                child: const LoadingWidget(),
              )
          ],
        ),
      ),
    );
  }
}