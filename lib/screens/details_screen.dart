import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:tasha_app/models/price_model.dart';
import 'package:tasha_app/models/reservation_model.dart';
import 'package:tasha_app/models/menu_model.dart';
import 'package:tasha_app/models/section_model.dart';
import 'package:tasha_app/models/service_model.dart';
import 'package:tasha_app/screens/jawwal_pay_screen.dart';
import 'package:tasha_app/screens/map_widget.dart';
import 'package:tasha_app/services/details_cubit/details_states.dart';
import 'package:tasha_app/styles/theme.dart';
import '../../shared/components/components.dart';
import '../services/details_cubit/details_cubit.dart';
import '../shared/components/Constants.dart';

class DetailsScreen extends StatelessWidget {
  int sectionTypeID;
  Data data;
  DateRangePickerController calenderController=DateRangePickerController();
  String period='صباحي';
  int periodTypeId=1;

  DetailsScreen({required this.sectionTypeID, required this.data});

  MenuModel? model;
  List<PriceModel>? prices;
  ServiceModel? services;
  List<ReservationModel>? reservations;
  double? totalPrice;
  String? jawwalPayUrl;


  final List<Tab> myTabs = <Tab>[
    Tab(
      text: "صباحا",
    ),
    Tab(
      text: "مساء",
    ),
    Tab(
      text: "24 ساعة",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
       providers: [
         BlocProvider(
             create: (BuildContext context){
               if(sectionTypeID == 1) {
                 return PricesCubit()..getPrices(sectionID: data.iD!);
               }
               return PricesCubit();
             },
         ),
         BlocProvider(
           create: (BuildContext context){
             if(sectionTypeID == 1) {
               return ReservationsCubit()..getReservations(sectionID: data.iD!);
             }
             return ReservationsCubit();
           },
         ),
         BlocProvider(
           create: (BuildContext context) => ServicesCubit()..getServices(sectionID: data.iD!, sectionTypeID: sectionTypeID),
         ),
         BlocProvider(
           create: (BuildContext context){
             if(sectionTypeID == 3) {
               return MenuCubit()..getMenu(SectionID: data.iD!);
             }
             return MenuCubit();
           },
         ),
       ],
       child:BlocBuilder<ReservationsCubit,DetailsStates>(
         builder: (BuildContext context, state)=>MultiBlocListener(
             listeners:[
               BlocListener<PricesCubit,DetailsStates>(listener: (context,state){
                 if (state is GetPricesSuccessState)
                   prices = PricesCubit.getCubit(context).priceModel!;
               }),
               BlocListener<ReservationsCubit,DetailsStates>(listener: (context,state) {
                 if (state is GetReservationsSuccessState){
                   reservations = ReservationsCubit.getCubit(context).reservationModel!;
               }
                  if(state is GetTotalPriceSuccessState){
                   totalPrice=ReservationsCubit.getCubit(context).totalPrice;
                   print(totalPrice);
                 }
                 if(state is GetReservationsSaveSuccessState){
                   jawwalPayUrl=ReservationsCubit.getCubit(context).jawwalPayUrl;
                   navigateTo(context, JawwalPayScreen(jawwalPayUrl: jawwalPayUrl!));
                 }
                 if(state is SaveRatingSuccessState)
                   showToast(text: 'Thanks', state: ToastStates.SUCCESS);
               }),
               BlocListener<ServicesCubit,DetailsStates>(
                   listener: (context,state){
                     if (state is GetServicesSuccessState)
                       services = ServicesCubit.getCubit(context).serviceModel!;}
               ),
               BlocListener<MenuCubit,DetailsStates>(listener: (context,state){
                 if (state is GetMenuSuccessState)
                   model = MenuCubit.getCubit(context).menuModel!;
               }),
             ],
             child: Scaffold(
               extendBodyBehindAppBar: true,
               appBar: AppBar(
                 titleSpacing: 0,
                 automaticallyImplyLeading: false,
                 title: Container(
                   height: 265.0,
                   child: Row(
                     children: [
                       IconButton(
                           icon: Icon(Icons.arrow_back),
                           onPressed: () {
                             Navigator.pop(context);
                           },
                           color: Colors.white),
                       Spacer(),
                       Text(data.name ?? ''),
                       Spacer(),
                       Padding(
                         padding: const EdgeInsets.only(left: 25),
                         child: CircleAvatar(
                             radius: 20.0,
                             backgroundColor: Colors.white,
                             child: IconButton(
                                 icon: Icon(Icons.share),
                                 onPressed: () {},
                                 color: HexColor('6259A8'))),
                       ),
                     ],
                   ),
                 ),
               ),
               body: SingleChildScrollView(
                 physics: BouncingScrollPhysics(),
                 child: Stack(
                   children: [
                     Column(
                       children: [
                         Stack(
                           alignment: AlignmentDirectional.bottomEnd,
                           children: [
                             CarouselSlider.builder(
                                 itemCount: data.pictures?.length ?? 0,
                                 itemBuilder: (context, index, realIndex) {
                                   String urlImage =
                                       'https://img.freepik.com/free-photo/green-park-view_1417-1492.jpg?w=740&t=st=1661494676~exp=1661495276~hmac=0f533c74e7b47f5c58fa136b2273f51daf20d136a0cca1fc9298d1cabf34997e';
                                   if (data.pictures!.isNotEmpty)
                                     urlImage = 'http://tasha.accessline.ps/Files/${data.pictures?[index].fileName}';
                                   return buildImage(urlImage, index);
                                 },
                                 options: CarouselOptions(
                                     height: 290,
                                     autoPlay: false,
                                     viewportFraction: 1,
                                     onPageChanged: (index, reason) {
                                       ReservationsCubit.getCubit(context)
                                           .changeActiveIndex(index);
                                     })),
                             Positioned.fill(
                               child: Align(
                                 child: buildIndicator(context),
                                 alignment: Alignment.bottomCenter,
                               ),
                               bottom: 8,
                             ),
                             Padding(
                               padding: const EdgeInsets.only(left: 25, bottom: 5),
                               child: Container(
                                 decoration: BoxDecoration(
                                   shape: BoxShape.circle,
                                   boxShadow: [
                                     BoxShadow(
                                         blurRadius: 2,
                                         color: Colors.white60,
                                         spreadRadius: 3)
                                   ],
                                 ),
                                 child: CircleAvatar(
                                   radius: 23.0,
                                   backgroundColor: Colors.white,
                                   child: IconButton(
                                     icon: Icon(
                                       Icons.favorite,
                                       color: Colors.red,
                                     ),
                                     onPressed: () {},
                                   ),
                                 ),
                               ),
                             ),
                           ],
                         ),
                         Padding(
                           padding: const EdgeInsets.all(20.0),
                           child: Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               Row(
                                 children: [
                                   Column(
                                     children: [
                                       Text(
                                         data.name ?? '',
                                         style: TextStyle(
                                             fontWeight: FontWeight.bold,
                                             fontSize: 18,
                                             color: HexColor('6259A8')),
                                       ),
                                       SmoothStarRating(
                                         rating: ReservationsCubit.getCubit(context).rate,//data.rate?.toDouble()
                                         size: 25,
                                         starCount: 5,
                                         color: HexColor('EFCE2D'),
                                         borderColor: HexColor('B9B7B7'),
                                         onRatingChanged: (value) {
                                           ReservationsCubit.getCubit(context).changeRate(value);
                                           ReservationsCubit.getCubit(context).saveRating(sectionID: data.iD, rate: value);
                                         },
                                       ),
                                     ],
                                   ),
                                   Spacer(),
                                   if (sectionTypeID == 3)
                                     InkWell(
                                       child: Container(
                                         decoration: BoxDecoration(
                                           boxShadow: [
                                             BoxShadow(
                                                 blurRadius: 10,
                                                 color: Colors.white60,
                                                 spreadRadius: 3)
                                           ],
                                         ),
                                         child: Image(
                                           image:
                                           AssetImage('assets/images/menuIcon.png'),
                                           fit: BoxFit.cover,
                                         ),
                                       ),
                                       onTap: () {
                                         myBottomSheet(context);
                                       },
                                     ),
                                   if (sectionTypeID == 1)
                                     InkWell(
                                       child: Column(
                                         children: [
                                           Row(
                                             children: [
                                               Text(
                                                 '${data.defaultPrice} ',
                                                 style: TextStyle(
                                                     color: HexColor('65B95C'),
                                                     fontWeight: FontWeight.bold),
                                               ),
                                               SvgPicture.asset('assets/images/ils.svg'),
                                             ],
                                           ),
                                           Text(
                                             'تصفح الأسعار',
                                             style: TextStyle(
                                                 color: HexColor('65B95C'),
                                                 fontSize: 11,
                                                 fontWeight: FontWeight.w400),
                                           ),
                                         ],
                                       ),
                                       onTap: () {
                                         pricesBrowse(context);
                                       },
                                     ),
                                 ],
                               ),
                               Divider(
                                 color: HexColor('F3F3F3'),
                                 thickness: .5,
                               ),
                               Padding(
                                 padding: const EdgeInsets.only(left: 50),
                                 child: Text(
                                   data.description ?? '',
                                   maxLines: 2,
                                   overflow: TextOverflow.ellipsis,
                                 ),
                               ),
                               Divider(
                                 color: HexColor('F3F3F3'),
                                 thickness: .5,
                               ),
                               Row(
                                 children: [
                                   Icon(Icons.location_on, color: HexColor('929292')),
                                   Text(
                                     data.addressDetails ?? '',
                                     style: TextStyle(
                                         color: HexColor('929292'), fontSize: 13),
                                   )
                                 ],
                               ),
                               Row(
                                 children: [
                                   Icon(Icons.phone, color: HexColor('929292')),
                                   Text(data.mobileNumber ?? '',
                                       style: TextStyle(
                                           color: HexColor('929292'), fontSize: 13))
                                 ],
                               ),
                               Divider(
                                 color: HexColor('F3F3F3'),
                                 thickness: .5,
                               ),
                               Container(
                                 width: 332,
                                 height: 200,
                                 child:MapWidget(latitude: double.parse(data.latitude??'34.444520'),longitude:double.parse(data.longitude??'31.518954'))
                               ),
                               if (services != null)
                                 Column(
                                   crossAxisAlignment: CrossAxisAlignment.start,
                                   children: [
                                     Text(
                                       'الخدمات الترفيهية',
                                       style: TextStyle(
                                           color: HexColor('515253'),
                                           fontSize: 15,
                                           fontWeight: FontWeight.bold),
                                     ),
                                     Container(
                                       height: 27,
                                       child: ListView.separated(
                                         separatorBuilder: (context, index) => SizedBox(
                                           width: 5,
                                         ),
                                         scrollDirection: Axis.horizontal,
                                         itemBuilder: (context, index) =>
                                             buildServices(services!.data![index]),
                                         itemCount: services!.data!.length,
                                       ),
                                     ),
                                     Divider(
                                       color: HexColor('F3F3F3'),
                                       thickness: .5,
                                     ),
                                   ],
                                 ),
                               if (sectionTypeID == 3)
                                 Column(
                                   children: [
                                     DefaultButton(function: () {}, text: 'اتصل الآن'),
                                     SizedBox(
                                       height: 20,
                                     ),
                                     DefaultButton(
                                         function: () {},
                                         text: 'اطلب عبر',
                                         backGroundColor: (HexColor('28BB4E'))),
                                   ],
                                 ),
                               if (sectionTypeID == 1)
                                 Column(
                                   crossAxisAlignment: CrossAxisAlignment.start,
                                   children: [
                                     Text(
                                       'الحجز',
                                       style: TextStyle(
                                           color: HexColor('515253'),
                                           fontWeight: FontWeight.bold,
                                           fontSize: 18),
                                     ),
                                     Text(
                                       'قم بتحديد فترة الحجز',
                                       style: TextStyle(
                                           color: HexColor('515253'),
                                           fontSize: 16,
                                           fontWeight: FontWeight.w400),
                                     ),
                                     Center(
                                       child: Container(
                                         height: 288,
                                         child: DefaultTabController(
                                           length: 3,
                                           child: Column(
                                             children: <Widget>[
                                               ButtonsTabBar(
                                                 onTap: (value) {
                                                   period=periods[value+1]??'';
                                                   periodTypeId=value+1;
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
                                               Expanded(
                                                 child: Container(
                                                   height: 288,
                                                   width: 335,
                                                   decoration: DECORATION,
                                                   child: TabBarView(
                                                     children: myTabs.map((Tab tab) {
                                                       return getCalendar(context,periodTypeId);
                                                     }).toList(),
                                                   ),
                                                 ),
                                               ),
                                             ],
                                           ),
                                         ),
                                       ),
                                     ),
                                     SizedBox(height: 20,),
                                     DefaultButton(function: () {
                                       ReservationsCubit.getCubit(context).getTotalPrice(
                                           sectionID: data.iD!,
                                           reservationDateFrom: DateFormat('yyyy-MM-dd').format(calenderController.selectedRange!.startDate!),
                                           reservationDateTo: DateFormat('yyyy-MM-dd').format(calenderController.selectedRange!.endDate!),
                                           periodType: periodTypeId);
                                       reservationDetails(context,state);
                                     }, text: 'احجز الان')
                                   ],
                                 ),
                             ],
                           ),
                         ),
                       ],
                     ),
                     if(state is GetTotalPriceLoadingState)
                       Positioned.fill(
                         child: Center(
                           child: Container(
                             height: 100,
                             width: 100,
                             padding: EdgeInsets.all(8),
                             decoration: DECORATION,
                             child: Column(
                               mainAxisAlignment: MainAxisAlignment.center,
                               children: [
                                 Image.asset('assets/images/umbrella.png'),
                                 Text('انتظر لحظة')
                               ],
                             ),
                           ),
                         ),
                       ),
                     // if(state is GetReservationsSaveSuccessState)
                     //   WebView(
                     //     initialUrl: jawwalPayUrl,
                     //   )
                       // Positioned.fill(
                       //   child: Center(
                       //     child: Container(
                       //       height: 190,
                       //       width: 335,
                       //       padding: EdgeInsets.all(8),
                       //       decoration: DECORATION,
                       //       child: Column(
                       //         mainAxisAlignment: MainAxisAlignment.center,
                       //         crossAxisAlignment: CrossAxisAlignment.center,
                       //         children: [
                       //           Image.asset('assets/images/party.png'),
                       //           Text('${ReservationsCubit.getCubit(context).reservationSaveMsg}',maxLines: 4,),
                       //           DefaultButton(function: (function){
                       //             Navigator.pop(context);
                       //           }, text: 'استمر',height: 35)
                       //         ],
                       //       ),
                       //     ),
                       //   ),
                       // ),
                   ],
                 ),
               ),
             )),
       ),
     );
  }

  Widget buildIndicator(context) {
    return AnimatedSmoothIndicator(
      count: data.pictures?.length ?? 0,
      activeIndex: ReservationsCubit.getCubit(context).activeIndex,
      effect: ExpandingDotsEffect(
          activeDotColor: Colors.white, dotHeight: 9, dotWidth: 9),
    );
  }

  Widget buildImage(String urlImage, int index) {
    return Container(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(25)),
      margin: EdgeInsets.symmetric(horizontal: 2),
      child: CachedNetworkImage(
        imageUrl: "$urlImage",
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
        placeholder: (context, url) => Shimmer.fromColors(
            baseColor: Colors.grey[200]!,
            highlightColor: Colors.white,
            child: Container(
              height: 154,
              color: Colors.grey,
            )),
        errorWidget: (context, url, error) => Icon(Icons.error),
      ),
    );
  }

  myBottomSheet(context) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusDirectional.only(
            topEnd: Radius.circular(25),
            topStart: Radius.circular(25),
          ),
        ),
        builder: (context) => Expanded(
              child: Container(
                height: 601,
                child: GridView.builder(
                    padding: EdgeInsets.all(8),
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200,
                            // childAspectRatio: 2 / 2
                            // mainAxisExtent: 2,
                            crossAxisSpacing: 3,
                            mainAxisSpacing: 3),
                    itemCount: model?.data?.length ?? 0,
                    itemBuilder: (BuildContext ctx, index) {
                      return Container(
                        alignment: Alignment.center,
                        height: 100,
                        width: 100,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15)),
                        child: Expanded(
                          child: Image(
                            image: NetworkImage(
                              'http://tasha.accessline.ps${model?.data?[index].fileName}',
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            ));
  }

  buildServices(ServiceData data) {
    return Container(
      decoration: BoxDecoration(
          border: Border(
              left: BorderSide(
        color: Colors.grey,
        width: 1,
      ))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SvgPicture.network(
              'http://tasha.accessline.ps/${data.iconFile}',
            placeholderBuilder: (BuildContext context) => Container(
                child: Icon(Icons.error)),
          ),
          SizedBox(
            width: 5,
          ),
          Text(data.title ?? ''),
          SizedBox(
            width: 5,
          ),
        ],
      ),
    );
  }

  pricesBrowse(context) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusDirectional.only(
            topEnd: Radius.circular(25),
            topStart: Radius.circular(25),
          ),
        ),
        builder: (context) => Expanded(
              child: Container(
                //booking name  price periodtype name
                height: 601,
                child: ListView.builder(
                    itemCount: prices?.length ?? 0,
                    itemBuilder: (context, index) => Container(
                        height: 100,
                        padding: EdgeInsets.all(10),
                        child: buildPriceItem(prices![index]))),
              ),
            ));
  }

  Widget buildPriceItem(PriceModel model) {
     return Row(
      children: [
        Text('${model.bookingName}'),
        Spacer(),
        Text('${model.price} ${model.currency} - ${periods[model.periodType]}'),
        Divider(
          color: HexColor('F3F3F3'),
          thickness: .5,
        ),
      ],
    );
  }

  Widget getCalendar(context,periodType) => SfDateRangePicker(
    controller: calenderController,
        onSelectionChanged: ReservationsCubit.getCubit(context).selectDate,
        selectionMode: DateRangePickerSelectionMode.range,
        // initialSelectedRange: PickerDateRange(
        //     DateTime.now().subtract(const Duration(days: 4)),
        //     DateTime.now().add(const Duration(days: 3))),
        headerStyle: DateRangePickerHeaderStyle(
          backgroundColor: MyColor.getColor(),
          textStyle: TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
        monthCellStyle: DateRangePickerMonthCellStyle(
        disabledDatesDecoration: BoxDecoration(
          color: HexColor('fcdbe4'),
          border: Border.all(
            color: Colors.transparent,
              width: 1),
          shape: BoxShape.circle),
        ),
        rangeSelectionColor:HexColor('FFC010').withOpacity(0.2),
        endRangeSelectionColor: HexColor('FFC010'),
        startRangeSelectionColor: HexColor('FFC010'),
        // enablePastDates: false,
        selectableDayPredicate: (DateTime dateTime) {
          bool isReserved=true;
          String myDate = DateFormat('yyyy-MM-dd').format(dateTime);
          List<String> days = [];

          if (reservations != null) {
            reservations!.forEach((element) {

              days=getDaysFromRange(element.reservationDateFrom!,element.reservationDateTo!);

              if (days.contains(myDate)&&element.periodType==periodType) {
                isReserved= false;
              }
            });
          }
          return isReserved;
        },

      );

  reservationDetails(myContext,state) {
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
          //booking name  price periodtype name
          height: 601,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(alignment: Alignment.center,child: Container(decoration: BoxDecoration(color: MyColor.getColor(),borderRadius: BorderRadius.circular(5)),height: 8,width: 53,)),
                    Text('تفاصيل الحجز',style: TextStyle(color: HexColor('484848'),fontWeight: FontWeight.bold,fontSize:17 ),),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('بداية الحجز  ${DateFormat('yyyy-MM-dd').format(calenderController.selectedRange!.startDate!)}',style: TextStyle(color: HexColor('787878')),),
                        Text('نهاية الحجز  ${DateFormat('yyyy-MM-dd').format(calenderController.selectedRange!.endDate!)}',style: TextStyle(color: HexColor('787878'))),
                        // Text('الايام المستثنية من الحجز ${getDaysFromRange(DateFormat('yyyy-MM-dd').format(calenderController.selectedRange!.startDate!), DateFormat('yyyy-MM-dd').format(calenderController.selectedRange!.endDate!))}'),
                        Text('فترة الحجز  ${period}',style: TextStyle(color: HexColor('787878'))),
                        Divider(),
                      ],
                    ),
                    Row(
                      children: [
                        Text('اجمالي المبلغ',style: TextStyle(color: HexColor('484848'),fontWeight: FontWeight.bold,fontSize:17 ),),
                        Spacer(),
                        Row(
                          children: [
                            Text(
                              '${totalPrice} ',
                              style: TextStyle(
                                  color: HexColor('65B95C'),
                                  fontWeight: FontWeight.bold),
                            ),
                            SvgPicture.asset('assets/images/ils.svg'),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      children: [
                        Checkbox(
                          value: ReservationsCubit.getCubit(myContext).value,
                          onChanged: (currentValue) {
                            ReservationsCubit.getCubit(myContext)
                                .acceptCheckBox(currentValue);
                          },
                          activeColor: HexColor('FFC010'),
                        ),
                        Text('الموافقة على'),
                        TextButton(
                            onPressed: () {}, child: Text('شروط الخصوصية')),
                      ],
                    ),
                    SizedBox(height: 10,),
                    DefaultButton(function: (){
                      ReservationsCubit.getCubit(myContext).reservationSaveBUser(
                          sectionID: data.iD,
                          reservationDateFrom: DateFormat('yyyy-MM-dd').format(calenderController.selectedRange!.startDate!),
                          reservationDateTo: DateFormat('yyyy-MM-dd').format(calenderController.selectedRange!.endDate!),
                          periodType: periodTypeId,
                          paidType: 2, price: totalPrice);
                      Navigator.pop(context);
                    }, text: 'الدفع من خلال التطبيق'),
                    SizedBox(height: 10,),
                    DefaultButton(function: (){
                      ReservationsCubit.getCubit(myContext).reservationSaveBUser(
                          sectionID: data.iD,
                          reservationDateFrom: DateFormat('yyyy-MM-dd').format(calenderController.selectedRange!.startDate!),
                          reservationDateTo: DateFormat('yyyy-MM-dd').format(calenderController.selectedRange!.endDate!),
                          periodType: periodTypeId,
                          paidType: 1, price: totalPrice);
                      Navigator.pop(context);
                    }, text: 'الدفع اليدوي',backGroundColor: Colors.white,fontColor: MyColor.getColor(),borderColor: MyColor.getColor() )
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  getDaysFromRange(String startDate,String endDate){
    List<String> days=[];
    DateTime start = DateTime.parse(startDate);
    DateTime end =   DateTime.parse(endDate);

    for (int i = 0; i <= end.difference(start).inDays; i++) {
      days.add(DateFormat('yyyy-MM-dd').format(start.add(Duration(days: i))));
    }

    return days;
  }

}

/*
Container(
       height: 100,
       child: DefaultTabController(length: 2,
           child: TabBarView(
             children: myTabs.map((Tab tab) {
               return Center(
                 child: Text(
                   'This is the ${tab.text} tab',
                   style: const TextStyle(fontSize: 36),
                 ),
               );
             }).toList(),
           ),),
        )
 */


