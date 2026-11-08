import 'package:chat_rooms/features/auth/data/model/user_model.dart';

abstract class AuthStates {}

class AuthInitialState extends AuthStates {}

class LoginLoadingState extends AuthStates {}

class LoginSuccessState extends AuthStates {
  final UserModel userModel;
  LoginSuccessState(this.userModel);
}

class LoginErrorState extends AuthStates {
  final String error;
  LoginErrorState(this.error);
}

class RegisterLoadingState extends AuthStates {}

class RegisterSuccessState extends AuthStates {}

class RegisterErrorState extends AuthStates {
  final String error;
  RegisterErrorState(this.error);
}

class GoogleSignInLoadingState extends AuthStates {}

class GoogleSignInSuccessState extends AuthStates {
  final UserModel userModel;
  GoogleSignInSuccessState(this.userModel);
}

class GoogleSignInErrorState extends AuthStates {
  final String error;
  GoogleSignInErrorState(this.error);
}
