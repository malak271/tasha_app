class PriceModel {
  int? sectionID;
  int? iD;
  int? bookingID;
  int? periodType;
  int? price;
  int? sorting;
  int? cur;
  String? bookingName;
  String? periodTypeName;
  String? currency;
  int? discount;

  PriceModel(
      {this.sectionID,
        this.iD,
        this.bookingID,
        this.periodType,
        this.price,
        this.sorting,
        this.cur,
        this.bookingName,
        this.periodTypeName,
        this.currency,
        this.discount});

  PriceModel.fromJson(Map<String, dynamic> json) {
    sectionID = json['SectionID'];
    iD = json['ID'];
    bookingID = json['BookingID'];
    periodType = json['PeriodType'];
    price = json['Price'];
    sorting = json['Sorting'];
    cur = json['Cur'];
    bookingName = json['BookingName'];
    periodTypeName = json['PeriodTypeName'];
    currency = json['Currency'];
    discount = json['Discount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['SectionID'] = this.sectionID;
    data['ID'] = this.iD;
    data['BookingID'] = this.bookingID;
    data['PeriodType'] = this.periodType;
    data['Price'] = this.price;
    data['Sorting'] = this.sorting;
    data['Cur'] = this.cur;
    data['BookingName'] = this.bookingName;
    data['PeriodTypeName'] = this.periodTypeName;
    data['Currency'] = this.currency;
    data['Discount'] = this.discount;
    return data;
  }
}