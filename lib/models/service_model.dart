class ServiceModel {
  int? rv;
  String? msg;
  List<ServiceData>? data;

  ServiceModel({this.rv, this.msg, this.data});

  ServiceModel.fromJson(Map<String, dynamic> json) {
    rv = json['rv'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = <ServiceData>[];
      json['data'].forEach((v) {
        data!.add( ServiceData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['rv'] = this.rv;
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ServiceData {
  int? iD;
  int? sectionTypeID;
  String? iconFile;
  String? title;
  int? sorting;

  ServiceData({this.iD, this.sectionTypeID, this.iconFile, this.title, this.sorting});

  ServiceData.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    sectionTypeID = json['SectionTypeID'];
    iconFile = json['IconFile'];
    title = json['Title'];
    sorting = json['Sorting'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['ID'] = this.iD;
    data['SectionTypeID'] = this.sectionTypeID;
    data['IconFile'] = this.iconFile;
    data['Title'] = this.title;
    data['Sorting'] = this.sorting;
    return data;
  }
}

// class ServiceModel {
//   int? iD;
//   int? sectionTypeID;
//   String? iconFile;
//   String? title;
//   int? sorting;
//
//   ServiceModel(
//       {this.iD, this.sectionTypeID, this.iconFile, this.title, this.sorting});
//
//   ServiceModel.fromJson(Map<String, dynamic> json) {
//     iD = json['ID'];
//     sectionTypeID = json['SectionTypeID'];
//     iconFile = json['IconFile'];
//     title = json['Title'];
//     sorting = json['Sorting'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data =  Map<String, dynamic>();
//     data['ID'] = this.iD;
//     data['SectionTypeID'] = this.sectionTypeID;
//     data['IconFile'] = this.iconFile;
//     data['Title'] = this.title;
//     data['Sorting'] = this.sorting;
//     return data;
//   }
// }
