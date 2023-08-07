

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasha_app/services/request_cubit/request_states.dart';

import '../../network/remote/dio_helper.dart';

class RequestCubit extends Cubit<RequestStates> {
  RequestCubit() : super(RequestInitialState());

  static RequestCubit get(context) => BlocProvider.of(context);

  void saveSectionsRequestForSUsers ({
    required  sectionType,
    required  name,
    required  addressID,
    required  addressDetails,
    required  notes,
  }) async{

    emit(SaveSectionsRequestForSUsersLoadingState());
    DioHelper.postData(
        url: 'http://tasha.accessline.ps/API/SectionsRequest/SaveSectionsRequestForSUsers',
        data: {
          'sectionType':'$sectionType',
          'name':'$name',
          'addressID':'$addressID',
          'addressDetails':'$addressDetails',
          'notes':'$notes',
        },
        onError: (apiError) {
          print(apiError.message);
          emit(SaveSectionsRequestForSUsersErrorState());
        },
        onSuccess: (response) {
          print(response);
          emit(SaveSectionsRequestForSUsersSuccessState(response.data['msg']));
        });
  }

}
