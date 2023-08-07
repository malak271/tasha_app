import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:tasha_app/services/edit_profile_cubit/location_cubit.dart';
import 'package:tasha_app/services/edit_profile_cubit/location_states.dart';
import '../models/login_model.dart';
import '../network/local/hive.dart';
import '../shared/components/Constants.dart';
import '../shared/components/components.dart';

class EditProfileScreen extends StatelessWidget {

  var firstNameController = TextEditingController();
  var lastNameController = TextEditingController();
  var addressController = TextEditingController();
  var phoneController=TextEditingController();
  var dateOfBirthController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    LoginModel model = MyHive.getValue('UserInfo');
    firstNameController.text=model.userVM?.firstName??'';
    lastNameController.text=model.userVM?.lastName??'';
    addressController.text=model.userVM?.addressDetails??'';
    phoneController.text=model.userVM?.mobileNumber??'';
    dateOfBirthController.text=DateFormat.yMMMd().format(DateTime.parse(model.userVM!.birthDate!));

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: Icon(Icons.arrow_back),
        title: Text('تعديل الملف الشخصي',style: TextStyle(color: Colors.black),),
      ),
      body: BlocProvider(
        create: (BuildContext context) => EditProfileCubit(),
        child: SingleChildScrollView(
          child: BlocConsumer<EditProfileCubit,EditProfileStates>(
            listener: (context,state){
              if(state is EditProfileSuccessState)
                print('edit profile success');
            },
            builder: (context,state){
              return Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
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
                              text:'الاسم الأول',
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
                      SizedBox(height: 20,),
                      DefaultButton(function: (){
                        EditProfileCubit.getCubit(context).updateProfile(
                            addressDetails: addressController.text,
                            birthdate: dateOfBirthController.text,
                            firstName: firstNameController.text ,
                            lastName: lastNameController.text,
                            mobileNumber: phoneController.text
                        );
                      }, text: 'تعديل')
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

}
