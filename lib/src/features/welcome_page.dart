import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:in_app_messaging/src/bloc_cubit/auth_cubit/auth_cubit.dart';
import 'package:in_app_messaging/src/features/create_profile_page.dart';
import 'package:in_app_messaging/src/features/main_menu_page/main_menu_page.dart';
import 'package:in_app_messaging/src/res/app_icons.dart';
import 'package:in_app_messaging/src/res/app_text_styles.dart';
import 'package:in_app_messaging/src/widgets/loading_widget.dart';

class WelcomePage extends StatelessWidget{
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authCubit = BlocProvider.of<AuthCubit>(context);
    return Scaffold(

      body: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
              width: double.infinity,
              child: Image.asset(AppIcons.chatBgWallPaper, fit: BoxFit.cover,)),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: SvgPicture.asset(AppIcons.icOnboarding)),
                  const Expanded(child: Column(
                    children: [

                      SizedBox(height: 20,),
                      Text("Stay connected with your friends and family", style: AppTextStyles.largeTextStyle,),
                      SizedBox(height: 20,),

                      Row(
                        children: [
                          Icon(Icons.verified_user, color: Colors.greenAccent,),
                          SizedBox(width: 10,),
                          Text("Secure, private messaging", style: AppTextStyles.subHeadingTextStyle,)
                        ],
                      ),
                    ],
                  )),


                  BlocConsumer<AuthCubit,AuthStates>(
                    listener: (_, state){
                      if(state is SignedInWithGoogle){
                        if(state.isNewUser){
                          //Create profile page
                          Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=> const CreateProfilePage()));
                        }else {
                          Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=> const MainMenuPage()));
                        }
                      }else if(state is SigningInWithGoogleFailed){
                        //Show error snack bar
                      }
                    },
                    builder: (_, state) {
                      return SizedBox(
                        height: 55,
                        width: double.infinity,
                        child: ElevatedButton(

                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(99)
                              )
                            ),
                            onPressed: ()=> authCubit.onSignInWithGoogleTap(), child: state is SigningInWithGoogle ? const LoadingWidget() : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(AppIcons.icGoogle),
                                const SizedBox(width: 5,),
                                Text("Continue with Google", style: AppTextStyles.btnTextStyle.copyWith(color: Colors.black),),
                              ],
                            )),
                      );
                    }
                  )
                ],
              ),
            ),
          )
        ],
      )
    );
  }

}