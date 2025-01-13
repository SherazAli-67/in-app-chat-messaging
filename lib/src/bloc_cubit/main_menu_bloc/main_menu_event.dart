
part of 'main_menu_bloc.dart';
@immutable
abstract class MainMenuEvent {}

class TabChangeEvent extends MainMenuEvent {
  final int tabIndex;
  TabChangeEvent({required this.tabIndex});
}

class ShowAvatarsEvent extends MainMenuEvent {
  ShowAvatarsEvent();
}

class HideAvatarsEvent extends MainMenuEvent {
  HideAvatarsEvent();
}