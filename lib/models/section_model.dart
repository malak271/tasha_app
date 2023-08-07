class SectionModel{
  int? rv;
  String? msg;
  List<Data>? data;

  SectionModel({this.rv, this.msg, this.data});

  SectionModel.fromJson(Map<String, dynamic> json) {
    rv = json['rv'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rv'] = this.rv;
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? iD;
  int? sectionType;
  String? name;
  String? description;
  int? rate;
  int? defaultPrice;
  String? addressDetails;
  String? latitude;
  String? longitude;
  String? mobileNumber;
  bool? active;
  int? addressID;
  List<Pictures>? pictures;
  int? discount;

  Data(
      {this.iD,
        this.sectionType,
        this.name,
        this.description,
        this.rate,
        this.defaultPrice,
        this.addressDetails,
        this.latitude,
        this.longitude,
        this.mobileNumber,
        this.active,
        this.addressID,
        this.pictures,
        this.discount});

  Data.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    sectionType = json['SectionType'];
    name = json['Name'];
    description = json['Description'];
    rate = json['Rate'];
    defaultPrice = json['DefaultPrice'];
    addressDetails = json['AddressDetails'];
    latitude = json['Latitude'];
    longitude = json['Longitude'];
    mobileNumber = json['MobileNumber'];
    active = json['Active'];
    addressID = json['AddressID'];
    if (json['Pictures'] != null) {
      pictures = <Pictures>[];
      json['Pictures'].forEach((v) {
        pictures!.add(new Pictures.fromJson(v));
      });
    }
    discount = json['Discount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['SectionType'] = this.sectionType;
    data['Name'] = this.name;
    data['Description'] = this.description;
    data['Rate'] = this.rate;
    data['DefaultPrice'] = this.defaultPrice;
    data['AddressDetails'] = this.addressDetails;
    data['Latitude'] = this.latitude;
    data['Longitude'] = this.longitude;
    data['MobileNumber'] = this.mobileNumber;
    data['Active'] = this.active;
    data['AddressID'] = this.addressID;
    if (this.pictures != null) {
      data['Pictures'] = this.pictures!.map((v) => v.toJson()).toList();
    }
    data['Discount'] = this.discount;
    return data;
  }
}

class Pictures {
  String? fileName;

  Pictures({this.fileName});

  Pictures.fromJson(Map<String, dynamic> json) {
    fileName = json['FileName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['FileName'] = this.fileName;
    return data;
  }
}