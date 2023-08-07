import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasha_app/models/register_model.dart';
import 'package:tasha_app/services/register_cubit/register_states.dart';
import '../../../../network/remote/dio_helper.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(RegisterInitialState());

  static RegisterCubit get(context) => BlocProvider.of(context);

  RegisterModel? registerModel ;

  void UserRegister ({
    required String firstName,
    required String lastName,
    required String address,
    required String phone,
    required String userName,
    required String gender,
    required String dateOfBirth,
    required String password,
    required String idno,
    required int addressId,
  }) async{

    String? fcmtoken = await FirebaseMessaging.instance.getToken();
    print('fcm token: $fcmtoken');

    emit(RegisterloadingState());
    DioHelper.postData(
        url: 'http://tasha.accessline.ps/API/BUsers/BUsersSave',
        data: FormData.fromMap({
          'AddressDetails':'$address',
          'AddressID':'$addressId',
          'BirthDate':'$dateOfBirth',
          'BUserName':'$userName',
          'FirstName':'$firstName',
          'Gender':'$gender',
          'IDNO':'$idno',
          'LastName':'$lastName',
          'MobileNumber':'$phone',
          'Password':'$password',
          'FCMToken':'$fcmtoken'
        }),
        onError: (ApIError) {
          registerModel = RegisterModel.fromJson(ApIError.response!.data);
          print(ApIError.message.toString());
          emit(RegisterErrorState(ApIError.message,ApIError.response!));
        },
        onSuccess: (Response) {
          registerModel = RegisterModel.fromJson(Response.data);
          emit(RegisterSuccessState(RegisterModel.fromJson(Response.data)));
        });
  }

  bool value=false;
  changeCheckBox(currentValue){
    value=currentValue;
    emit(RegisterCheckBoxState());
  }


  sendSMS(codeSent(verificationId),phoneController) async{
    emit(SendSMSLoadingState());
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+972${phoneController.text}',
        verificationCompleted: (phoneAuthCredential) async {},
        verificationFailed: (verificationFailed) async {
          print(verificationFailed.message);
          emit(SendSMSErrorState(verificationFailed.message));//send error
        },
        codeSent: (verificationId, resendingToken) async {
          print(verificationId);
          codeSent(verificationId);
          emit(SendSMSSuccessState());
        },
        codeAutoRetrievalTimeout: (verificationId) async {});
  }

  int selectedGender =0;
  changeGender(currentValue){
    selectedGender=currentValue;
    emit(GenderRadioButtonState());
  }




}
