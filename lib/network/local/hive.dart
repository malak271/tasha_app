import 'dart:io';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import '../../models/login_model.dart';

class MyHive{

  MyHive._();

  static  Box? _box;

  static const String loginModelKey = 'loginBox';

  // static Future<bool> init(name) async {
  //   Directory dir = await getApplicationDocumentsDirectory();
  //   await Hive.initFlutter(dir.path);
  //   _registerAdapter();
  //   return _openBox(name: name);
  // }

  static  init() async {
   try{
    Directory dir = await getApplicationDocumentsDirectory();
    await Hive.initFlutter(dir.path);
    _registerAdapter();
  }catch(error){
     print(error.toString());
   }
  }

  static void _registerAdapter(){
    Hive.registerAdapter(LoginModelAdapter());
    Hive.registerAdapter(UserVMAdapter());
    print('register success');
  }


  static  openBox({
    required name,
}) async {
    try {
      _box = await Hive.openBox<LoginModel>(name);
    print('open box');
      // LoginModel model=_box!.get('login');
      // print('open box: ${model.token}');
      // token=model.token;

       // return  Hive.boxExists(name);

    }catch(error){
      // return false;
    }
  }

 static  putValue(key,value) async{
    try{
    await _box!.put(key, value);
    print('put value');
    }catch(error){
      print(error.toString());
    }
  }

  static dynamic getValue(key)  {
    try{
      print('get value');
      return  _box!.get(key);
    }catch(error){
      print(error.toString());
      return null;
    }
  }

  static deleteValue() async{
    try{
      await _box!.deleteFromDisk();
      print('delete');
    }catch(error){
      print(error.toString());
    }
  }

  //Hive.box('products').putAt(productIndex, _product);
  static  putAtValue({firstName,lastName,addressDetails,mobileNumber,birthDate}) async{
    try{
      // await _box!.putAt(index, value);
      print(birthDate);
      LoginModel i = MyHive.getValue('UserInfo');
      i.userVM!.firstName =firstName;
      i.userVM!.lastName=lastName;
      i.userVM!.addressDetails=addressDetails;
      i.userVM!.mobileNumber=mobileNumber;
      i.userVM!.birthDate=birthDate;
      i.save();
      print('put at value');
    }catch(error){
      print('put at value error');
      print(error.toString());
    }
  }


 static Future<bool> isExist(name){
   return   Hive.boxExists(name);
 }


}