import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tasha_app/layout/main_layout.dart';
import 'package:tasha_app/screens/edit_profile_screen.dart';
import 'package:tasha_app/shared/components/Constants.dart';
import 'package:tasha_app/shared/components/components.dart';
import '../../models/login_model.dart';
import '../../network/local/hive.dart';


class ProfileScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    LoginModel model = MyHive.getValue('UserInfo');

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image(
            image: AssetImage('assets/images/profileAppBar.PNG'),
            fit: BoxFit.cover,

          ),
        ),
        toolbarHeight: 200,
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        title:Container(
          height: 190.0,
          child: Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: [
              Align(
                child: Row(
                  children: [
                    IconButton(icon: Icon(Icons.arrow_back), onPressed: () { navigateTo(context, MainLayout()); },color: Colors.white),
                    Spacer(),
                    Text('الملف الشخصي'),
                    Spacer(),
                    IconButton(icon: Icon(Icons.edit_calendar_rounded), onPressed: () {
                      navigateTo(context, EditProfileScreen());
                    },color: Colors.white),
                  ],
                ),
                alignment: AlignmentDirectional.topCenter,
              ),
              CircleAvatar(
                radius: 64.0,
                backgroundColor:
                Theme.of(context).scaffoldBackgroundColor,
                child: CircleAvatar(
                  radius: 60.0,
                  backgroundImage: NetworkImage("http://tasha.accessline.ps${model.userVM?.photo}"),
                  // child: getCachedImage(
                  //   imageUrl: "http://tasha.accessline.ps/Files/78510b739cf14983b8785ec0fb1a40f7.png",
                  //   imageBuilder: (context, imageProvider) => Container(
                  //     decoration: BoxDecoration(
                  //       image: DecorationImage(
                  //         image: imageProvider,
                  //         fit: BoxFit.cover,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ),
              ),
            ],
          ),
        ),


      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildItem('الاسم الأول',model.userVM?.firstName),
            buildItem('الاسم الثاني',model.userVM?.lastName),
            buildItem('العنوان',getCountryName(model.userVM?.addressID)),
            buildItem('تفاصيل العنوان',model.userVM?.addressDetails),
            // buildItem('تاريخ الميلاد',DateFormat.yMMMd().format(DateTime.parse(model.userVM?.birthDate??'2002-01-02T00:00:00'))),
            buildItem('رقم الجوال',model.userVM?.mobileNumber),
            buildItem('الجنس',getGender(model.userVM?.gender)),
          ],
        ),
      )
    );
  }

  buildItem(title,text){
     return Column(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
         Text(title,style: TextStyle(color: Colors.grey),),
         Text(text??''),
         Divider(
           color: Colors.grey.shade400,
           thickness: .5,
         ),
       ],
     );
  }

  String getCountryName(id){
    print(id);
    var name= countries.keys.firstWhere(
            (k) => countries[k] == id, orElse: () => '' );
    return name;
  }

  String getGender(id){
    if(id==0)
      return 'ذكر';
    else
      return 'أنثى';
  }

}
