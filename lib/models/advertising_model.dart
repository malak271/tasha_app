class AdvertisingModel {
  int? rv;
  String? msg;
  List<Data>? data;

  AdvertisingModel({this.rv, this.msg, this.data});

  AdvertisingModel.fromJson(Map<String, dynamic> json) {
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
  String? createDateTime;
  String? endDateTime;
  int? userIDAdd;
  String? fileName;
  int? fileType;

  Data(
      {this.iD,
        this.createDateTime,
        this.endDateTime,
        this.userIDAdd,
        this.fileName,
        this.fileType});

  Data.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    createDateTime = json['CreateDateTime'];
    endDateTime = json['EndDateTime'];
    userIDAdd = json['UserIDAdd'];
    fileName = json['FileName'];
    fileType = json['FileType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['CreateDateTime'] = this.createDateTime;
    data['EndDateTime'] = this.endDateTime;
    data['UserIDAdd'] = this.userIDAdd;
    data['FileName'] = this.fileName;
    data['FileType'] = this.fileType;
    return data;
  }
}