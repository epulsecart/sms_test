class Messages {
  int? yEARID;
  int? sERIALID;
  int? mOBILENO;
  String? sHURTMESSAGE;

  Messages({this.yEARID, this.sERIALID, this.mOBILENO, this.sHURTMESSAGE});

  Messages.fromJson(Map<String, dynamic> json) {
    yEARID = json['YEAR_ID'];
    sERIALID = json['SERIAL_ID'];
    mOBILENO = json['MOBILE_NO'];
    sHURTMESSAGE = json['SHURT_MESSAGE'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['YEAR_ID'] = this.yEARID;
    data['SERIAL_ID'] = this.sERIALID;
    data['MOBILE_NO'] = this.mOBILENO;
    data['SHURT_MESSAGE'] = this.sHURTMESSAGE;
    return data;
  }
}
