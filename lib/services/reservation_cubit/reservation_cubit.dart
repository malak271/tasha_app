import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasha_app/models/my_reservations_model.dart';
import 'package:tasha_app/services/reservation_cubit/reservation_states.dart';

import '../../network/remote/dio_helper.dart';

class MyReservationsCubit extends Cubit<MYReservationStates> {
  MyReservationsCubit() : super(ReservationInitialState());

  static MyReservationsCubit getCubit(context) => BlocProvider.of(context);

  List<MyReservationsModel>? myReservationModel;

  void getMyReservations() {
    emit(GetMyReservationLoadingState());
    DioHelper.getData(
      url: 'http://tasha.accessline.ps/api/Reservation/GetReservation_By_BUser',
      query: {
        'ReservationDateFrom': '',
        'ReservationDateTo': '',
        'OrderByFirst': '',
        'Approved': '',
        'PageNum': 0
      },
      onSuccess: (response) {
        myReservationModel = (response.data['data'] as List).map((data) {

          getSectionImage(name:data['SectionName']);

           if(state is GetMyReservationImageSuccessState)
             return MyReservationsModel.fromJson(data,img??'');

          return MyReservationsModel.fromJson(data,'');

        }).toList();

        emit(GetMyReservationSuccessState());
      },
      onError: (ApIError) {
        print('error in get my reservations ${ApIError.message}');
        emit(GetMyReservationErrorState(ApIError.message));
      },
    );
  }

  String? img;
  void getSectionImage({
    String name = '',
  }) {
    emit(GetMyReservationImageLoadingState());
    DioHelper.getData(
      url: 'http://tasha.accessline.ps/API/Sections/SectionsSelect',
      query: {
        'Name': name,
      },
      onSuccess: (Response) {
        img=('http://tasha.accessline.ps/Files/${Response.data['data'][0]['Pictures'][0]['FileName']}');
        emit(GetMyReservationImageSuccessState());
      },
      onError: (ApIError) {
        print('error in get section ${ApIError.message.toString()}');
        emit(GetMyReservationImageErrorState());
      },
    );
  }
}
