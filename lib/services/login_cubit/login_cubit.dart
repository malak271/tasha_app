import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:tasha_app/services/login_cubit/login_states.dart';
import 'package:tasha_app/network/remote/google_helper.dart';
import '../../../models/login_model.dart';
import '../../../network/local/hive.dart';
import '../../../network/remote/dio_helper.dart';
import '../../../shared/components/Constants.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitialState());

  static LoginCubit get(context) => BlocProvider.of(context);

  LoginModel? loginModel;

  void UserLogin({
    required String userName,
    required String password,
  }) {
    emit(LoginLoadingState());
    DioHelper.postData(
        url: 'http://tasha.accessline.ps/api/Token',
        data: {
          'loginSource': 'b',
          'userName': '$userName',
          'password': '$password',
          "email": "string",
          "fcmToken": "string"
        },
        onError: (ApIError) {
          print(ApIError.message);
          emit(LoginErrorState(ApIError.message));
        },
        onSuccess: (Response) async {
          loginModel = LoginModel.fromJson(Response.data);
          token=loginModel!.token;

          print('toooken ${loginModel!.token}');
          await MyHive.openBox(
            name: MyHive.loginModelKey,
          );
          await  MyHive.putValue('UserInfo', loginModel!);

          emit(LoginSuccessState(loginModel!));
        });
  }

  void SocialUserLogin() async {
    emit(LoginLoadingState());
    await GoogleHelper.GoogleLogin();

    print('id token for google : ${GoogleHelper.idToken}');

    DioHelper.getData(
        url: 'http://tasha.accessline.ps/API/ExternalLogin/GoogleLogin/GoogleLogin',
        query: {
          'IdToken': '${GoogleHelper.idToken}',
          'FCMToken': '${await FirebaseMessaging.instance.getToken()}',
        },
        onError: (ApIError) {
          print(ApIError.message);
          emit(LoginErrorState(ApIError.message));
        },
        onSuccess: (response) async {
          print(response.data.toString());

          if(response.data['rv']==1){
            loginModel = LoginModel.fromJson(response.data);
            token=loginModel!.token;

            print('token ${loginModel!.token}');
            await MyHive.openBox(
              name: MyHive.loginModelKey,
            );
            await  MyHive.putValue('UserInfo', loginModel!);

            emit(LoginSuccessState(loginModel!));
          }
          emit(GoogleLoginSuccessState(response.data['rv']));
        });
  }

  void facebookUserLogin() async {
    emit(LoginLoadingState());

    final LoginResult loginResult = await FacebookAuth.instance.login();

    print(loginResult.accessToken!.token);
    print(await FirebaseMessaging.instance.getToken());

    DioHelper.getData(
        url: 'http://tasha.accessline.ps/API/ExternalLogin/FacebookLogin/FacebookLogin',
        query: {
          'accessToken': '${loginResult.accessToken!.token}',
          'FCMToken': '${await FirebaseMessaging.instance.getToken()}',
        },
        onError: (apIError) {
          print(apIError.message);
          emit(LoginErrorState(apIError.message));
        },
        onSuccess: (response) async {

          print(response.data.toString());

          if(response.data['rv']==1){
            loginModel = LoginModel.fromJson(response.data);
            token=loginModel!.token;

            print('toooken ${loginModel!.token}');
            await MyHive.openBox(
              name: MyHive.loginModelKey,
            );
            await  MyHive.putValue('UserInfo', loginModel!);

            emit(LoginSuccessState(loginModel!));
          }
          emit(FacebookLoginSuccessState(response.data['rv']));
        });
  }

}


