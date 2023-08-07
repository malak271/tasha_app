import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';
import 'package:tasha_app/screens/details_screen.dart';
import 'package:tasha_app/services/cubit/app_states.dart';
import 'package:tasha_app/services/cubit/app_cubit.dart';
import 'package:tasha_app/services/search_cubit/search_cubit.dart';
import 'package:tasha_app/services/search_cubit/search_states.dart';
import '../../models/section_model.dart';
import '../../shared/components/Constants.dart';
import '../../shared/components/components.dart';

class SearchScreen extends StatelessWidget {

  int? sectionTypeID;

  SearchScreen({this.sectionTypeID});

  var searchController = TextEditingController();

  final List<Tab> myTabs = <Tab>[
    Tab(
      text: "الكل",
    ),
    Tab(
      text: "الشاليهات",
    ),
    Tab(
      text: "الفنادق",
    ),
    Tab(
      text: "المطاعم",
    ),
  ];


  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    var model;
    String title='البحث';
    // String title=AppCubit.getCubit(context).imagesTitles[sectionTypeID]??'';

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context)=> SearchCubit()..getSection(sectionTypeID: sectionTypeID),
        ),
      ],
      child: BlocConsumer<SearchCubit, SearchStates>(
        listener: (context, state) {
          if(state is GetSectionSuccessState){
            model=SearchCubit.getCubit(context).sectionModel;
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              toolbarHeight: 80,
              title: Text(title,style: TextStyle(color: Colors.black),),
            ),
            body: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: searchController,
                              keyboardType:TextInputType.text,
                              validator: (String? value) {
                                if ((value ?? '').isEmpty) {
                                  return '!!!';
                                }
                              },
                                decoration: getSearchDecoration(title),
                              onFieldSubmitted: (text){
                                SearchCubit.getCubit(context).search(sectionTypeID: sectionTypeID,name: text);
                              },
                            ),
                          ),
                          TextButton(onPressed: (){
                              if(sectionTypeID != null)
                                MyBottomSheet(context);
                              else {
                                  SearchCubit.getCubit(context).showTabs();
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  color: HexColor('6259A8')
                                ),
                            child: Image(
                              image: AssetImage('assets/images/searchIcon.png'),
                            ),
                          ))
                        ],
                      ),
                      if(SearchCubit.getCubit(context).isPressed)
                       showTabBar(context),
                      if(state is GetSectionLoadingState)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(child: CircularProgressIndicator()),
                      )
                      else if(state is GetSectionSuccessState)
                      ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context,index){
                          print(index);
                          return buildItem(model.data![index],context);
                          },
                          separatorBuilder:(context,index)=>Container(width: double.infinity,color: Colors.grey,) ,
                          itemCount: model?.data?.length??0),
                      // if( sectionTypeID == null)
                      //   Center(
                      //     child: Expanded(
                      //       child: Image(
                      //         image: AssetImage('assets/images/search.png'),
                      //       ),
                      //     ),
                      //   )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildItem(Data  data,context) {
    // print('model ${data.}');
    String img='https://img.freepik.com/free-psd/plant-lover-template-psd-care-guide_53876-137807.jpg?w=740&t=st=1661501662~exp=1661502262~hmac=78a145aa9a64b276413ad7be992dcf4daab7d7a4441687da3ef7785bed6b2785';
    if(data.pictures!.isNotEmpty)
      img= 'http://tasha.accessline.ps/Files/${data.pictures?[0].fileName}';

   return Padding(
    padding: const EdgeInsets.all(8.0),
    child: InkWell(
      onTap: (){
        navigateTo(context, DetailsScreen(sectionTypeID: sectionTypeID!,data:data));
      },
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
            border: Border.all(color: HexColor('F2F2F2')),
          boxShadow: [
            BoxShadow(
              color:HexColor('F2F2F2'),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Image(
                image: NetworkImage(img),
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            SizedBox(width: 20,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data.name??'',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13
                  ),
                ),
                SmoothStarRating(
            rating: data.rate?.toDouble()??5.0,
            size: 20,
            starCount: 5,
            color: HexColor('EFCE2D'),
            borderColor: HexColor('B9B7B7'),
            onRatingChanged: (value) {
              // setState(() {
              //   rating = value;
              // });
            },
          ),
                Container(
                   width: 120,
                    child: Text(data.description??'',style: TextStyle(fontSize: 10),maxLines: 2,overflow: TextOverflow.ellipsis,)),
                if(sectionTypeID!=3)
                Row(
                  children: [
                    Text(data.defaultPrice.toString(),style: TextStyle(color: HexColor('6259A8'),fontSize: 14,fontWeight: FontWeight.bold),),
                    Image(
                      image: AssetImage('assets/images/ils.png'),
                    )
                  ],
                )
              ],
            ),
            Spacer(),
            if(data.discount!>0)
            Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Icon(
                  Icons.bookmark,
                  color: HexColor('F04B6D'),
                  size: 70.0,
                ),
                Text(
                  "خصم\n"
                      "${data.discount}",
                  style: TextStyle(fontSize: 11,color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );}

  MyBottomSheet(myContext){
    showModalBottomSheet(
      isScrollControlled: true,
      context: myContext,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusDirectional.only(
          topEnd: Radius.circular(25),
          topStart: Radius.circular(25),
        ),
      ),
      builder: (context) => Container(
          height: 601,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('عرض حسب'),
                  BlocConsumer<AppCubit,AppStates>(
                    listener: (context,state){},
                    builder:(context,state)=> Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color:HexColor('F9F9F9'),
                          ),
                          child: DropdownButtonHideUnderline (
                            child: ButtonTheme(
                              alignedDropdown: true,
                              buttonColor: Colors.red,
                              child: DropdownButton<String>(
                                value: AppCubit.getCubit(context).dropdownvalue,
                                icon: const Icon(Icons.keyboard_arrow_down),
                                items: countries
                                    .map((key , value) {
                                  return MapEntry(
                                      key,
                                      DropdownMenuItem<String>(
                                        value: key,
                                        child: Text(key,style: TextStyle(color:HexColor('AAADB5')),),
                                      ));
                                })
                                    .values
                                    .toList(),

                                onChanged: (String? newValue) {
                                  AppCubit.getCubit(context).selectAddress(newValue);
                                },
                                isExpanded: true,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10,),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color:HexColor('F9F9F9'),
                          ),
                          child: DropdownButtonHideUnderline (
                            child: ButtonTheme(
                              alignedDropdown: true,
                              child: DropdownButton<String>(
                                value: AppCubit.getCubit(context).periodValue,
                                icon: const Icon(Icons.keyboard_arrow_down),
                                isExpanded: true,
                                items: periods
                                    .map((key , value) {
                                  return MapEntry(
                                      key,
                                      DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value,style: TextStyle(color:HexColor('AAADB5')),),
                                      ));
                                })
                                    .values
                                    .toList(),

                                onChanged: (String? newValue) {
                                  AppCubit.getCubit(context).selectPeriod(newValue);
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text('السعر'),
                  RangeSlider(
                    min: 0,
                    max: 1000,
                    labels: RangeLabels(AppCubit.getCubit(context).sliderStart.toString(), AppCubit.getCubit(myContext).sliderEnd.toString()),
                    divisions: 20,
                    values: RangeValues(AppCubit.getCubit(myContext).sliderStart.toDouble(),AppCubit.getCubit(myContext).sliderEnd.toDouble()),
                    onChanged: (value) {
                      AppCubit.getCubit(myContext).changeSlider(value.start.round(),value.end.round());
                    },
                  ),
                  Text('ترتيب حسب'),
                  ListView(
                    shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children:  AppCubit.getCubit(myContext).values.keys.map((String key) {
                  return  CheckboxListTile(
                    title: Text(key),
                    value: AppCubit.getCubit(myContext).values[key],
                    activeColor: HexColor('FFC010'),
                    onChanged: (currentValue) {
                      AppCubit.getCubit(myContext)
                          .changeCheckBox(key,currentValue);
                    },
                  );
                }).toList(),
              ),
                  DefaultButton(function: (){
                      SearchCubit.getCubit(myContext).search(
                        name: searchController.text,
                        sectionTypeID: sectionTypeID,
                        priceFrom: AppCubit.getCubit(myContext).sliderStart,
                        priceTo: AppCubit.getCubit(myContext).sliderEnd,
                        governorateID: countries[AppCubit.getCubit(context).dropdownvalue],
                        periodTypeID: getPeriodID(AppCubit.getCubit(context).periodValue),
                      );
                      Navigator.pop(context);
                  }, text: 'عرض')
                ],
              ),
            ),
          )
      ),
    );

  }

  int getPeriodID(name){
    var id= periods.keys.firstWhere(
            (k) => periods[k] == name, orElse: () => 0 );
    return id;
  }

  Widget showTabBar(context){
   return Container(
     height: 100,
     child: DefaultTabController(
        length: 4,
        child: Column(
          children: <Widget>[
            ButtonsTabBar(
              onTap: (value) {
                sectionTypeID=value;
                print( searchController.text);
                SearchCubit.getCubit(context).getSection(sectionTypeID: sectionTypeID,name: searchController.text);
              },
              backgroundColor: HexColor('FFC010'),
              borderColor: HexColor('F9F9F9'),
              unselectedBackgroundColor:
              HexColor('F9F9F9'),
              unselectedBorderColor:
              HexColor('F5F5F5'),
              labelStyle: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
              unselectedLabelStyle: TextStyle(
                  color: HexColor('6E6E6E'),
                  fontWeight: FontWeight.bold),
              borderWidth: 1,
              radius: 20,
              tabs: myTabs,
              contentPadding: EdgeInsets.symmetric(
                  horizontal: 30),
            ),

          ],
        ),
      ),
   );
  }
}
