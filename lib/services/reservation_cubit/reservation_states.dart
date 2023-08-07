//reservations
abstract class MYReservationStates {}

class ReservationInitialState extends MYReservationStates {}

class GetMyReservationLoadingState extends MYReservationStates {}

class GetMyReservationSuccessState extends MYReservationStates {}

class GetMyReservationErrorState extends MYReservationStates {
  final String error;

  GetMyReservationErrorState(this.error);
}

//get sectionimages
class GetMyReservationImageLoadingState extends MYReservationStates {}

class GetMyReservationImageSuccessState extends MYReservationStates {}

class GetMyReservationImageErrorState extends MYReservationStates {}