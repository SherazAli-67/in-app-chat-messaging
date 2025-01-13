part of 'auth_cubit.dart';

abstract class AuthStates {}

class AuthInitialState extends AuthStates{}

class SigningInWithGoogle extends AuthStates {}
class SignedInWithGoogle extends AuthStates {
  final bool isNewUser;
  SignedInWithGoogle({required this.isNewUser});
}
class SigningInWithGoogleFailed extends AuthStates {
  final String errorMessage;

  SigningInWithGoogleFailed({required this.errorMessage});
}

class CreatingProfile extends AuthStates{}
class CreatedProfile extends AuthStates{}
class CreatingProfileFailed extends AuthStates{
  final String errorMessage;
  CreatingProfileFailed({required this.errorMessage});
}