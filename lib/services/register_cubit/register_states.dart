import 'package:dio/dio.dart';
import 'package:tasha_app/models/register_model.dart';

abstract class RegisterStates{}
class RegisterInitialState extends RegisterStates{}
class RegisterSuccessState extends RegisterStates{
  final RegisterModel registerModel;
  RegisterSuccessState(this.registerModel);
}
class RegisterloadingState extends RegisterStates{}
class RegisterErrorState extends RegisterStates{
  final String error;
  final Response response;
  RegisterErrorState(this.error,this.response);
}

class RegisterChangePasswordVisibilityState extends RegisterStates{}

class RegisterCheckBoxState extends RegisterStates{}

class SendSMSLoadingState extends RegisterStates{}

class SendSMSSuccessState extends RegisterStates{}

class SendSMSErrorState extends RegisterStates{ //state 2
  final error;
  SendSMSErrorState(this.error);
}

class GenderRadioButtonState extends RegisterStates{}

class SelectAddressState extends RegisterStates{}








