import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:tasha_app/screens/login_screen.dart';
import 'package:tasha_app/network/local/hive.dart';
import 'package:tasha_app/shared/components/components.dart';

import '../screens/request_screen.dart';

class MenuLayout extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(),
      backgroundColor: HexColor('6259A8'),
      body: Stack(
        children:  <Widget>[
          const Positioned(
            bottom: 0,
            right:0,
            child: (Image(
              image: AssetImage("assets/images/menu.png"),
            )),
          ),
          Padding(
            padding: const EdgeInsets.only(
                top: 100,
                right: 10
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextButton(onPressed: (){}, child: Text('من نحن',style: Theme.of(context).textTheme.bodyText1),),
                TextButton(onPressed: (){}, child: Text('تواصل معنا',style: Theme.of(context).textTheme.bodyText1,)),
                TextButton(onPressed: (){
                  navigateTo(context, RequestScreen());
                }, child: Text('طلب صاحب المنشأة',style: Theme.of(context).textTheme.bodyText1,)),
                TextButton(onPressed: (){}, child: Text('اللغة',style: Theme.of(context).textTheme.bodyText1,)),
                Divider(
                  color: Colors.grey.shade400,
                  thickness: .5,
                ),
                TextButton(onPressed: (){
                  MyHive.deleteValue();
                  navigateAndFinish(context, LoginScreen());
                }, child: Row(
                  children: [
                    Icon(Icons.logout,color: Colors.white,),
                    SizedBox(width: 10,),
                    Text('تسجيل الخروج',style:Theme.of(context).textTheme.bodyText1,),
                  ],
                )),
              ],
            ),
          )
        ],
      ),
    );
  }
}
