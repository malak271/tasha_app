import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart'  hide TextDirection;
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:tasha_app/services/cubit/app_cubit.dart';
import 'package:tasha_app/models/register_model.dart';
import 'package:tasha_app/styles/theme.dart';
import '../../../shared/components/components.dart';
import '../../services/register_cubit/register_cubit.dart';
import '../../services/register_cubit/register_states.dart';
import '../../shared/components/Constants.dart';
import 'login_screen.dart';
import 'confirm_phone_screen.dart';


class LoginRegisterScreen extends StatelessWidget {

  var formKey = GlobalKey<FormState>();
  var firstNameController = TextEditingController();
  var lastNameController = TextEditingController();
  var addressController = TextEditingController();
  var phoneController = TextEditingController();
  var userNameController = TextEditingController();
  var genderController = TextEditingController();
  var dateOfBirthController = TextEditingController();
  var passwordController = TextEditingController();
  var idnoController = TextEditingController();
  String confirmCode='';

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (BuildContext context) => RegisterCubit(),),
        BlocProvider(create: (BuildContext context) => AppCubit(),)
      ],
      child: BlocConsumer<RegisterCubit, RegisterStates>(
          listener: (context, state) async {
        if (state is RegisterSuccessState) {
          confirmCode=state.registerModel.data![0].msgTxt.toString();
          RegisterCubit.get(context).sendSMS((verificationId) =>
              navigateAndFinish(context,
                  ConfirmPhoneScreen(
                    verificationId: verificationId,
                    confirmCode:confirmCode,
                    RV:state.registerModel.rv??-1 ,))
          , phoneController);
        } else if (state is RegisterErrorState) {
          RegisterModel registerModel =
              RegisterModel.fromJson(state.response.data);
          Fluttertoast.showToast(
            msg: registerModel.msg ?? '',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 5,
            fontSize: 16,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
        }

      }, builder: (context, state) {
        var cubit=AppCubit.getCubit(context);
        return Scaffold(
          appBar: AppBar(),
          body: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'مستخدم جديد',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'قم بتسجيل الدخول كمستخدم جديد',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          ?.copyWith(color: MyColor.getColor()),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Container(
                          width: 165,
                          child: DefaultTextFormField(
                            controller: firstNameController,
                            type: TextInputType.text,
                            validator: (String? value) {
                              if ((value ?? '').isEmpty) {
                                return 'name must not be empty';
                              }
                            },
                            text: 'الاسم الأول',
                          ),
                        ),
                        Spacer(),
                        Container(
                          width: 165,
                          child: DefaultTextFormField(
                            controller: lastNameController,
                            type: TextInputType.text,
                            validator: (String? value) {
                              if ((value ?? '').isEmpty) {
                                return 'name must not be empty';
                              }
                            },
                            text: 'الاسم الثاني',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    DropdownButton<String>(
                      value: cubit.dropdownvalue,
                      icon: const Icon(Icons.keyboard_arrow_down),

                      items: countries
                          .map((key , value) {
                        return MapEntry(
                            key,
                            DropdownMenuItem<String>(
                              value: key,
                              child: Text(key),
                            ));
                      })
                          .values
                          .toList(),

                      onChanged: (String? newValue) {
                        cubit.selectAddress(newValue);
                      },
                    ),
                    DefaultTextFormField(
                      controller: addressController,
                      type: TextInputType.text,
                      validator: (String? value) {
                        if ((value ?? '').isEmpty) {
                          return 'address must not be empty';
                        }
                      },
                      text: 'تفاصيل العنوان',
                    ),
                    SizedBox(
                      height: 20,
                    ),
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
                    SizedBox(
                      height: 20,
                    ),
                    DefaultTextFormField(
                      controller: userNameController,
                      type: TextInputType.text,
                      validator: (String? value) {
                        if ((value ?? '').isEmpty) {
                          return 'user name must not be empty';
                        }
                      },
                      text: 'اسم المستخدم',
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    DefaultTextFormField(
                      controller: idnoController,
                      type: TextInputType.text,
                      validator: (String? value) {
                        if ((value ?? '').isEmpty) {
                          return 'IDNO must not be empty';
                        }
                      },
                      text: 'رقم الهوية',
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                     color: HexColor('F9F9F9'),
                     padding: EdgeInsets.only(right: 5),
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Text(
                           'الجنس',
                           style: TextStyle(
                               color: HexColor('AAADB5'),  fontSize: 18),
                         ),
                         RadioListTile<int>(
                             title: Text('ذكر'),
                             value: 0,
                             tileColor: HexColor('AAADB5'),
                             groupValue: RegisterCubit.get(context).selectedGender,
                             onChanged: (int? value) {
                               if (value != null) {
                                 print(value);
                                 RegisterCubit.get(context).changeGender(value);
                               }
                             }),
                         RadioListTile<int>(
                           tileColor: HexColor('AAADB5'),
                             title: Text('أنثى'),
                             value: 1,
                             groupValue: RegisterCubit.get(context).selectedGender,
                             onChanged: (int? value) {
                               if (value != null) {
                                 print(value);
                                 RegisterCubit.get(context).changeGender(value);
                               }
                             }),
                       ],
                     ),
                   ),
                    SizedBox(
                      height: 20,
                    ),
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: DefaultTextFormField(
                        controller: dateOfBirthController,
                        type: TextInputType.datetime,
                        validator: (String? value) {
                          if ((value ?? '').isEmpty) {
                            return 'date must not be empty';
                          }
                        },
                        text: 'birth date',
                        onTap:(){
                          showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.parse('1900-01-01'),
                              lastDate: DateTime.now())
                              .then((value){
                            final DateFormat formatter = DateFormat('yyyy-MM-dd');
                            dateOfBirthController.text = formatter.format(value!);
                          });
                        }
                      ),

                    ),
                    SizedBox(
                      height: 20,
                    ),
                    DefaultTextFormField(
                      controller: passwordController,
                      type: TextInputType.visiblePassword,
                      validator: (String? value) {
                        if ((value ?? '').isEmpty) {
                          return 'password must not be empty';
                        }
                      },
                      text: 'كلمة المرور',
                      isPassword: true,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: RegisterCubit.get(context).value,
                          onChanged: (currentValue) {
                            RegisterCubit.get(context)
                                .changeCheckBox(currentValue);
                          },
                          activeColor: HexColor('FFC010'),
                        ),
                        Text('الموافقة على'),
                        TextButton(
                            onPressed: () {}, child: Text('شروط الخصوصية')),
                      ],
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    ConditionalBuilder(
                        condition: state is! RegisterloadingState && state is! SendSMSLoadingState,
                        builder: (context) => DefaultButton(
                              function: () {
                                print(countries[cubit.dropdownvalue]);
                                if (formKey.currentState!.validate() &&
                                    RegisterCubit.get(context).value == true) {
                                  RegisterCubit.get(context).UserRegister(
                                      firstName: firstNameController.text,
                                      lastName: lastNameController.text,
                                      address: addressController.text,
                                      phone: phoneController.text,
                                      userName: userNameController.text,
                                      gender: '${RegisterCubit.get(context).selectedGender}',
                                      dateOfBirth: dateOfBirthController.text,
                                      password: passwordController.text,
                                      idno: idnoController.text,
                                      addressId: countries[cubit.dropdownvalue]??1);
                                }
                                else if(RegisterCubit.get(context).value == false){
                                  Fluttertoast.showToast(
                                    msg: 'يرجى الموافقة على شروط الخصوصية للمتابعة',
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 5,
                                    fontSize: 16,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                  );
                                }
                              },
                              text: 'تسجيل',
                            ),
                        fallback: (context) =>
                            Center(child: CircularProgressIndicator())),
                    SizedBox(
                      height: 20.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('لدي حساب!'),
                        TextButton(
                            onPressed: () {
                              navigateTo(context, LoginScreen());
                            },
                            child: Text('تسجيل الدخول')),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

}

// ListView.separated(
// physics: BouncingScrollPhysics(),
// itemBuilder:(context,index)=> DefaultTextFormField(),
// separatorBuilder:  (context,index)=>Container(
// width: double.infinity,
// height: 1,
// color: Colors.grey,
// ),
// itemCount: list.length)
