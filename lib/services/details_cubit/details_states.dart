//reservation
abstract class DetailsStates {}

class DetailsInitialState extends DetailsStates {}

//prices of chalets
class GetPricesLoadingState extends DetailsStates{}

class GetPricesSuccessState extends DetailsStates{}

class GetPricesErrorState extends  DetailsStates{}

//reservations of chalets
class GetReservationsLoadingState extends DetailsStates{}

class GetReservationsSuccessState extends DetailsStates{}

class GetReservationsErrorState extends  DetailsStates{}


//totalPrice
class GetTotalPriceLoadingState extends DetailsStates{}

class GetTotalPriceSuccessState extends DetailsStates{}

class GetTotalPriceErrorState extends  DetailsStates{}

//reservation save b user
class GetReservationsSaveLoadingState extends DetailsStates{}

class GetReservationsSaveSuccessState extends DetailsStates{}

class GetReservationsSaveErrorState extends  DetailsStates{}

//services
class GetServicesLoadingState extends DetailsStates{}

class GetServicesSuccessState extends DetailsStates{}

class GetServicesErrorState extends DetailsStates{}

//menu
class GetMenuLoadingState extends DetailsStates{}

class GetMenuSuccessState extends DetailsStates{}

class GetMenuErrorState extends DetailsStates{}

//things
class CheckboxState  extends DetailsStates{}

class ChangeRatingState extends DetailsStates{}

class ChangeIndicatorIndexState extends DetailsStates{}

class DatePickerState extends DetailsStates{}

//rating
class SaveRatingSuccessState extends DetailsStates{}

class SaveRatingErrorState extends DetailsStates{}