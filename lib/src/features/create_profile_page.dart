import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:in_app_messaging/src/bloc_cubit/auth_cubit/auth_cubit.dart';
import 'package:in_app_messaging/src/features/main_menu_page/main_menu_page.dart';
import 'package:in_app_messaging/src/res/app_colors.dart';
import 'package:in_app_messaging/src/res/app_icons.dart';
import 'package:in_app_messaging/src/widgets/app_textfield_widget.dart';
import 'package:in_app_messaging/src/widgets/loading_widget.dart';

import '../res/app_text_styles.dart';

class CreateProfilePage extends StatefulWidget{
  const CreateProfilePage({super.key});

  @override
  State<CreateProfilePage> createState() => _CreateProfilePageState();
}

class _CreateProfilePageState extends State<CreateProfilePage> {
  XFile? selectedImage;

  late TextEditingController _nameController;
  late TextEditingController _bioTextController;
  
  @override
  void initState() {
    _nameController = TextEditingController();
    _bioTextController = TextEditingController();
    super.initState();
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    _bioTextController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Expanded(child: Column(

                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: SizedBox(
                      height: 120,
                      child: GestureDetector(
                        onTap: _onPickImage,
                        child: Stack(
                          alignment: Alignment.topCenter,
                          children: [
                            selectedImage == null ? CircleAvatar(
                              radius: 55,
                              backgroundColor: AppColors.amberYellowColor.withOpacity(0.1),
                            ) : CircleAvatar(
                              radius: 55,
                              backgroundColor: AppColors.amberYellowColor.withOpacity(0.1),
                              backgroundImage: FileImage(File(selectedImage!.path)),
                            ),
                            Positioned(
                                bottom: 10,
                                right: 10,
                                child: CircleAvatar(
                                    radius: 15,
                                    backgroundColor: AppColors.amberYellowColor,
                                    child: IconButton(onPressed: (){}, icon: SvgPicture.asset(AppIcons.icEdit))))
                          ],
                        ),
                      ),
                    ),
                  ),
                  AppTextField(textController: _nameController, prefixIcon: AppIcons.icEmail, hintText: 'i.e John Doe', titleText: 'Name'),
                  const SizedBox(height: 20,),
                  AppTextField(textController: _bioTextController, prefixIcon: AppIcons.icUser, hintText: 'ie.About yourself', titleText: 'Bio'),

                ],
              )),
              BlocConsumer<AuthCubit, AuthStates>(
                listener: (_, state){
                  if(state is CreatedProfile){
                    Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=> const MainMenuPage()));
                  }
                },
                builder: (_,state) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 40),
                    height: 55,
                    width: double.infinity,
                    child: ElevatedButton(

                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(99)
                            )
                        ),
                        onPressed: _onCreateProfile, child: state is CreatingProfile ? const LoadingWidget() :  Text("Continue", style: AppTextStyles.btnTextStyle.copyWith(color: Colors.black),)),
                  );
                }
              )
            ],
          ),
        ),
      ),
    );
  }


  void _onPickImage()async{
    ImagePicker imagePicker = ImagePicker();
    XFile? file =  await imagePicker.pickImage(source: ImageSource.gallery);
    if(file != null){
      selectedImage = file;
      setState(() {});
    }
  }

  void _onCreateProfile(){
    String userName = _nameController.text.trim();
    String bio = _bioTextController.text.trim();

    context.read<AuthCubit>().onCreateProfileTap(file: selectedImage!, userName: userName, bio: bio);
  }
}