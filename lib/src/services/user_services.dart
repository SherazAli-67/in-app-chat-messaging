import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:in_app_messaging/src/res/app_strings.dart';
import 'package:in_app_messaging/src/user_model.dart';

class UserService{
  static Future<String?> uploadProfile(XFile xFile) async{
    try{
      File file = File(xFile.path);
      String uid =  FirebaseAuth.instance.currentUser!.uid;
      TaskSnapshot task = await FirebaseStorage.instance.ref('users/profilePictures$uid').putFile(file);
      return await task.ref.getDownloadURL();
    }catch(e){
      debugPrint("Exception while uploading:${e.toString()}");
    }

    return null;
  }

  static Stream<DocumentSnapshot<Map<String, dynamic>>> get currentUserStream {
    String uID = FirebaseAuth.instance.currentUser!.uid;
   return FirebaseFirestore.instance
        .collection(usersCollection)
        .doc(uID)
        .snapshots();
  }

  static Stream<List<UserModel>> get allUsers {
    return FirebaseFirestore.instance
        .collection(usersCollection)
        .snapshots().map((snapshot)=> snapshot.docs.map((doc)=> UserModel.fromMap(doc.data())).toList());
  }

  static Future<UserModel?> getCurrentUser()async{
    String uID = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot docSnap = await  FirebaseFirestore.instance.collection(usersCollection).doc(uID).get();
    if(docSnap.exists){
      return UserModel.fromMap(docSnap.data() as Map<String, dynamic>);
    }

    return null;
  }
}