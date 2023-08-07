import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/section_model.dart';

class MapWidget extends StatefulWidget {

  double? latitude;
  double? longitude;
  SectionModel? sectionModel;

  MapWidget({this.latitude, this.longitude,this.sectionModel});

  @override
  State<MapWidget> createState() => _MapWidgetState();

}


class _MapWidgetState extends State<MapWidget> {

  @override
  void initState() {
    super.initState();
  }

   GoogleMapController? mapController;

   // List<Marker> markers=[];
   Set<Marker> markers=<Marker>{};
   Set<Circle> circles=<Circle>{};

  @override
  Widget build(BuildContext context) {

    CameraPosition position= CameraPosition(
        target: LatLng(widget.latitude??31.518954, widget.longitude??34.444520),
        zoom: 18,
    );

    if(widget.latitude!=null && widget.longitude!=null)
      addNewMarker(LatLng(widget.latitude!,widget.longitude!));

     if(widget.sectionModel!=null){
       widget.sectionModel!.data!.forEach((element) {
         addNewMarker(LatLng(double.parse(element.longitude!), double.parse(element.latitude!)));
         print('hit${element.latitude}');
       });
     }

    return GoogleMap(
      gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
         Factory<OneSequenceGestureRecognizer>(() =>  EagerGestureRecognizer(),),
      },
      initialCameraPosition: position,
      onMapCreated: (controller){
        setState(() {
          mapController=controller;
        });
      },
      onTap:(latLng){
        // mapController!.animateCamera(
        //     CameraUpdate.newCameraPosition(
        //       CameraPosition(target: latLng,zoom: 18)
        //     ));
        // addNewMarker(latLng);
      },
      markers: markers,
      circles: circles,
      onLongPress: (latLng){
        addNewCircle(latLng);
      },
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
    );
  }

  void addNewMarker(LatLng latLng){
    var marker=Marker(
      position: latLng,
        visible: true,
        markerId: MarkerId('Marker_${markers.length}'),
      infoWindow: InfoWindow(
        title: 'Location - Gaza',
        snippet: 'Gaza',
        onTap: (){},
      )
    );
      setState(() {
        markers.add(marker);
      });
  }

  void addNewCircle(LatLng latLng){
    var circle= Circle(
    circleId: CircleId('circle'),
      center: latLng,
      visible: true,
      fillColor: Colors.red.shade200,
      strokeColor: Colors.red.shade900,
      strokeWidth: 1,
      radius: 10
    );

    setState(() {
      circles.add(circle);
    });
  }


}


