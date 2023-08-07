import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasha_app/services/home_cubit/states.dart';
import '../../models/advertising_model.dart';
import '../../models/story_model.dart';
import '../../network/remote/dio_helper.dart';
import '../../shared/components/Constants.dart';


class StoryCubit extends Cubit<StoryStates> {
  StoryCubit() : super(StoryInitialState());

  static StoryCubit getCubit(context) => BlocProvider.of(context);

  StoryModel? storyModel;

  void getStories(){
    emit(GetStoriesLoadingState());
    DioHelper.getData(
      url: 'http://tasha.accessline.ps/API/Stories/StoriesSelect',
      onSuccess: (Response) {
        storyModel=StoryModel.fromJson(Response.data);
        emit(GetStoriesSuccessState());
      },
      onError: (ApIError ) {
        emit(GetStoriesErrorState(ApIError.message.toString()));
        print('get stories error');
      },
    );

  }
}

class AdvertisingCubit extends Cubit<AdvertisingStates> {
  AdvertisingCubit() : super(AdvertisingInitialState());

  static AdvertisingCubit getCubit(context) => BlocProvider.of(context);

  AdvertisingModel? advertisingModel;

  void getAdvertising(){
    emit(GetAdvertisingLoadingState());
    DioHelper.getData(
      url: 'http://tasha.accessline.ps/API/Advertising/AdvertisingSelect',
      onSuccess: (Response) {
        advertisingModel=AdvertisingModel.fromJson(Response.data);
        emit(GetAdvertisingSuccessState());
      },
      onError: (ApIError ) {
        emit(GetAdvertisingErrorState(ApIError.message.toString()));
      },
    );
  }
}

class HomeSectionCubit extends Cubit<HomeSectionStates> {
  HomeSectionCubit() : super(HomeSectionInitialState());

  static HomeSectionCubit getCubit(context) => BlocProvider.of(context);

  Map<int, String> images={};

  void getSectionImages(){
    emit(GetSectionImagesLoadingState());
    DioHelper.getData(
        url: 'http://tasha.accessline.ps/api/SectionType/SectionTypesSelect',
        onError: (ApIError) {
          print(ApIError.message.toString());
          emit(GetSectionImagesErrorState(ApIError.message.toString()));
        },
        onSuccess: (Response) {

          var json=Response.data;

          if (json['data'] != null) {
            json['data'].forEach((element) {
              images[element['ID']] =element['FileName'];
              sectionsTitles[element['ID']] =element['Title'];
            });
          }
          emit(GetSectionImagesSuccessState());
        });

  }

}






