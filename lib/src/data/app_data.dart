import 'package:flutter/cupertino.dart';
import 'package:in_app_messaging/src/res/app_colors.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/story_view.dart';

class AppData{
  static List<StoryItem> getStories({required StoryController storyController}) {
    return [
      StoryItem.text(title: "Welcome to In App Messaging App", backgroundColor: AppColors.amberYellowColor, ),
      StoryItem.pageImage(
          url:
              "https://firebasestorage.googleapis.com/v0/b/hitches-mobile-app.appspot.com/o/WhatsApp%20Image%202025-01-14%20at%2011.18.28.jpeg?alt=media&token=f96d7d4a-0c9b-4e81-b215-40891e1192c8",
          controller: storyController,
        caption:  const Text("I am a Top-Rated Mobile App Developer and Freelancer with a perfect 100% job success score on Upwork.")
      ),
      // StoryItem.("https://videos.pexels.com/video-files/3629511/3629511-sd_360_450_24fps.mp4", controller: storyController)
    ];
  }
}