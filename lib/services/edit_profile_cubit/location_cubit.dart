import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasha_app/models/login_model.dart';
import 'package:tasha_app/services/edit_profile_cubit/location_states.dart';
import '../../../network/remote/dio_helper.dart';
import '../../network/local/hive.dart';

class EditProfileCubit extends Cubit<EditProfileStates> {
  EditProfileCubit() : super(EditProfileInitialState());

  static EditProfileCubit getCubit(context) => BlocProvider.of(context);

  LoginModel? loginModel;

  void updateProfile ({
     required String firstName,
     required String lastName,
     required String addressDetails,
     required String mobileNumber,
     required String birthdate,
  }) async{
    emit(EditProfileLoadingState());
    DioHelper.putData(
        url: 'http://tasha.accessline.ps/API/BUsers/BUsersUpdate',
        data:{
          "FirstName":"$firstName",
          "LastName":"$lastName",
          "AddressDetails":"$addressDetails",
          "AddressID":"",
          "MobileNumber":"$mobileNumber",
          "BirthDate":"2005-10-08",
          "Gender":"",
          "Photo":""
        },
        onError: (apIError) {
          print(apIError.message.toString());
          emit(EditProfileSuccessState());
        },
        onSuccess: (response) async{
          print(response.data);
          // loginModel = LoginModel.fromJson(response.data);

          await MyHive.openBox(
            name: MyHive.loginModelKey,
          );

          await  MyHive.putAtValue(firstName: firstName,lastName: lastName,mobileNumber: mobileNumber,addressDetails: addressDetails,birthDate: birthdate);

          emit(EditProfileErrorState());
        });
  }

}