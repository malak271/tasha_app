class ReservationModel {
  int? iD;
  String? reservationDateFrom;
  String? reservationDateTo;
  int? periodType;

  ReservationModel(
      {this.iD,
        this.reservationDateFrom,
        this.reservationDateTo,
        this.periodType});

  ReservationModel.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    reservationDateFrom = json['ReservationDateFrom'];
    reservationDateTo = json['ReservationDateTo'];
    periodType = json['PeriodType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['ReservationDateFrom'] = this.reservationDateFrom;
    data['ReservationDateTo'] = this.reservationDateTo;
    data['PeriodType'] = this.periodType;
    return data;
  }
}