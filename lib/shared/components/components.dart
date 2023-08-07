import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shimmer/shimmer.dart';

import 'Constants.dart';


Widget Mylogo()=>Stack(
  children: [
    Image(
        image: AssetImage(
          'assets/images/logo1.png',
        )),
    Image(
        height: 185.86.h,
        image: AssetImage(
          'assets/images/logo2.png',
        )),
  ],
);

Widget DefaultButton({
  double width = double.infinity,
  double? height ,
  required Function function,
  required String text,
  Color? backGroundColor,
  Color? fontColor,
  Color? borderColor,
}) =>
    Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: borderColor?? HexColor('6259A8'),
        ),
        borderRadius: BorderRadius.circular(5.0),
        color: backGroundColor?? HexColor('6259A8'),
      ),
      width: width,
      height: height,
      child: MaterialButton(
        onPressed: () {
          function();
        },
        child: Text(
          text.toUpperCase(),
          style: TextStyle(
            color:fontColor?? Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );



void navigateTo(context, widget) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ));
}

void navigateAndFinish(context, widget) {
  Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
      (route) => false);
}

Widget DefaultTextFormField(
{
  required TextEditingController controller,
  required TextInputType type,
  required FormFieldValidator<String> validator,
  bool isPassword = false,
  required String text,
  Function? onTap,
}
    )=>TextFormField(
  controller: controller,
  keyboardType:type,
  validator: validator,
  obscureText: isPassword,
    onTap: (){
    if(onTap!=null)
      onTap();
    },
  decoration: InputDecoration(
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: HexColor('F9F9F9'), width: 1.0),
    ),
    fillColor:HexColor('F9F9F9'),
    filled: true,
    labelText: text,
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
    focusedBorder:OutlineInputBorder(
      borderSide: BorderSide(color:HexColor('6259A8'), width: 2.0),
      borderRadius: BorderRadius.circular(5.0),
    ),
  ),
  // style: TextStyle(color:HexColor('40A76A')),
);


InputDecoration getSearchDecoration(title){
  InputDecoration SEARCHDECORATION =InputDecoration(
      contentPadding: EdgeInsets.all(8),
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: HexColor('F9F9F9'), width: 1.0),
          borderRadius: BorderRadius.circular(8)
      ),
      fillColor:HexColor('F9F9F9'),
      filled: true,
      labelText: 'ابحث عن $title',
      labelStyle: TextStyle(
        color: HexColor('AAADB5'),
      ),
      focusedBorder:OutlineInputBorder(
          borderSide: BorderSide(color:HexColor('6259A8'), width: 2.0),
          borderRadius: BorderRadius.circular(8)
      ),
      prefixIcon: Icon(Icons.search)
  );
  return SEARCHDECORATION;
}


Widget getCachedImage({required String imageUrl, ImageWidgetBuilder? imageBuilder }){
  return CachedNetworkImage(
    imageUrl: imageUrl,
    imageBuilder: imageBuilder ?? (context, imageProvider) => Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: imageProvider,
          fit: BoxFit.cover,
        ),
      ),
    ) ,
    placeholder: (context, url) => Shimmer.fromColors(
        baseColor: Colors.grey[200]!,
        highlightColor: Colors.white,
        child: Container(
          color: Colors.grey,
        )),
    errorWidget: (context, url, error) => Icon(Icons.error),
  );
}

void showToast({
  required String text,
  required ToastStates state,
}) =>
    Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb:10,
      backgroundColor: chooseToastColor(state),
      textColor: Colors.white,
      fontSize: 16.0,
    );

// enum
enum ToastStates { SUCCESS, ERROR, WARNING }

Color chooseToastColor(ToastStates state) {
  Color color;

  switch (state) {
    case ToastStates.SUCCESS:
      color = Colors.green;
      break;
    case ToastStates.ERROR:
      color = Colors.red;
      break;
    case ToastStates.WARNING:
      color = Colors.amber;
      break;
  }

  return color;
}







