

abstract class AppStates {}

class AppInitialState extends AppStates {}

class FloatingNextState extends AppStates {}

//menu
class ToggleToMenu extends AppStates{}


//countries
class SelectAddressLoadingState extends AppStates{}

class SelectAddressSuccessState extends AppStates{}

class SelectAddressErrorState extends AppStates{}

class SelectAddressState extends AppStates{}


//search
class GetSearchLoadingState extends AppStates {}

class GetSearchSuccessState extends AppStates {}

class GetSearchErrorState extends AppStates {}

//indicator
class ChangeIndicatorIndexState  extends AppStates {}

//menu
// class GetMenuLoadingState extends AppStates {}
//
// class GetMenuSuccessState extends AppStates {}
//
// class GetMenuErrorState extends AppStates {}

//period
class GetPeriodLoadingState extends AppStates {}

class GetPeriodSuccessState extends AppStates {}

class GetPeriodErrorState extends AppStates {}

class SelectPeriodState extends AppStates{}

class SelectSectionState extends AppStates{}

class ChangeSliderState extends AppStates{}


//checkbox
class SearchCheckBoxState extends AppStates{}

// //services
// class GetServicesLoadingState extends AppStates{}
//
// class GetServicesSuccessState extends AppStates{}
//
// class GetServicesErrorState extends  AppStates{}

//date
class DatePickerState extends AppStates{}

// //prices od chalets
// class GetPricesLoadingState extends AppStates{}
//
// class GetPricesSuccessState extends AppStates{}
//
// class GetPricesErrorState extends  AppStates{}
//
// //reservations od chalets
// class GetReservationsLoadingState extends AppStates{}
//
// class GetReservationsSuccessState extends AppStates{}
//
// class GetReservationsErrorState extends  AppStates{}
//
class CheckboxState extends  AppStates{}

//rating
class ChangeRatingState extends  AppStates{}

//
// //totalPrice
// class GetTotalPriceLoadingState extends AppStates{}
//
// class GetTotalPriceSuccessState extends AppStates{}
//
// class GetTotalPriceErrorState extends  AppStates{}
//
// //reservation save buser
// class GetReservationsSaveLoadingState extends AppStates{}
//
// class GetReservationsSaveSuccessState extends AppStates{}
//
// class GetReservationsSaveErrorState extends  AppStates{}




