class StoryModel {
  int? rv;
  String? msg;
  List<Data>? data;

  StoryModel({this.rv, this.msg, this.data});

  StoryModel.fromJson(Map<String, dynamic> json) {
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
  List<Details>? details;

  Data(
      {this.iD,
        this.createDateTime,
        this.endDateTime,
        this.userIDAdd,
        this.details});

  Data.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    createDateTime = json['CreateDateTime'];
    endDateTime = json['EndDateTime'];
    userIDAdd = json['UserIDAdd'];
    if (json['Details'] != null) {
      details = <Details>[];
      json['Details'].forEach((v) {
        details!.add(new Details.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['CreateDateTime'] = this.createDateTime;
    data['EndDateTime'] = this.endDateTime;
    data['UserIDAdd'] = this.userIDAdd;
    if (this.details != null) {
      data['Details'] = this.details!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Details {
  int? storiesID;
  int? iD;
  String? fileName;
  int? fileType;
  int? sorting;

  Details(
      {this.storiesID, this.iD, this.fileName, this.fileType, this.sorting});

  Details.fromJson(Map<String, dynamic> json) {
    storiesID = json['StoriesID'];
    iD = json['ID'];
    fileName = json['FileName'];
    fileType = json['FileType'];
    sorting = json['Sorting'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['StoriesID'] = this.storiesID;
    data['ID'] = this.iD;
    data['FileName'] = this.fileName;
    data['FileType'] = this.fileType;
    data['Sorting'] = this.sorting;
    return data;
  }
}