class MenuModel {
  int? rv;
  String? msg;
  List<MenuData>? data;

  MenuModel({this.rv, this.msg, this.data});

  MenuModel.fromJson(Map<String, dynamic> json) {
    rv = json['rv'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = <MenuData>[];
      json['data'].forEach((v) {
        data!.add(new MenuData.fromJson(v));
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

class MenuData {
  int? sectionID;
  int? iD;
  String? fileName;
  int? sorting;

  MenuData({this.sectionID, this.iD, this.fileName, this.sorting});

  MenuData.fromJson(Map<String, dynamic> json) {
    sectionID = json['SectionID'];
    iD = json['ID'];
    fileName = json['FileName'];
    sorting = json['Sorting'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['SectionID'] = this.sectionID;
    data['ID'] = this.iD;
    data['FileName'] = this.fileName;
    data['Sorting'] = this.sorting;
    return data;
  }
}