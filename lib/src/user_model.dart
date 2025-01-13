class UserModel {
  final String userName;
  final String userID;
  final String userProfilePicture;
  final String bio;

  UserModel({
    required this.userName,
    required this.userID,
    required this.userProfilePicture,
    required this.bio,
  });

  // Convert UserModel to Map
  Map<String, dynamic> toMap() {
    return {
      'userName': userName,
      'userID': userID,
      'userProfilePicture': userProfilePicture,
      'bio': bio,
    };
  }

  // Create UserModel from Map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userName: map['userName'] ?? '',
      userID: map['userID'] ?? '',
      userProfilePicture: map['userProfilePicture'] ?? '',
      bio: map['bio'] ?? '',
    );
  }
}