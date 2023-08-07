import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../layout/main_layout.dart';
import '../../services/phone_confirm_cubit/confirm_cubit.dart';
import '../../services/phone_confirm_cubit/confirm_states.dart';
import '../../shared/components/components.dart';

class ConfirmPhoneScreen extends StatelessWidget {
  TextEditingController textEditingController = TextEditingController();
  String verificationId; //appId
  String confirmCode;
  int RV;
  ConfirmPhoneScreen({required this.verificationId,required this.confirmCode,required this.RV});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ConfirmCubit(),
      child: BlocConsumer<ConfirmCubit, ConfirmStates>(
        listener: (context, state) {
          if (state is ConfirmSuccessState) {
            Fluttertoast.showToast(
              msg: state.registerModel.msg ?? '',
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 5,
              fontSize: 16,
              backgroundColor: Colors.green,
              textColor: Colors.white,
            );
            // ConfirmCubit.get(context).UserLogin(userName: , password: );
            navigateAndFinish(context, MainLayout());
          }
        },
        builder: (context, state) {
          return Scaffold(
              body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(

              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                        child: Image(
                            image:
                                AssetImage('assets/images/confirmPhone.png'))),
                    Text(
                      'تأكيد رقم الهاتف',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20.sp),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Text(
                      'لقد أرسلنا كود تفعيلي  من 6 ارقام على \n رقم الهاتف الخاص بك',
                      style: TextStyle(
                          // fontSize: 15.sp,
                          // fontWeight: FontWeight.w400,
                          // color: HexColor('A2A2A2')),
                          fontSize:15.sp,
                        fontWeight: FontWeight.bold,
                        color:HexColor('A2A2A2'),
                        // height: 20,
                        // backgroundColor: Colors.black;
                        // backgroundColor: Colors.white60,
                      )
                    ),
                    SizedBox(
                      height: 40.h,
                    ),
                    PinCodeTextField(
                      errorTextDirection: TextDirection.ltr,
                      controller: textEditingController,
                      enableActiveFill: true,
                      onChanged: (String value) {},
                      length: 6,
                      appContext: context,
                      pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(5),
                          inactiveColor: HexColor('F2F2F2'),
                          inactiveFillColor: HexColor('F2F2F2'),
                          fieldHeight: 48.h,
                          fieldWidth: 53.w),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    DefaultButton(
                        function: () {
                            PhoneAuthCredential phoneAuthCredential =
                            PhoneAuthProvider.credential(
                                verificationId: verificationId,
                                smsCode: '${textEditingController.text}');

                            ConfirmCubit.get(context).SignInWithPhoneAuthCredential(
                                phoneAuthCredential,
                                    () =>navigateTo(context, MainLayout()),
                                    (error) => Fluttertoast.showToast(
                                  msg: error.message.toString(),
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 5,
                                  fontSize: 16,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                ));


                          ConfirmCubit.get(context).ConfirmNumber(
                              rv: RV,
                              confirmationCode: confirmCode
                          );

                        },
                        text: 'تأكيد رقم الهاتف'),
                  ],
                ),
              ),
            ),
          ));
        },
      ),
    );
  }

  // SignInWithPhoneAuthCredential(context, PhoneAuthCredential phoneAuthCredential) async {
  //   try {
  //     final authCredential =
  //         await FirebaseAuth.instance.signInWithCredential(phoneAuthCredential);
  //     if (authCredential.user != null) navigateTo(context, HomeLayout());
  //   } on FirebaseAuthException catch (e) {
  //     print(e.message);
  //     Fluttertoast.showToast(
  //       msg: e.message.toString(),
  //       toastLength: Toast.LENGTH_LONG,
  //       gravity: ToastGravity.BOTTOM,
  //       timeInSecForIosWeb: 5,
  //       fontSize: 16,
  //       backgroundColor: Colors.red,
  //       textColor: Colors.white,
  //     );
  //   }
  // }
}
//keytool -list -v -keystore "%USERPROFILE%\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android
//keytool -list -v -keystore c:\users\James\.android\debug.keystore -alias androiddebugkey -storepass android -keypass android