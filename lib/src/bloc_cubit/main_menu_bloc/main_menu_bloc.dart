import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
part 'main_menu_event.dart';
part 'main_menu_state.dart';
class MainMenuTabChangeBloc extends Bloc<MainMenuEvent, MainMenuState> {
  MainMenuTabChangeBloc() : super(const MainMenuInitial(tabIndex: 0)) {
    on<TabChangeEvent>((event, emit) {
      emit(MainMenuInitial(tabIndex: event.tabIndex));
    });
  }
}