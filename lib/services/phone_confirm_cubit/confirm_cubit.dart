import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasha_app/models/register_model.dart';
import 'package:tasha_app/services/phone_confirm_cubit/confirm_states.dart';
import '../../../../network/remote/dio_helper.dart';

class ConfirmCubit extends Cubit<ConfirmStates> {
  ConfirmCubit() : super(ConfirmInitialState());

  static ConfirmCubit get(context) => BlocProvider.of(context);

  void ConfirmNumber ({
    required int rv,
    required String confirmationCode,
  }) async{
    emit(ConfirmLoadingState());
    DioHelper.putData(
        url: 'http://tasha.accessline.ps/API/BUsers/ConfirmMobile',
        query: {
          "ID": rv,
          "ConfirmationCode":"${confirmationCode.substring(confirmationCode.length-5)}"
        },
        onError: (ApIError) {
          print('jkhfytfy${ApIError.message.toString()}');
          emit(ConfirmErrorState(ApIError.message,ApIError.response));
        },
        onSuccess: (Response) {
          emit(ConfirmSuccessState(RegisterModel.fromJson(Response.data)));
        });
  }

  SignInWithPhoneAuthCredential(PhoneAuthCredential phoneAuthCredential , onSuccess(),onError(error)) async {
    try {
      final authCredential =
      await FirebaseAuth.instance.signInWithCredential(phoneAuthCredential);
      if (authCredential.user != null) onSuccess();
    } on FirebaseAuthException catch (e) {
      onError(e);
    }
  }


  //add mobile
  void addMobileNumber ({
    required int id,
    required String mobileNumber,
  }) async{
    DioHelper.putData(
        url: 'http://tasha.accessline.ps/API/BUsers/AddMobile',
        query: {
          "ID": 181,
          "MobileNumber":mobileNumber
        },
        onError: (apIError) {
          print('add mobile error ${apIError.message.toString()}');
          emit(AddMobileErrorState(apIError.message));
        },
        onSuccess: (response) {
          print(response.data.toString());
          ////{"rv":185,"msg":"تم الحفظ بنجاح","data":[{"FCMToken":null,"MsgTxt":"كود التفعيل الخاص بك هو 28705"}]}
          /*
          {rv: 181, msg: تم الحفظ بنجاح,
           data: [{FCMToken: ebBVht6vTgiBaZ8KVRWpki:APA91bG6BPXQM6AzjNi-ULs
           wPIWwBRTsIxbCeNjD3RvDzRBxdRC3KjF6MZHWmuJpKZVgPnz2FOnTNZwG-3fp1hRw8NhyGS
           Voq-kXFyGWJMswKoA_RKtmbv64Mrq9u70t4vYVweKcGclv,
           MsgTxt: كود التفعيل الخاص بك هو 19721}]}
          * */
          emit(AddMobileSuccessState(response.data['rv'],response.data['data'][0]['MsgTxt']));
        });
  }

  sendSMS(codeSent(verificationId),phoneController) async{
    emit(SendSMSLoadingState());
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+970595765299',
        verificationCompleted: (phoneAuthCredential) async {},
        verificationFailed: (verificationFailed) async {
          print('verificationFailed${verificationFailed.message}');
          emit(SendSMSErrorState());
        },
        codeSent: (verificationId, resendingToken) async {
          codeSent(verificationId);
          print('codeSent $verificationId');
          emit(SendSMSSuccessState());
        },
        codeAutoRetrievalTimeout: (verificationId) async {
          print('codeAutoRetrievalTimeout');
        });
  }

}
