


import '../../../models/login_model.dart';

abstract class LoginStates{}
class LoginInitialState extends LoginStates{}

class LoginSuccessState extends LoginStates{
  final LoginModel loginModel;
  LoginSuccessState(this.loginModel);
}

class LoginLoadingState extends LoginStates{}

class LoginErrorState extends LoginStates{
  final String error;
  LoginErrorState(this.error);
}

class FacebookLoginSuccessState extends LoginStates{
  final int rv;
  FacebookLoginSuccessState(this.rv);
}

class GoogleLoginSuccessState extends LoginStates{
  final int rv;
  GoogleLoginSuccessState(this.rv);
}