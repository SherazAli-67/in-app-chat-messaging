import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:in_app_messaging/src/data/app_data.dart';
import 'package:in_app_messaging/src/res/app_text_styles.dart';
import 'package:in_app_messaging/src/user_model.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/widgets/story_view.dart';

class StoryViewPage extends StatefulWidget{
  const StoryViewPage({super.key, required this.user});
  final UserModel user;
  @override
  State<StoryViewPage> createState() => _StoryViewPageState();
}

class _StoryViewPageState extends State<StoryViewPage> {
  final StoryController storyController = StoryController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            StoryView(
              controller: storyController,
              storyItems: AppData.getStories(storyController: storyController),
              onStoryShow: (storyItem, index) {
                print('Story shown: ${index}');
              },
              onComplete: () {
                Navigator.of(context).pop();
              },

            ),
            Positioned(
                top: 20,
                left: 0,
                right: 0,
                child: SizedBox(

                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: CachedNetworkImageProvider(widget.user.userProfilePicture),
                    ),
                    title: Text(widget.user.userName, style: AppTextStyles.subHeadingTextStyle,),
                    subtitle: Text("Today, 6:57 AM"),
                              ),
                ))
          ],
        ),
      ),
    );
  }
}