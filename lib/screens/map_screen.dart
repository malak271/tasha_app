import 'dart:typed_data';

import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';
import 'package:tasha_app/models/section_model.dart';
import 'package:tasha_app/styles/theme.dart';
import 'package:geolocator/geolocator.dart';
import '../services/location_cubit/location_cubit.dart';
import '../services/location_cubit/location_states.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import '../models/section_model.dart';
import '../shared/components/components.dart';
import 'details_screen.dart';

class MapScreen extends StatelessWidget {

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

  int? sectionTypeID;

  MapScreen({this.sectionTypeID});

  LatLng? _center ;
  Position? currentLocation;

  @override
  Widget build(BuildContext context){

    CameraPosition position= CameraPosition(
      target: LatLng(_center?.longitude??31.518954,_center?.latitude??34.444520),
      zoom: 18,
    );


    SectionModel? model;

    return BlocProvider(
      create: (context) {
        getUserLocation();
        return LocationCubit();},
      child: BlocConsumer<LocationCubit, LocationStates>(
          listener: (context, state) {
            if(state is GetNearLocationsSuccessState){
              model=LocationCubit.getCubit(context).locationModel;
              print(model?.data?[0].longitude);
              model!.data!.forEach((element) {
                // latLen.add(LatLng(double.parse(element.longitude!), double.parse(element.latitude!)));
                LocationCubit.getCubit(context).mapController!.animateCamera(
                    CameraUpdate.newCameraPosition(
                        CameraPosition(target: LatLng(double.parse(element.latitude!), double.parse(element.longitude!)),zoom: 18)
                    ));
                addNewMarker(element,context);
                // print('hit${element.latitude}');
              });
              // addNewMarker(latLng);
              // addNewMarker(latLen, context);
            }
          },builder:(context,state){
         // addNewMarker(LatLng(double.parse(element.longitude!), double.parse(element.latitude!)),context);

        return Scaffold(
              appBar: AppBar(
                title: Column(
                  children: [
                    Text('الأماكن القريبة'),
                    SizedBox(height: 20,),
                    showTabBar(context)
                  ],
                ),
                backgroundColor: MyColor.getColor(),
                toolbarHeight: 150,
                titleSpacing: 20,
                automaticallyImplyLeading: false,
              ),
              body:GoogleMap(
                gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                  Factory<OneSequenceGestureRecognizer>(() =>  EagerGestureRecognizer(),),
                },
                initialCameraPosition: position,
                onMapCreated: (controller){
                  LocationCubit.getCubit(context).mapController=controller;
                },
                onTap:(latLng){
                  // mapController!.animateCamera(
                  //     CameraUpdate.newCameraPosition(
                  //       CameraPosition(target: latLng,zoom: 18)
                  //     ));
                  // addNewMarker(latLng);
                },
                // markers: LocationCubit.getCubit(context).markers,
                markers: Set<Marker>.of(LocationCubit.getCubit(context).markers),
                circles: LocationCubit.getCubit(context).circles,
                onLongPress: (latLng){
                  addNewCircle(latLng,context);
                },
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
              ),
              //MapWidget(longitude: _center?.longitude,latitude: _center?.latitude,sectionModel: model),
            );
      },
      ),
    );
  }

  Widget showTabBar(context){
    return DefaultTabController(
      length: 4,
      child: Column(
        children: <Widget>[
          ButtonsTabBar(
            onTap: (value) {
              sectionTypeID=value;
              LocationCubit.getCubit(context).removeAllMarkers();
              LocationCubit.getCubit(context).searchByLocation(sectionTypeID: sectionTypeID,latitude:_center?.latitude ,longitude:_center?.longitude );
            },
            backgroundColor: HexColor('FFC010'),
            borderColor: Colors.transparent,
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
            radius: 10,
            tabs: myTabs,
            contentPadding: EdgeInsets.symmetric(
                horizontal: 20),
          ),

        ],
      ),
    );
  }

  Future<Position> locateUser() async {
    return Geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  getUserLocation() async {
      currentLocation = await locateUser();
      _center = LatLng(currentLocation!.latitude, currentLocation!.longitude);
    print('center $_center');
  }

  void addNewMarker(Data element,context){
    // for(int i=0 ;i<latLen.length; i++){
    //   Marker marker =
    //       Marker(
    //         markerId: MarkerId(i.toString()),
    //         position: latLen[i],
    //         infoWindow: InfoWindow(
    //           // given title for marker
    //           title: 'Location: '+i.toString(),
    //         ),
    //       );
    //   LocationCubit.getCubit(context).addMarker(marker);
    // }
    LatLng latLng =LatLng(double.parse(element.latitude!), double.parse(element.longitude!));
    var marker=Marker(
        position: latLng,
        visible: true,
        markerId: MarkerId('Marker_${LocationCubit.getCubit(context).markers.length}'),
        infoWindow: InfoWindow(
          title: '${element.name}',
          snippet: '${element.defaultPrice}',
          onTap: (){
            LocationCubit.getCubit(context).markerOnTap();
            var snackBar = SnackBar(
              content: buildItem(element, context),
              backgroundColor: Colors.white,
              // action: SnackBarAction(
              //   label: 'dismiss',
              //   onPressed: () {
              //   },
              // ),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          },
        )
    );
    LocationCubit.getCubit(context).addMarker(marker);
    // LocationCubit.getCubit(context).markers.add(marker);
  }

  void addNewCircle(LatLng latLng,context){
    var circle= Circle(
        circleId: CircleId('circle'),
        center: latLng,
        visible: true,
        fillColor: Colors.red.shade200,
        strokeColor: Colors.red.shade900,
        strokeWidth: 1,
        radius: 10
    );
     LocationCubit.getCubit(context).circles.add(circle);
  }

  Widget buildItem(Data  data,context) {
    // print('model ${data.}');
    String img='https://img.freepik.com/free-psd/plant-lover-template-psd-care-guide_53876-137807.jpg?w=740&t=st=1661501662~exp=1661502262~hmac=78a145aa9a64b276413ad7be992dcf4daab7d7a4441687da3ef7785bed6b2785';
    if(data.pictures!.isNotEmpty)
      img= 'http://tasha.accessline.ps/Files/${data.pictures?[0].fileName}';

    return InkWell(
      onTap: (){
        navigateTo(context, DetailsScreen(sectionTypeID: sectionTypeID!,data:data));
      },
      child: Container(
        height: 100,
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
                      fontSize: 13,
                    color: Colors.black
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
                    child: Text(data.description??'',style: TextStyle(fontSize: 10,color: Colors.black),maxLines: 2,overflow: TextOverflow.ellipsis,)),
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
    );}

}
