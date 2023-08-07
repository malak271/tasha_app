import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasha_app/services/search_cubit/search_states.dart';
import '../../../models/section_model.dart';
import '../../../network/remote/dio_helper.dart';

class SearchCubit extends Cubit<SearchStates> {
  SearchCubit() : super(SearchInitialState());

  static SearchCubit getCubit(context) => BlocProvider.of(context);

  SectionModel? sectionModel;

  void search({
    int? sectionTypeID,
    String name='',
    governorateID,
    priceFrom,
    priceTo,
    periodTypeID,
    orderBy,
    orderByNearest,
    latitude=0,
    longitude=0,
}){
    emit(GetSectionLoadingState());
    DioHelper.getData(
      url: 'http://tasha.accessline.ps/API/Sections/SectionFilter/SectionFilter',
      query: {
        'Name':name,
        'GovernorateID':governorateID,
        'SectionTypeID': '$sectionTypeID',
        'PriceFrom':'$priceFrom',
        'PriceTo':'$priceTo',
        'PeriodTypeID':'$periodTypeID',
        'OrderBy':'false',
        'OrderByNearest':'false',
        'Latitude':'$latitude',
        'Longitude': '$longitude',
    },
      onSuccess: (Response) {
        print(Response);
        sectionModel=SectionModel.fromJson(Response.data);
        emit(GetSectionSuccessState());
      },
      onError: (ApIError ) {
        print('error in get section ${ApIError.message.toString()}');
        emit(GetSectionErrorState());
      },
    );
  }

  void getSection({
    int? sectionTypeID,
    String name='',
  }){
    emit(GetSectionLoadingState());
    DioHelper.getData(
      url: 'http://tasha.accessline.ps/API/Sections/SectionsSelect',
      query: {
        'SectionTypeID': '$sectionTypeID',
        'Name':name,
      },
      onSuccess: (Response) {
        sectionModel=SectionModel.fromJson(Response.data);
        emit(GetSectionSuccessState());
      },
      onError: (ApIError ) {
        print('error in get section ${ApIError.message.toString()}');
        emit(GetSectionErrorState());
      },
    );

  }

  bool isPressed=false;

  showTabs(){
    isPressed=!isPressed;
    emit(showTabsState());
  }





  // Color textButtonColor=HexColor('6E6E6E');
  // Color backgroundButtonColor=HexColor('F9F9F9');
  //
  // buttonClick(textColor,backgroundColor){
  //   textButtonColor=textColor;
  //   backgroundButtonColor=backgroundColor;
  //   emit(ClickButtonState());
  // }


}