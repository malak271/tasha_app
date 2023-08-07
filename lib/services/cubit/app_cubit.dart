
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasha_app/screens/map_screen.dart';
import 'package:tasha_app/screens/map_widget.dart';
import 'package:tasha_app/screens/search_screen.dart';
import 'package:tasha_app/services/cubit/app_states.dart';
import 'package:tasha_app/shared/components/components.dart';
import '../../screens/home_screen.dart';
import '../../screens/profile_screen.dart';
import '../../screens/reservation_screen.dart';
import '../../network/remote/dio_helper.dart';
import '../../shared/components/Constants.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit getCubit(context) => BlocProvider.of(context);

  void getAddresses() async {
    emit(SelectAddressLoadingState());
    DioHelper.getData(
        url: 'http://tasha.accessline.ps/api/Constants/AddressSelect',
        query: {
          'CountryID': '57',
          'Governorate': '1',
          'GovernorateOnly': 'true'
        },
        onError: (ApIError) {
          print(ApIError.message.toString());
          emit(SelectAddressErrorState());
        },
        onSuccess: (Response) {
          var json = Response.data;

          if (json['data'] != null) {
            json['data'].forEach((element) {
              print(element['ID']);
              print(element['Name']);
              countries[element['Name']] = element['ID'];
            });
          }
          print('what ${countries.length}');
          emit(SelectAddressSuccessState());
        });
  }

  // Initial Selected Value
  String dropdownvalue = 'محافظة غزة';

  selectAddress(value) {
    dropdownvalue = value;
    emit(SelectAddressState());
  }

  // int activeIndex = 0;
  // void changeActiveIndex(index) {
  //   activeIndex = index;
  //   emit(ChangeIndicatorIndexState());
  // }

  int currentIndex = 0;

  void changeIndex(context, index) async{
    if (index == 2) {
      navigateTo(context, SearchScreen());
      index = 0;
    }
    currentIndex = index;
    emit(FloatingNextState());
  }

  List<Widget> screens = [
    HomeScreen(),
    ReservationsScreen(),
    SearchScreen(),
    MapScreen(),
    // MapWidget(latitude: 31.518954,longitude: 34.444520),
    ProfileScreen()
  ];

  //get menu
  // MenuModel? menuModel;
  //
  // void getMenu({required int SectionID}) {
  //   print('data.id${SectionID}');
  //   emit(GetMenuLoadingState());
  //   DioHelper.getData(
  //     url:
  //         'http://tasha.accessline.ps/api/SectionsFoodMenu/SectionsFoodMenuSelect',
  //     query: {
  //       'SectionID': '$SectionID',
  //     },
  //     onSuccess: (Response) {
  //       menuModel = null;
  //       menuModel = MenuModel.fromJson(Response.data);
  //       print('hi');
  //       print(menuModel?.data?[0].sectionID);
  //       emit(GetMenuSuccessState());
  //     },
  //     onError: (ApIError) {
  //       emit(GetMenuErrorState());
  //     },
  //   );
  // }

  //search cubit

  // Initial Selected Value
  String periodValue = 'صباحي';

  selectPeriod(value) {
    periodValue = value;
    emit(SelectPeriodState());
  }

  //select section for requests
  String sectionValue = 'الشاليهات';

  selectSection(value) {
    sectionValue = value;
    emit(SelectPeriodState());
  }

  void getPeriod() async {
    emit(GetPeriodLoadingState());
    DioHelper.getData(
        url: 'http://tasha.accessline.ps/API/Constants/PeriodTypesSelect',
        onError: (ApIError) {
          print(ApIError.message.toString());
          emit(GetPeriodErrorState());
        },
        onSuccess: (Response) {
          var json = Response.data;

          if (json['data'] != null) {
            json['data'].forEach((element) {
              print(element['Code']);
              print(element['Name']);
              periods[element['Code']] = element['Name'];
            });
          }
          print('periods lenght ${periods.length}');

          emit(GetPeriodSuccessState());
        });
  }

  int sliderStart = 0;
  int sliderEnd = 0;

  void changeSlider(start, end) {
    sliderStart = start;
    sliderEnd = end;
    emit(ChangeSliderState());
  }

  Map<String, bool> values = {
    'الأكثر تقييم': true,
    'الأكثر  مشاهدة': true,
    'المنطقة الأقرب': true,
    'الخصومات و العروض': true,
  };

  changeCheckBox(key, currentValue) {
    values[key] = currentValue;
    emit(SearchCheckBoxState());
  }

  // // List<ServiceModel>? serviceModel;
  // ServiceModel? serviceModel;
  //
  // void getServices({
  //   required int sectionID,
  //   required int sectionTypeID,
  // }) {
  //   print(sectionID);
  //   print(sectionTypeID);
  //   emit(GetServicesLoadingState());
  //   DioHelper.getData(
  //     url: 'http://tasha.accessline.ps/API/ServicesNames/ServicesNamesSelect',
  //     query: {
  //       'SectionTypeID': '$sectionTypeID',
  //       'SectionID': '$sectionID',
  //     },
  //     onSuccess: (Response) {
  //       print(Response);
  //       // ServiceModel s=ServiceModel.fromJson(Response.data['data'][0]);
  //
  //       // print(Response.data['data']);
  //       // print('malak');
  //       //
  //       // serviceModel=(Response.data['data'] as List)
  //       //     .map((data){
  //       //       var test=ServiceModel.fromJson(data);
  //       //       print('testttttttttttttttttt');
  //       //       print(test);
  //       //       return ServiceModel.fromJson(data);})
  //       //     .toList();
  //       //
  //       // print('services length');
  //       // print(serviceModel?.length);
  //
  //       serviceModel = ServiceModel.fromJson(Response.data);
  //       print(serviceModel!.data![0].title);
  //       emit(GetServicesSuccessState());
  //     },
  //     onError: (ApIError) {
  //       print('error in get services ${ApIError.message}');
  //       emit(GetServicesErrorState());
  //     },
  //   );
  // }

  // DateTime startDate=DateTime.parse('1969-07-20 20:18:04Z');
  // DateTime endDate= DateTime.parse('2022-12-20 20:18:04Z');

  // String selectedDate = '';
  // String dateCount = '';
  // String range = '';
  // String rangeCount = '';
  //
  // void selectDate(DateRangePickerSelectionChangedArgs args) {
  //   if (args.value is PickerDateRange) {
  //     range = '${DateFormat('dd/MM/yyyy').format(args.value.startDate)} -'
  //         // ignore: lines_longer_than_80_chars
  //         ' ${DateFormat('dd/MM/yyyy').format(args.value.endDate ?? args.value.startDate)}';
  //     print(range);
  //   } else if (args.value is DateTime) {
  //     selectedDate = args.value.toString();
  //     print(selectedDate);
  //   } else if (args.value is List<DateTime>) {
  //     dateCount = args.value.length.toString();
  //     print(dateCount);
  //   } else {
  //     rangeCount = args.value.length.toString();
  //     print(rangeCount);
  //   }
  //   emit(DatePickerState());
  // }

  // List<PriceModel>? priceModel;
  //
  // void getPrices({
  //   required int sectionID,
  // }) {
  //   print(sectionID);
  //   emit(GetPricesLoadingState());
  //   DioHelper.getData(
  //     url: 'http://tasha.accessline.ps/API/SectionPrices/SectionsPricesSelect',
  //     query: {
  //       '_SectionID': '$sectionID',
  //     },
  //     onSuccess: (Response) {
  //       priceModel = (Response.data['data'] as List)
  //           .map((data) => PriceModel.fromJson(data))
  //           .toList();
  //
  //       emit(GetPricesSuccessState());
  //     },
  //     onError: (ApIError) {
  //       print('error in get prices ${ApIError.message}');
  //       emit(GetPricesErrorState());
  //     },
  //   );
  // }

  //Reservation
  // List<ReservationModel>? reservationModel;
  //
  // void getReservations({
  //   required int sectionID,
  // }) {
  //   print(sectionID);
  //   emit(GetReservationsLoadingState());
  //   DioHelper.getData(
  //     url:
  //         'http://tasha.accessline.ps/API/Reservation/GetReservationsDatesSelectBySeactions/GetReservationsDatesSelectBySeactions',
  //     query: {
  //       'section': '$sectionID',
  //     },
  //     onSuccess: (response) {
  //       reservationModel = (response.data['data'] as List)
  //           .map((data) => ReservationModel.fromJson(data))
  //           .toList();
  //
  //       emit(GetReservationsSuccessState());
  //     },
  //     onError: (ApIError) {
  //       print('error in get reservations ${ApIError.message}');
  //       emit(GetReservationsErrorState());
  //     },
  //   );
  // }

  // bool value = false;
  // acceptCheckBox(currentValue) {
  //   value = currentValue;
  //   emit(CheckboxState());
  // }
  //
  // double rate = 3;
  // changeRate(value) {
  //   rate = value;
  //   emit(ChangeRatingState());
  // }

  // double totalPrice=0;
  //  getTotalPrice(
  //     {required int sectionID,
  //     required reservationDateFrom,
  //     required reservationDateTo,
  //     required int periodType,
  //     int discount = 0}) {
  //
  //    emit(GetTotalPriceLoadingState());
  //   DioHelper.getData(
  //     url:
  //         'http://tasha.accessline.ps/API/Reservation/GetReservationPrice/GetReservationPrice',
  //     query: {
  //       'SectionID': '$sectionID',
  //       'ReservationDateFrom': '$reservationDateFrom',
  //       'ReservationDateTo': '$reservationDateTo',
  //       'PeriodType': '$periodType',
  //       'Discount': '$discount'
  //     },
  //     onSuccess: (response) {
  //       totalPrice=response.data['data'][0]['TotalAmount'];
  //       emit(GetTotalPriceSuccessState());
  //       },
  //     onError: (ApIError) {
  //       print('error in get price ${ApIError.message}');
  //       emit(GetTotalPriceErrorState());
  //     },
  //   );
  // }
  //
  // String? reservationSaveMsg;
  // reservationSaveBUser(
  //     {required  sectionID,
  //       required reservationDateFrom,
  //       required reservationDateTo,
  //       required periodType,
  //       required paidType,
  //       required price }) {
  //
  //   print(sectionID);
  //    print( reservationDateFrom);
  //    print( reservationDateTo);
  //    print( periodType);
  //    print( paidType);
  //    print( price);
  //   emit(GetReservationsSaveLoadingState());
  //   DioHelper.postData(
  //     url:
  //     'http://tasha.accessline.ps/API/Reservation/ReservationSave',
  //     data:
  //     {
  //       'sectionID': '$sectionID',
  //       'reservationDateFrom': '$reservationDateFrom',
  //       'reservationDateTo': '$reservationDateTo',
  //       'periodType': '$periodType',
  //       'totalAmount': '${price.round()}',
  //       'paidType': '$paidType'
  //     },
  //
  //     onSuccess: (response) {
  //       reservationSaveMsg=response.data['msg'];
  //       print(reservationSaveMsg);
  //       emit(GetReservationsSaveSuccessState());
  //     },
  //     onError: (ApIError) {
  //       print('error in get save regi ${ApIError.message}');
  //       emit(GetReservationsSaveErrorState());
  //     },
  //   );
  // }
}

