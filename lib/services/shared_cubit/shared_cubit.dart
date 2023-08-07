import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasha_app/services/shared_cubit/shared_states.dart';


class SharedCubit extends Cubit<SharedStates> {
  SharedCubit() : super(SharedInitialState());

  static SharedCubit getCubit(context) => BlocProvider.of(context);


  int activeIndex=0;
  void changeActiveIndex(index){
    activeIndex=index;
    emit(ChangeIndicatorIndexState());
  }
}