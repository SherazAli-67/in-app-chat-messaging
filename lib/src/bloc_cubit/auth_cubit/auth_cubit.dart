import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:in_app_messaging/src/res/app_strings.dart';
import 'package:in_app_messaging/src/user_model.dart';

part 'auth_states.dart';
class AuthCubit extends Cubit<AuthStates>{
  final auth = FirebaseAuth.instance;
  AuthCubit() : super(AuthInitialState());

  Future<void> onSignInWithGoogleTap() async {
    emit(SigningInWithGoogle());
    debugPrint("On Tap:");
    try{

      // if it is web
      if (kIsWeb) {
        GoogleAuthProvider authProvider = GoogleAuthProvider();
        try {
         UserCredential userCredential =  await auth.signInWithPopup(authProvider);

          emit(SignedInWithGoogle(isNewUser: userCredential.additionalUserInfo!.isNewUser));
        } catch (e) {
          String errorMessage = e.toString();
          if(e is PlatformException){
            errorMessage = e.message ?? e.toString();
          }else if (e is FirebaseAuthException) {
            errorMessage = e.message ?? e.toString();
            debugPrint("error while google sign in: ${e.message}");
          }

          emit(SigningInWithGoogleFailed(errorMessage: errorMessage));
        }
      } else {

        const List<String> scopes = <String>[
          'email',
        ];
        GoogleSignIn googleSignIn = GoogleSignIn(scopes: scopes,);
        final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
        if (googleSignInAccount != null) {
          final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

          final AuthCredential credential = GoogleAuthProvider.credential(
            accessToken: googleSignInAuthentication.accessToken,
            idToken: googleSignInAuthentication.idToken,
          );

          try {
            UserCredential? userCredential = await auth.signInWithCredential(credential);
            emit(SignedInWithGoogle(isNewUser: userCredential.additionalUserInfo!.isNewUser));
          } on FirebaseAuthException catch (e) {
            debugPrint("Google sign in error: ${e.toString()}");
            debugPrint("error while google sign in: ${e.message}");
            String errorMessage = e.toString();
            if (e.code == 'account-exists-with-different-credential') {
              errorMessage = 'Account exists with different credentials';
              // ...
            } else if (e.code == 'invalid-credential') {
              errorMessage = 'Invalid Credentials!';
              // ...
            }

            emit(SigningInWithGoogleFailed(errorMessage: errorMessage));
          } catch (e) {
            String errorMessage = e.toString();
            if(e is PlatformException){
              errorMessage = e.message ?? e.toString();
            }
            emit(SigningInWithGoogleFailed(errorMessage: errorMessage));
          }

        }else{
          emit(SigningInWithGoogleFailed(errorMessage: 'Signing up error'));
        }
      }
    }catch(e){
      String errorMessage = e.toString();

      if(e is PlatformException){
        errorMessage = e.message!;
      }

      emit(SigningInWithGoogleFailed(errorMessage: errorMessage));
    }
  }

  Future<void> onCreateProfileTap({required XFile file, required userName, required bio})async{
    emit(CreatingProfile());
    try{
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      String userID = auth.currentUser!.uid;
      String profilePicture = 'https://media.licdn.com/dms/image/v2/D4D03AQF10MKF7Y4G2w/profile-displayphoto-shrink_400_400/B4DZO_EsajGUAg-/0/1734077505137?e=1741824000&v=beta&t=AhJKfl6No8N-D5Q8dDuN_ZEXsxlBUypd_TYmf2HQo6U';
      UserModel user = UserModel(userName: userName, userID: userID, userProfilePicture: profilePicture, bio: bio);
      await firestore.collection(usersCollection).doc(user.userID).set(user.toMap());
      emit(CreatedProfile());
    }catch(e){
      String errorMessage = e.toString();
      if(e is PlatformException){
        errorMessage = e.message!;
      }
      emit(CreatingProfileFailed(errorMessage: errorMessage));
    }
  }
}