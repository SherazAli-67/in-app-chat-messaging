
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:in_app_messaging/src/features/chats/select_user_to_chat.dart';
import 'package:in_app_messaging/src/features/main_menu_page/calls_page.dart';
import 'package:in_app_messaging/src/features/main_menu_page/home_page.dart';
import 'package:in_app_messaging/src/res/app_colors.dart';
import 'package:in_app_messaging/src/res/app_icons.dart';
import 'package:in_app_messaging/src/res/app_text_styles.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../bloc_cubit/main_menu_bloc/main_menu_bloc.dart';


class MainMenuPage extends StatefulWidget{
  const MainMenuPage({super.key, this.comingFromNotification = false});
  final bool comingFromNotification;
  @override
  State<MainMenuPage> createState() => _MainMenuPageState();
}

class _MainMenuPageState extends State<MainMenuPage> {
  final List<Widget>  pages = [
    const HomePage(),
    const CallsPage(),
    const SizedBox(),
    const SizedBox()
  ];
  @override
  void initState() {
    super.initState();
  }



  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    final tabChangeBloc = BlocProvider.of<MainMenuTabChangeBloc>(context);
    return BlocConsumer<MainMenuTabChangeBloc, MainMenuState>(
        bloc: tabChangeBloc,
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.white,
            floatingActionButton: FloatingActionButton(
              onPressed: (){
                if(Platform.isIOS){
                  showCupertinoModalBottomSheet(context: context, builder: (_)=> const SelectUserToChat());
                }else{
                  Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=> const SelectUserToChat()));
                }
              },
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(99)),
              backgroundColor: AppColors.amberYellowColor,
              child: const Icon(Icons.add_rounded),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterDocked,
            bottomNavigationBar: Container(
              decoration: const BoxDecoration(
                  boxShadow: [
                    BoxShadow(color: Colors.grey, spreadRadius: 0.5, blurRadius: 1),
                  ]
              ),
              child: BottomNavigationBar(
                backgroundColor: Colors.white,
                type: BottomNavigationBarType.fixed,
                items: [
                  _buildBottomNavigationBarItem(state, icon: AppIcons.icChat, label: 'Messages',  index: 0),
                  _buildBottomNavigationBarItem(state, icon: AppIcons.icCall, label: 'Calls', index: 1,),
                  _buildBottomNavigationBarItem(state, icon: AppIcons.icSearch, label: 'Search',  index: 2),
                  _buildBottomNavigationBarItem(state, icon: AppIcons.icProfile, label: 'Profile', index: 3,),

                ],
                currentIndex: state.tabIndex,
                selectedItemColor: Colors.black,
                unselectedItemColor: AppColors.unSelectedGreyColor,
                selectedLabelStyle: AppTextStyles.smallTextStyle,
                unselectedLabelStyle: AppTextStyles.smallTextStyle,
                onTap: (index) => tabChangeBloc.add(TabChangeEvent(tabIndex: index)),
              ),
            ),
            body: pages.elementAt(state.tabIndex),
          ) ;
        });
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem(MainMenuState state, {required String icon, required String label,  required int index, bool isTennisCourt = false}) {
    return BottomNavigationBarItem(
        icon: SvgPicture.asset(
          icon,
          color: state.tabIndex == index
              ? Colors.black
              : AppColors.unSelectedGreyColor,
        ),
        label: label
    );
  }
}