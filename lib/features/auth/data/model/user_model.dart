import 'package:chat_rooms/core/consts/firebase_keys.dart';

class UserModel {

  String name;
  String email;
  String userID;
  

  UserModel({
    required this.name,
    required this.email,
    required this.userID,
  });

factory UserModel.fromJson(Map<String,dynamic> json) => UserModel(
    name: json[FirebaseKeys.userName],
    email: json[FirebaseKeys.emailField],
    userID: json[FirebaseKeys.userIDField],
  ); 
  Map<String,dynamic> toJson() {
    return {
      FirebaseKeys.userName    : name,
      FirebaseKeys.emailField  : email,
      FirebaseKeys.userIDField : userID,
    };
  }
}
