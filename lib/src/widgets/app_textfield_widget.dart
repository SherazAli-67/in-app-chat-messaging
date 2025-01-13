import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:in_app_messaging/src/res/app_colors.dart';
import 'package:in_app_messaging/src/res/app_text_styles.dart';

class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    required TextEditingController textController,
    required String prefixIcon,
    required String hintText,
    required String titleText,
    this.isPassword = false,
    this.isReadOnly = false
  }) : _textController = textController, _prefixIcon = prefixIcon, _hintText = hintText, _titleText = titleText;

  final TextEditingController _textController;
  final String _prefixIcon;
  final String _hintText;
  final String _titleText;
  final bool isPassword;
  final bool isReadOnly;
  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool hidePassword = true;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget._titleText),
        const SizedBox(height: 8,),
        TextField(

          controller: widget._textController,
          style: AppTextStyles.mediumTextStyle.copyWith(color: Colors.white),
          readOnly: widget.isReadOnly,
          obscureText: widget.isPassword && hidePassword,
          cursorColor: Colors.grey,
          decoration: InputDecoration(
            hintText: widget._hintText,
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(99), borderSide: const BorderSide(color: AppColors.unSelectedGreyColor)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(99), borderSide: const BorderSide(color: AppColors.unSelectedGreyColor)),

            prefixIconConstraints: const BoxConstraints(minWidth: 40, minHeight: 20),
            prefixIcon: SvgPicture.asset(widget._prefixIcon, colorFilter: const ColorFilter.mode(AppColors.unSelectedGreyColor, BlendMode.srcIn),),
            suffixIcon: widget.isPassword ? IconButton(onPressed: ()=> setState(() => hidePassword = !hidePassword), icon: hidePassword ? const Icon(Icons.visibility) : const Icon(Icons.visibility_off)) : null,
          ),
        ),
      ],
    );
  }
}