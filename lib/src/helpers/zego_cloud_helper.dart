import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:in_app_messaging/src/services/user_services.dart';
import 'package:in_app_messaging/src/user_model.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

class ZegoCloudHelper {
  static Future<void> initZegoCloudInvitationService()async{
    int appID = int.parse(dotenv.env['ZEGO_CLOUD_APP_ID']!);
    String appSignIn = dotenv.env['ZEGO_CLOUD_APP_SIGNIN']!;
    try{
      UserModel? user = await UserService.getCurrentUser();
      ZegoUIKitPrebuiltCallInvitationService().init(
        appID: appID /*input your AppID*/,
        appSign: appSignIn /*input your AppSign*/,
        userID: user!.userID,
        userName: user.userName,
        plugins: [ZegoUIKitSignalingPlugin()],
      );
    }catch(e){
      String errorMessage = e.toString();
      if(e is PlatformException){
        errorMessage = e.message!;
      }

      debugPrint("Exception while initializing the zegoKit on Login: $errorMessage");
    }
  }

  static Future<void> deInitializeZegoCloud()async{
    await ZegoUIKitPrebuiltCallInvitationService().uninit();
  }
}