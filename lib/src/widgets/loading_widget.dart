import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:in_app_messaging/src/res/app_colors.dart';

class LoadingWidget extends StatelessWidget{
  const LoadingWidget({super.key, this.color = AppColors.amberYellowColor});
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Center(
      child:  CupertinoActivityIndicator(
        color: color,
      )

      /*Platform.isIOS
          ? const CupertinoActivityIndicator(
              color: AppColors.amberYellowColor,
            )
          : const CircularProgressIndicator(
              color: AppColors.amberYellowColor,
            ),*/
    );
  }

}