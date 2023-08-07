
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:tasha_app/services/cubit/app_cubit.dart';
import 'package:tasha_app/services/request_cubit/request_cubit.dart';
import 'package:tasha_app/services/request_cubit/request_states.dart';
import 'package:tasha_app/styles/theme.dart';

import '../shared/components/Constants.dart';
import '../shared/components/components.dart';

class RequestScreen extends StatelessWidget {
  var nameController = TextEditingController();
  var notesController = TextEditingController();
  var addressController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context)=>RequestCubit(),
      child: BlocConsumer<RequestCubit,RequestStates>(
        builder: (context,state)=>Scaffold(
          appBar: AppBar(
            title: Text('طلب اضافة منشأة',style: TextStyle(color: Colors.black),),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('تقديم طلب الحصول على صاحب منشأة',style: TextStyle(color: MyColor.getColor()),),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color:HexColor('F9F9F9'),
                    ),
                    child: DropdownButtonHideUnderline (
                      child: DropdownButton<String>(
                        value: AppCubit.getCubit(context).sectionValue,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        isExpanded: true,
                        items: sectionsTitles
                            .map((key , value) {
                          return MapEntry(
                              key,
                              DropdownMenuItem<String>(
                                value: value,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(value,style: TextStyle(color:HexColor('AAADB5')),),
                                ),
                              ));
                        })
                            .values
                            .toList(),

                        onChanged: (String? newValue) {
                          AppCubit.getCubit(context).selectSection(newValue);
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  DefaultTextFormField(
                    controller: nameController,
                    type: TextInputType.text,
                    validator: (String? value) {
                      if ((value ?? '').isEmpty) {
                        return 'name must not be empty';
                      }
                    },
                    text: 'الاسم',
                  ),
                  SizedBox(height: 20,),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color:HexColor('F9F9F9'),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: AppCubit.getCubit(context).dropdownvalue,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        isExpanded: true,
                        items: countries
                            .map((key , value) {
                          return MapEntry(
                              key,
                              DropdownMenuItem<String>(
                                value: key,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(key,style: TextStyle(color:HexColor('AAADB5'))),
                                ),
                              ));
                        })
                            .values
                            .toList(),

                        onChanged: (String? newValue) {
                          AppCubit.getCubit(context).selectAddress(newValue);
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
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
                  SizedBox(height: 20,),
                  DefaultTextFormField(
                    controller: notesController,
                    type: TextInputType.text,
                    validator: (String? value) {
                      if ((value ?? '').isEmpty) {
                        return 'address must not be empty';
                      }
                    },
                    text:'ملاحظات أخرى',
                  ),
                  SizedBox(height: 20,),
                  DefaultButton(function: (){
                    if (formKey.currentState!.validate() ) {
                      RequestCubit.get(context).saveSectionsRequestForSUsers(
                            sectionType: sectionsTitles[AppCubit.getCubit(context).sectionValue]??1,
                            name: nameController.text,
                            addressID: countries[AppCubit.getCubit(context).dropdownvalue]??1,
                            addressDetails: addressController.text,
                            notes: notesController.text);

                    }}, text: 'إرسال')
                ],
              ),
            ),
          ),
        ),
        listener: (context,state){
          if(state is SaveSectionsRequestForSUsersSuccessState){
            nameController.text='';
            notesController.text='';
            addressController.text='';
            showToast(text: state.msg, state: ToastStates.SUCCESS);
          }
        },
      ),
    );
  }
}
