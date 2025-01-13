import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:in_app_messaging/src/models/chat_model.dart';
import 'package:in_app_messaging/src/res/app_colors.dart';
import 'package:in_app_messaging/src/res/app_icons.dart';
import 'package:in_app_messaging/src/res/app_text_styles.dart';
import 'package:in_app_messaging/src/services/chat_service.dart';

import '../../../helpers/date_time_helper.dart';
import '../../../widgets/loading_widget.dart';
import 'chat_messages_page.dart';
class ChatsPage extends StatefulWidget{
  const ChatsPage({super.key});

  @override
  State<ChatsPage> createState() => _ChatsPageState();


}

class _ChatsPageState extends State<ChatsPage> {
  late TextEditingController controller;

  @override
  void initState() {
    controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        scrolledUnderElevation: 0,
        title: const Text("Chats page", style: titleTextStyle,),
        centerTitle: true,
      ),*/
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0, ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: 'Search',
                    hintStyle: AppTextStyles.smallTextStyle,
                    labelStyle: AppTextStyles.smallTextStyle,
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: const BorderSide(
                            color: Color(0xffBEBEBE)
                        )
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: const BorderSide(
                            color: Colors.black
                        )
                    ),
                    contentPadding: const EdgeInsets.all(10),
                  ),
                  onChanged: (val){},
                  onTapOutside: (_)=> FocusManager.instance.primaryFocus!.unfocus(),
                ),
              ),
              const SizedBox(height: 20,),
               StreamBuilder(
                stream: ChatService.getUserChats,
                builder: (ctx, snapshot){
                  if(snapshot.hasData){
                    return snapshot.requireData.isEmpty ? Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                                Expanded(
                                    child: SvgPicture.asset(
                                  AppIcons.icEmptyChats,
                                      colorFilter: const ColorFilter.mode( Colors.white, BlendMode.srcIn),
                                )),
                                const SizedBox(height: 20,),
                           const Expanded(child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15.0),
                            child: Column(
                              children: [
                                Text("No Conversations", textAlign: TextAlign.center, style: AppTextStyles.largeTextStyle,),
                                SizedBox(height: 10,),
                                Text('Start a conversation with your connects to chat with like-minded people.', textAlign: TextAlign.center, style: AppTextStyles.subHeadingTextStyle,),
                               /* const SizedBox(height: 20,),

                                SizedBox(
                                    width: double.infinity,
                                    child: PrimaryBtn(btnText: "Connect with People", onPressed: (){}, color: primaryColor,))*/
                              ],
                            ),
                          )),
                        ],
                      ),
                    ): Expanded(child: ListView.builder(
                        itemCount: snapshot.requireData.length,
                        itemBuilder: (ctx, index){
                      ChatModel chat = snapshot.requireData[index];
                      return Column(
                        children: [
                          ListTile(
                            onTap: (){
                              Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=> ChatMessagesPage(user: chat.remoteUser, roomID: chat.roomID)));
                            },
                            // tileColor: isDarkTheme ?  Colors.black45 : Colors.grey[300],
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5))
                            ),
                            leading: CircleAvatar(
                              backgroundImage: CachedNetworkImageProvider(chat.remoteUser.userProfilePicture),
                            ),
                            title: Text(chat.remoteUser.userName, style: AppTextStyles.subHeadingTextStyle,),
                            subtitle: chat.lastMessage != null ? Text(chat.lastMessage!.message, maxLines: 1, overflow: TextOverflow.ellipsis, style: AppTextStyles.smallTextStyle.copyWith(color: Colors.grey),) : null,
                            trailing: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                StreamBuilder(stream: ChatService.getUnReadMessagesCount(roomID: chat.roomID), builder: (ctx, snapshot){
                                  if(snapshot.hasData){
                                    if(snapshot.requireData >  0){
                                      return CircleAvatar(
                                        radius: 10,
                                        backgroundColor: AppColors.amberYellowColor,
                                        child: Text(snapshot.requireData.toString(), style: const TextStyle(color: Colors.white, fontSize: 12),),
                                      );
                                    }

                                  }
                                  return const SizedBox();
                                }),
                                const SizedBox(height: 8,),
                                chat.lastMessage != null
                                    ? Text(
                                  DateTimeHelper.timeAgo(chat.lastMessage!.timeStamp,),
                                  style: AppTextStyles.smallTextStyle.copyWith(color: Colors.grey),)
                                    : const SizedBox()
                              ],
                            ),
                          ),
                          const Divider(color: AppColors.dividerDarkColor ,)
                        ],
                      );
                    }));
                  }else if(snapshot.connectionState == ConnectionState.waiting){
                    return const LoadingWidget();
                  }else if(snapshot.hasError){
                    return Center(child: Text(snapshot.error.toString()),);
                  }

                  return const SizedBox();
                },
              )
            ],
          ),
        ),
      ),
    );
  }

}