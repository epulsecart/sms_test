class UserData {
  String? xUSERNAME;
  int? xUSERPASS;
  int? xMOBILEID;
  String? url;

  UserData({this.xUSERNAME, this.xUSERPASS, this.xMOBILEID, this.url});

  UserData.fromJson(Map<String, dynamic> json) {
    xUSERNAME = json['X_USER_NAME'];
    xUSERPASS = json['X_USER_PASS'];
    xMOBILEID = json['X_MOBILE_ID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['X_USER_NAME'] = this.xUSERNAME;
    data['X_USER_PASS'] = this.xUSERPASS;
    data['X_MOBILE_ID'] = this.xMOBILEID;
    return data;
  }
}
