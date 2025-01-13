import 'package:flutter/material.dart';
import 'package:in_app_messaging/src/res/app_colors.dart';
import 'package:in_app_messaging/src/res/app_text_styles.dart';

class WriteMessageTextField extends StatelessWidget {
  const WriteMessageTextField({
    super.key,
    required TextEditingController messageController,
    required FocusNode focusNode,
    bool isImageMessage = false,
  }) : _messageController = messageController, _focusNode = focusNode, _isImageMessage = isImageMessage;

  final TextEditingController _messageController;
  final FocusNode _focusNode;
  final bool _isImageMessage;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _messageController,
      focusNode: _focusNode,
      keyboardType: TextInputType.text,
      maxLines: null,
      cursorColor: _isImageMessage ? Colors.white : null,
      style: _isImageMessage ? AppTextStyles.mediumTextStyle.copyWith(color: Colors.white) : AppTextStyles.mediumTextStyle,
      // cursorColor: primaryColor,
      onTapOutside: (val) => FocusManager.instance.primaryFocus!.unfocus(),
      decoration: InputDecoration(
          hintText: 'Type Message',
          hintStyle: _isImageMessage ? AppTextStyles.mediumTextStyle.copyWith(color: Colors.white) : AppTextStyles.mediumTextStyle,
          // contentPadding:const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          enabledBorder: OutlineInputBorder(
              borderSide:  const BorderSide(color: Colors.grey) ,
              borderRadius: BorderRadius.circular(99)
          ),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: AppColors.dividerDarkColor),
              borderRadius: BorderRadius.circular(99)
          ),
        prefixIcon: const CircleAvatar(
          backgroundColor: AppColors.amberYellowColor,
          child: Icon(Icons.add_rounded),
        ),
        prefixIconConstraints: const BoxConstraints(
          maxHeight: 30,
        )
      ),
    );
  }
}