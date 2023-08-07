import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tasha_app/services/location_cubit/location_states.dart';
import '../../../models/section_model.dart';
import '../../../network/remote/dio_helper.dart';

class LocationCubit extends Cubit<LocationStates> {
  LocationCubit() : super(GetLocationsInitialState());

  static LocationCubit getCubit(context) => BlocProvider.of(context);

  SectionModel? locationModel;

  void searchByLocation({
    sectionTypeID,
    required latitude,
    required longitude,
}){
    if(sectionTypeID==0) {
      sectionTypeID='';
    }
    emit(GetNearLocationsLoadingState());
    DioHelper.getData(
      url: 'http://tasha.accessline.ps/API/Sections/SectionsByLocationSelect/SectionsByLocationSelect',
      query: {
        'SectionTypeID': '$sectionTypeID',
        'Latitude':'$latitude',
        'Longitude': '$longitude',
    },
      onSuccess: (response) {
        print(response);
        locationModel=SectionModel.fromJson(response.data);
        emit(GetNearLocationsSuccessState());
      },
      onError: (apIError) {
        print('error in get location ${apIError.message.toString()}');
        emit(GetNearLocationsErrorState());
      },
    );
  }


  bool isPressed=false;

  showTabs(){
    isPressed=!isPressed;
    emit(ShowTabsState());
  }


  GoogleMapController? mapController;

  Set<Marker> markers=<Marker>{};
  Set<Circle> circles=<Circle>{};

  void addMarker(marker){
    markers.add(marker);
    emit(RefreshMapState());
  }

  bool isTap=false;
  markerOnTap(){
     isTap=!isTap;
     emit(MarkerTabState());
  }

  removeAllMarkers(){
    markers.clear();
    emit(MarkerTabState());
  }
  //
  // void addNewMarker(LatLng latLng,context){
  //   var marker=Marker(
  //       position: latLng,
  //       visible: true,
  //       markerId: MarkerId('Marker_${LocationCubit.getCubit(context).markers.length}'),
  //       infoWindow: InfoWindow(
  //         title: 'Location - Gaza',
  //         snippet: 'Gaza',
  //         onTap: (){},
  //       )
  //   );
  //   markers.add(marker);
  //   emit(RefreshMapState());
  // }

}