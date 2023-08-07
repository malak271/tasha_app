import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:tasha_app/layout/main_layout.dart';
import 'package:tasha_app/screens/register_screen.dart';
import 'package:tasha_app/services/login_cubit/login_cubit.dart';
import 'package:tasha_app/services/login_cubit/login_states.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:tasha_app/services/phone_confirm_cubit/confirm_cubit.dart';
import 'package:tasha_app/services/phone_confirm_cubit/confirm_states.dart' hide LoginSuccessState;
import 'package:tasha_app/services/register_cubit/register_cubit.dart';
import '../../../shared/components/components.dart';
import '../../shared/components/Constants.dart';
import 'confirm_phone_screen.dart';

class LoginScreen extends StatelessWidget {
  var userNameController = TextEditingController();
  var passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (BuildContext context)=> LoginCubit(),),
      ],
      child: BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, state) {
          if (state is LoginSuccessState) {
            if (state.loginModel.token != null) {
              //try save data here rather in cubit user login
              navigateAndFinish(context, MainLayout());
            } else {
              Fluttertoast.showToast(
                msg: 'Try again!',
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                fontSize: 16,
                backgroundColor: Colors.red,
                textColor: Colors.white,
              );
              userNameController.text = '';
              passwordController.text = '';
            }
          }
          if(state is FacebookLoginSuccessState){
            if(state.rv==1){
              navigateAndFinish(context, MainLayout());
            }
            else
            navigateTo(context, AddMobileScreen(state.rv));
          }
          if(state is GoogleLoginSuccessState){
            if(state.rv==1){
              navigateAndFinish(context, MainLayout());
            }
            else
              navigateTo(context, AddMobileScreen(state.rv));
          }
          // if(state is SelectAddressSuccessState){
          //
          // }
        },
        builder: (context, state) {
          // if(state is SelectAddressLoadingState){
          //   print('hi');
          //   return Scaffold(body: Center(child: CircularProgressIndicator(),),);
          // }
          return Scaffold(
              body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Mylogo(),
                      SizedBox(
                        height: 30.h,
                      ),
                      Text(
                        'تسجيل الدخول',
                        style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: HexColor('1E2432')),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      DefaultTextFormField(
                        controller: userNameController,
                        type: TextInputType.emailAddress,
                        validator: (String? value) {
                          if ((value ?? '').isEmpty) {
                            return 'username must not be empty';
                          }
                        },
                        text: 'اسم المستخدم',
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      DefaultTextFormField(
                        controller: passwordController,
                        type: TextInputType.text,
                        isPassword: true,
                        validator: (String? value) {
                          if ((value ?? '').isEmpty) {
                            return 'password must not be empty';
                          }
                        },
                        text: 'كلمة المرور',
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: TextButton(
                            onPressed: () {},
                            child: Text(
                              'هل نسيت كلمة المرور ؟',
                              style: TextStyle(
                                color: HexColor('AAADB5'),
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w300,
                              ),
                            )),
                      ),
                      SizedBox(height: 5.h),
                      ConditionalBuilder(
                          condition: state is! LoginLoadingState,
                          builder: (context) => DefaultButton(
                              function: () {
                                 if (formKey.currentState!.validate()) {
                                        LoginCubit.get(context).UserLogin(
                                            userName: userNameController.text,
                                            password: passwordController.text);
                                 }
                              },
                              text: 'دخول'),
                          fallback: (context) =>
                              Center(child: CircularProgressIndicator())),
                      SizedBox(
                        height: 10.h,
                      ),
                      DefaultButton(
                          function: () {},
                          text: 'الدخول كزائر',
                          backGroundColor: Colors.white,
                          fontColor: HexColor('6259A8')),

                      SizedBox(
                        height: 20.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Socialbutton(
                            image: 'assets/images/fb.png',
                            function: () async{
                              LoginCubit.get(context).facebookUserLogin();
                            }
                          ),
                          // TextButton(onPressed: () async{
                          //   await GoogleHelper.GoogleLogout(context);
                          // }, child: Text('logout')),
                          SizedBox(
                            width: 5.w,
                          ),
                          Socialbutton(
                              image: 'assets/images/gmail.png',
                              function: ()async{
                                LoginCubit.get(context).SocialUserLogin();
                              }
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('ليس لديك حساب ؟'),
                          TextButton(
                              onPressed: () {
                                // CountriesCubit.get(context).getAddresses();
                                navigateTo(context, LoginRegisterScreen());
                              }, child: Text('انشاء حساب ')),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ));
        },
      ),
    );
  }

  Widget Socialbutton({
    required Function function,
    required String image,
  }) =>
      TextButton(
        onPressed: () {
          function();
        },
        child: Container(
          width: 45.w,
          height: 45.h,
          decoration: DECORATION,
          child: Image(
              image: AssetImage(image)
          ),
        ),
      );
}

class AddMobileScreen extends StatelessWidget {
  var phoneController = TextEditingController();

  int rv;
  AddMobileScreen(this.rv);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('إضافة رقم الهاتف'),
      ),
      body: BlocProvider(
        create: (BuildContext context)=>ConfirmCubit(),
        child: BlocConsumer<ConfirmCubit,ConfirmStates>(
          listener: (context,state){
            if(state is AddMobileSuccessState){
              print('my phone ...');
              print(phoneController.text);
              ConfirmCubit.get(context).sendSMS((verificationId) =>
                  navigateAndFinish(context, ConfirmPhoneScreen(verificationId: verificationId,confirmCode:state.confirmationCode,RV:state.rv,))
                  , phoneController);
            }
          },
          builder: (context,state)=>Column(
            children: [
              IntlPhoneField(
                dropdownIconPosition: IconPosition.trailing,
                textAlign: TextAlign.right,
                disableLengthCheck: true,
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: inputDecoration,
                initialCountryCode: 'PS',
                onChanged: (phone) {
                  print(phone.completeNumber);
                },
                validator: (value) {
                  if (value == '') {
                    return 'phone must not be empty';
                  } else if (value?.number.length != 9)
                    return 'رقم الهاتف المدخل غير صحيح';
                },
              ),
              SizedBox(height: 10,),
              TextButton(onPressed: (){
                 ConfirmCubit.get(context).addMobileNumber(id: rv, mobileNumber: phoneController.text);
              }, child: Text('إرسال الرمز'))
            ],
          ),
        ),
      ),
    );
  }
}
