import 'package:dio/dio.dart';

abstract class RequestStates{}
class RequestInitialState extends RequestStates{}

class SaveSectionsRequestForSUsersLoadingState extends RequestStates{}

class SaveSectionsRequestForSUsersSuccessState extends RequestStates{
  final String msg;
  SaveSectionsRequestForSUsersSuccessState(this.msg);
}

class SaveSectionsRequestForSUsersErrorState extends RequestStates{}










