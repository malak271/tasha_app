class RegisterModel {
  String? fileName;
  int? rv;
  String? msg;
  List<Data>? data;

  RegisterModel({this.fileName, this.rv, this.msg, this.data});

  RegisterModel.fromJson(Map<String, dynamic> json) {
    fileName = json['fileName'];
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
    data['fileName'] = this.fileName;
    data['rv'] = this.rv;
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? fCMToken;
  String? msgTxt;

  Data({this.fCMToken, this.msgTxt});

  Data.fromJson(Map<String, dynamic> json) {
    fCMToken = json['FCMToken'];
    msgTxt = json['MsgTxt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['FCMToken'] = this.fCMToken;
    data['MsgTxt'] = this.msgTxt;
    return data;
  }
}