import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';

const LOGIN = 'token';

String? token;

var fcmToken;

Map<String, int> countries={};

Map<int, String> periods={};

Map<int, String> sectionsTitles={};

BoxDecoration DECORATION = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(10),
  boxShadow: [
    BoxShadow(
      color: Colors.grey[300]!.withOpacity(0.5),
      spreadRadius: 5,
      blurRadius: 5,
      offset: Offset(0, 3), // changes position of shadow
    ),
  ],

);


SizedBox SIZEDBOX20 = SizedBox(
  height: 20.h,
);

void printFullText(String text) {
  final pattern = RegExp('.{1,800}');
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}

var inputDecoration = InputDecoration(
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: HexColor('F9F9F9'), width: 2.0),
  ),
  fillColor: HexColor('F9F9F9'),
  filled: true,
  labelStyle: TextStyle(
    color: HexColor('AAADB5'),
  ),
  border: const OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(5)),
    borderSide: BorderSide(
      color: Colors.red,
      width: 2.0,
    ),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: HexColor('6259A8'), width: 2.0),
    borderRadius: BorderRadius.circular(5.0),
  ),
);


//sharedPreferences logout
// CacheHelper.removeData(key: 'token').then((value){
// if(value){
// navigateAndFinish(context, ShopLoginScreen());
// }
// });