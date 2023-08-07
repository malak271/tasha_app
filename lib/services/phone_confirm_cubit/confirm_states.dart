


import 'package:dio/dio.dart';
import 'package:tasha_app/models/register_model.dart';

import '../../../models/login_model.dart';

abstract class ConfirmStates{}

class ConfirmInitialState extends ConfirmStates{}
class ConfirmLoadingState extends ConfirmStates{}
class ConfirmSuccessState extends ConfirmStates{
  final RegisterModel registerModel;
  ConfirmSuccessState(this.registerModel);
}
class ConfirmErrorState extends ConfirmStates{
  final String error;
  final Response? response;
  ConfirmErrorState(this.error,this.response);
}

class LoginSuccessState extends ConfirmStates{
  final LoginModel loginModel;
  LoginSuccessState(this.loginModel);
}

class LoginloadingState extends ConfirmStates{}

class LoginErrorState extends ConfirmStates{
  final String error;
  LoginErrorState(this.error);
}
class AddMobileSuccessState extends ConfirmStates{
  final String confirmationCode;
  final int rv;
  AddMobileSuccessState(this.rv,this.confirmationCode);
//{"rv":185,"msg":"تم الحفظ بنجاح","data":[{"FCMToken":null,"MsgTxt":"كود التفعيل الخاص بك هو 28705"}]}
}

class AddMobileLoadingState extends ConfirmStates{}

class AddMobileErrorState extends ConfirmStates{
  final String error;
  AddMobileErrorState(this.error);
}

class SendSMSLoadingState extends ConfirmStates{}

class SendSMSSuccessState extends ConfirmStates{}

class SendSMSErrorState extends ConfirmStates{}


