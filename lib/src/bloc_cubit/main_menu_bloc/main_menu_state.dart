part of 'main_menu_bloc.dart';
@immutable
abstract class MainMenuState{
  final int tabIndex;
  const MainMenuState({required this.tabIndex});
}


class MainMenuInitial extends MainMenuState {
  const MainMenuInitial({required super.tabIndex});
}
