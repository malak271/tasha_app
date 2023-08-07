import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:tasha_app/layout/main_layout.dart';
import 'package:tasha_app/services/cubit/app_states.dart';
import 'package:tasha_app/services/cubit/app_cubit.dart';
import 'package:tasha_app/layout/menu_layout.dart';
import 'package:tasha_app/shared/components/components.dart';

class HomeLayout extends StatelessWidget {
  const HomeLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener:(context,state){},
      builder: (context,state){
        var cubit=AppCubit.getCubit(context);
        return Scaffold(
          // appBar: AppBar(
          //   flexibleSpace: Image(
          //     image: AssetImage('assets/images/appbar.png'),
          //     fit: BoxFit.cover,
          //   ),
          //   toolbarHeight: 140,
          //   titleSpacing: 0,
          //   automaticallyImplyLeading: false,
          //   title: Padding(
          //     padding: const EdgeInsets.only(
          //         bottom: 20
          //     ),
          //     child: Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //         Row(
          //           children: [
          //             IconButton(icon:Icon(Icons.menu),color: Colors.white, onPressed: () {
          //             },),
          //             Spacer(),
          //             IconButton(icon:Icon(Icons.notifications),color: Colors.white, onPressed: () {
          //             },),
          //           ],
          //         ),
          //         Padding(
          //           padding: const EdgeInsets.all(20.0),
          //           child: Column(
          //             children: [
          //               Text('أهلا و سهلا',
          //                   style: TextStyle(color: Colors.white,fontWeight: FontWeight.w400,fontSize: 18)),
          //               Text('في تطبيق طشة',
          //                   style: TextStyle(color: Colors.white,fontWeight: FontWeight.w300,fontSize: 12)),
          //             ],
          //           ),
          //         )
          //       ],
          //     ),
          //   ),
          //
          // ),
          body: cubit.screens[cubit.currentIndex],
          bottomNavigationBar: BottomAppBar(
            shape: CircularNotchedRectangle(),
            notchMargin: 8.0,
            clipBehavior: Clip.antiAlias,
            child: Container(
              height: kBottomNavigationBarHeight,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(
                      color: Colors.grey,
                      width: 0.5,
                    ),
                  ),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: BottomNavigationBar(
                      currentIndex: cubit.currentIndex,
                      // backgroundColor: Colors.blue,
                      selectedItemColor: HexColor('FFC010'),
                      onTap: (index) {
                         cubit.changeIndex(context,index);
                      },
                      items: [
                        BottomNavigationBarItem(
                            icon: Icon(Icons.home), label: 'الرئيسية'),
                        BottomNavigationBarItem(
                            icon: Icon(Icons.category), label: 'حجوزاتي'),
                        BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
                        BottomNavigationBarItem(
                            icon: Icon(Icons.map), label: 'أماكن قريبة'),
                        BottomNavigationBarItem(
                            icon: Icon(Icons.person), label: 'الملف الشخصي'),
                      ]),
                ),
              ),
            ),
          ),
          floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
          floatingActionButton: Padding(
            padding: const EdgeInsets.all(2.0),
            child: FloatingActionButton(
              backgroundColor: HexColor('6259A8'),
              child: Icon(Icons.search),
              onPressed: () {
                cubit.currentIndex=2;
                cubit.changeIndex(context,2);
                }),
            ),
        );
      },
    );
  }
}


/*
 Column(
          children: [
            Text('${MyHive.getValue('UserInfo').msg ?? ''} !',
                style: Theme.of(context).textTheme.bodyText1),
           /* Text('${GoogleHelper.userGoogle!.email}',style: TextStyle(color: Colors.white),),
            SizedBox(height: 20,),
            if(GoogleHelper.userGoogle!.photoURL!=null)
            CircleAvatar(
              radius: 30.0,
              backgroundImage:
              NetworkImage(
                '${'${GoogleHelper.userGoogle!.photoURL}'}'
              ),
            ),*/
            // Icon(Icons.account_circle_outlined),
            TextButton(onPressed: () {
              GoogleHelper.GoogleLogout(context);
            }, child: Text('log out from google')),
          ],
        )
 */
