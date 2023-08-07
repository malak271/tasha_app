import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:tasha_app/services/details_cubit/details_states.dart';

import '../../models/menu_model.dart';
import '../../models/price_model.dart';
import '../../models/reservation_model.dart';
import '../../models/service_model.dart';
import '../../network/remote/dio_helper.dart';

class PricesCubit extends Cubit<DetailsStates> {
  PricesCubit() : super(DetailsInitialState());

  static PricesCubit getCubit(context) => BlocProvider.of(context);

  List<PriceModel>? priceModel;

  void getPrices({
    required int sectionID,
  }) {

    emit(GetPricesLoadingState());
    DioHelper.getData(
      url: 'http://tasha.accessline.ps/API/SectionPrices/SectionsPricesSelect',
      query: {
        '_SectionID': '$sectionID',
      },
      onSuccess: (Response) {
        priceModel = (Response.data['data'] as List)
            .map((data) => PriceModel.fromJson(data))
            .toList();

        emit(GetPricesSuccessState());
      },
      onError: (ApIError) {
        print('error in get prices ${ApIError.message}');
        emit(GetPricesErrorState());
      },
    );
  }

}

class ReservationsCubit extends Cubit<DetailsStates> {
  ReservationsCubit() : super(DetailsInitialState());

  static ReservationsCubit getCubit(context) => BlocProvider.of(context);

List<ReservationModel>? reservationModel;

   void getReservations({
     required int sectionID,
   }) {
  emit(GetReservationsLoadingState());
  DioHelper.getData(
    url:
    'http://tasha.accessline.ps/API/Reservation/GetReservationsDatesSelectBySeactions/GetReservationsDatesSelectBySeactions',
    query: {
      'section': '$sectionID',
    },
    onSuccess: (response) {
      reservationModel = (response.data['data'] as List)
          .map((data) => ReservationModel.fromJson(data))
          .toList();

      emit(GetReservationsSuccessState());
    },
    onError: (ApIError) {
      print('error in get reservations ${ApIError.message}');
      emit(GetReservationsErrorState());
    },
  );
}

  double totalPrice=0;
  getTotalPrice(
      {required int sectionID,
        required reservationDateFrom,
        required reservationDateTo,
        required int periodType,
        int discount = 0}) {

    emit(GetTotalPriceLoadingState());
    DioHelper.getData(
      url:
      'http://tasha.accessline.ps/API/Reservation/GetReservationPrice/GetReservationPrice',
      query: {
        'SectionID': '$sectionID',
        'ReservationDateFrom': '$reservationDateFrom',
        'ReservationDateTo': '$reservationDateTo',
        'PeriodType': '$periodType',
        'Discount': '$discount'
      },
      onSuccess: (response) {
        totalPrice=response.data['data'][0]['TotalAmount'];
        emit(GetTotalPriceSuccessState());
      },
      onError: (ApIError) {
        print('error in get price ${ApIError.message}');
        emit(GetTotalPriceErrorState());
      },
    );
  }

  String? reservationSaveMsg;

  String? jawwalPayUrl;
  reservationSaveBUser(
      {required  sectionID,
        required reservationDateFrom,
        required reservationDateTo,
        required periodType,
        required paidType,
        required price }) {

    emit(GetReservationsSaveLoadingState());
    DioHelper.postData(
      url:
      'http://tasha.accessline.ps/API/Reservation/ReservationSave',
      data:
      {
        'sectionID': '$sectionID',
        'reservationDateFrom': '$reservationDateFrom',
        'reservationDateTo': '$reservationDateTo',
        'periodType': '$periodType',
        'totalAmount': '${price.round()}',
        'paidType': '$paidType'
      },

      onSuccess: (response) {
        reservationSaveMsg=response.data['msg'];
        jawwalPayUrl= response.data['data'][0]['Url'];
        print('konichiwaaa!!!!!!!');
        print(response.data['data'][0]['Url']);
        emit(GetReservationsSaveSuccessState());
      },
      onError: (ApIError) {
        print('error in get save reservation save ${ApIError.message}');
        emit(GetReservationsSaveErrorState());
      },
    );
  }

  bool value = false;
  acceptCheckBox(currentValue) {
    value = currentValue;
    emit(CheckboxState());
  }

  double rate = 3;
  changeRate(value) {
    rate = value;
    emit(ChangeRatingState());
  }

  saveRating(
      {required  sectionID,
        required rate,
        String? rateNote,}) {

    DioHelper.postData(
      url: 'http://tasha.accessline.ps/API/SectionsRating/SectionsRatingSave',
      data:
      {
        'sectionID': '$sectionID',
        'rate': '$rate',
        'rateNote': '$rateNote',
      },
      onSuccess: (response) {
        emit(SaveRatingSuccessState());
      },
      onError: (ApIError) {
        print('error in post rating ${ApIError.message}');
        emit(SaveRatingErrorState());
      },
    );
  }


int activeIndex = 0;
void changeActiveIndex(index) {
  activeIndex = index;
  emit(ChangeIndicatorIndexState());
}

  String selectedDate = '';
  String dateCount = '';
  String range = '';
  String rangeCount = '';

  void selectDate(DateRangePickerSelectionChangedArgs args) {
    if (args.value is PickerDateRange) {
      range = '${DateFormat('dd/MM/yyyy').format(args.value.startDate)} -'
      // ignore: lines_longer_than_80_chars
          '${DateFormat('dd/MM/yyyy').format(args.value.endDate ?? args.value.startDate)}';
      print(range);
    } else if (args.value is DateTime) {
      selectedDate = args.value.toString();
      print(selectedDate);
    } else if (args.value is List<DateTime>) {
      dateCount = args.value.length.toString();
      print(dateCount);
    } else {
      rangeCount = args.value.length.toString();
      print(rangeCount);
    }
    emit(DatePickerState());
  }
}

class ServicesCubit extends Cubit<DetailsStates> {
  ServicesCubit() : super(DetailsInitialState());

  static ServicesCubit getCubit(context) => BlocProvider.of(context);

  // List<ServiceModel>? serviceModel;
  ServiceModel? serviceModel;

  void getServices({
    required int sectionID,
    required int sectionTypeID,
  }) {
    emit(GetServicesLoadingState());
    DioHelper.getData(
      url: 'http://tasha.accessline.ps/API/ServicesNames/ServicesNamesSelect',
      query: {
        'SectionTypeID': '$sectionTypeID',
        'SectionID': '$sectionID',
      },
      onSuccess: (Response) {
        // ServiceModel s=ServiceModel.fromJson(Response.data['data'][0]);

        // print(Response.data['data']);
        // print('malak');
        //
        // serviceModel=(Response.data['data'] as List)
        //     .map((data){
        //       var test=ServiceModel.fromJson(data);
        //       print('testttttttttttttttttt');
        //       print(test);
        //       return ServiceModel.fromJson(data);})
        //     .toList();
        //
        // print('services length');
        // print(serviceModel?.length);

        serviceModel = ServiceModel.fromJson(Response.data);
        emit(GetServicesSuccessState());
      },
      onError: (ApIError) {
        print('error in get services ${ApIError.message}');
        emit(GetServicesErrorState());
      },
    );
  }
}

class MenuCubit extends Cubit<DetailsStates> {

  static MenuCubit getCubit(context) => BlocProvider.of(context);

  MenuCubit() : super(DetailsInitialState());

  MenuModel? menuModel;

  void getMenu({required int SectionID}) {
    emit(GetMenuLoadingState());
    DioHelper.getData(
      url:
      'http://tasha.accessline.ps/api/SectionsFoodMenu/SectionsFoodMenuSelect',
      query: {
        'SectionID': '$SectionID',
      },
      onSuccess: (Response) {
        menuModel = null;
        menuModel = MenuModel.fromJson(Response.data);
        emit(GetMenuSuccessState());
      },
      onError: (ApIError) {
        emit(GetMenuErrorState());
      },
    );
  }
}








