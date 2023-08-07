
import 'package:hive/hive.dart';
part  'login_model.g.dart';

@HiveType(typeId:0)
class LoginModel extends HiveObject{
  @HiveField(0)
  int? rv;
  @HiveField(1)
  String? msg;
  @HiveField(2)
  UserVM? userVM;
  @HiveField(3)
  String? token;

  LoginModel({this.rv, this.msg, this.userVM, this.token});

  LoginModel.fromJson(Map<String, dynamic> json) {
    rv = json['rv'];
    msg = json['msg'];
    userVM =
    json['userVM'] != null ? new UserVM.fromJson(json['userVM']) : null;
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rv'] = this.rv;
    data['msg'] = this.msg;
    if (this.userVM != null) {
      data['userVM'] = this.userVM!.toJson();
    }
    data['token'] = this.token;
    return data;
  }
}

@HiveType(typeId:1)
class UserVM {
  @HiveField(0)
  int? userID;
  @HiveField(1)
  String? userName;
  @HiveField(2)
  String? sectionType;
  @HiveField(3)
  String? firstName;
  @HiveField(4)
  String? lastName;
  @HiveField(5)
  String? addressDetails;
  @HiveField(6)
  String? city;
  @HiveField(7)
  String? cityName;
  @HiveField(8)
  int? addressID;
  @HiveField(9)
  String? addressName;
  @HiveField(10)
  int? country;
  @HiveField(11)
  String? countryName;
  @HiveField(12)
  String? mobileNumber;
  @HiveField(13)
  int? gender;
  @HiveField(14)
  String? genderName;
  @HiveField(15)
  String? birthDate;
  @HiveField(16)
  String? password;
  @HiveField(17)
  String? email;
  @HiveField(18)
  String? faceBookID;
  @HiveField(19)
  String? googleID;
  @HiveField(20)
  bool? active;
  @HiveField(21)
  String? createDate;
  @HiveField(22)
  String? photo;
  @HiveField(23)
  String? fcmToken;

  UserVM(
      {this.userID,
        this.userName,
        this.sectionType,
        this.firstName,
        this.lastName,
        this.addressDetails,
        this.city,
        this.cityName,
        this.addressID,
        this.addressName,
        this.country,
        this.countryName,
        this.mobileNumber,
        this.gender,
        this.genderName,
        this.birthDate,
        this.password,
        this.email,
        this.faceBookID,
        this.googleID,
        this.active,
        this.createDate,
        this.photo,
        this.fcmToken});

  UserVM.fromJson(Map<String, dynamic> json) {
    userID = json['userID'];
    userName = json['userName'];
    sectionType = json['sectionType'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    addressDetails = json['addressDetails'];
    city = json['city'];
    cityName = json['cityName'];
    addressID = json['addressID'];
    addressName = json['addressName'];
    country = json['country'];
    countryName = json['countryName'];
    mobileNumber = json['mobileNumber'];
    gender = json['gender'];
    genderName = json['genderName'];
    birthDate = json['birthDate'];
    password = json['password'];
    email = json['email'];
    faceBookID = json['faceBookID'];
    googleID = json['googleID'];
    active = json['active'];
    createDate = json['createDate'];
    photo = json['photo'];
    fcmToken = json['fcmToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userID'] = this.userID;
    data['userName'] = this.userName;
    data['sectionType'] = this.sectionType;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['addressDetails'] = this.addressDetails;
    data['city'] = this.city;
    data['cityName'] = this.cityName;
    data['addressID'] = this.addressID;
    data['addressName'] = this.addressName;
    data['country'] = this.country;
    data['countryName'] = this.countryName;
    data['mobileNumber'] = this.mobileNumber;
    data['gender'] = this.gender;
    data['genderName'] = this.genderName;
    data['birthDate'] = this.birthDate;
    data['password'] = this.password;
    data['email'] = this.email;
    data['faceBookID'] = this.faceBookID;
    data['googleID'] = this.googleID;
    data['active'] = this.active;
    data['createDate'] = this.createDate;
    data['photo'] = this.photo;
    data['fcmToken'] = this.fcmToken;
    return data;
  }
}