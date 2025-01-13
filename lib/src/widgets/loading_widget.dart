import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:in_app_messaging/src/res/app_colors.dart';

class LoadingWidget extends StatelessWidget{
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Platform.isIOS ? const CupertinoActivityIndicator(color: AppColors.amberYellowColor,) : const CircularProgressIndicator(color: AppColors.amberYellowColor,),);
  }

}