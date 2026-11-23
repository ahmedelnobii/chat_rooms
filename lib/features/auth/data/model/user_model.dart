import 'package:chat_rooms/core/consts/firebase_keys.dart';

class UserModel {
  String name;
  String email;
  String userID;

  UserModel({required this.name, required this.email, required this.userID});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final name = json[FirebaseKeys.userName];
    final email = json[FirebaseKeys.emailField];
    final userID = json[FirebaseKeys.userIDField];
    if (name is! String || email is! String) {
      throw StateError('Profile document contains invalid user data.');
    }
    return UserModel(
      name: name,
      email: email,
      userID: userID is String ? userID : '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      FirebaseKeys.userName: name,
      FirebaseKeys.emailField: email,
      FirebaseKeys.userIDField: userID,
    };
  }
}
