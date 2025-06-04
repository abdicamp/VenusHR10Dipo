import 'dart:convert';

class AuthResponseDetailModel {
  String? employeeID;
  String? employeeName;
  String? subBusCode;
  String? privateMobile;
  String? nik;
  String? homeAdr;
  String? position;

  AuthResponseDetailModel({
    this.employeeID,
    this.employeeName,
    this.privateMobile,
    this.nik,
    this.homeAdr,
    this.position,
  });

  AuthResponseDetailModel.fromJson(Map<String, dynamic> json) {
    employeeID = json["EmployeeID"];
    subBusCode = json["SubBusCode"];
    employeeName = json["EmployeeName"];
    privateMobile = json["PrivateMobile"];
    nik = json["NIK"];
    homeAdr = json["HomeAdr"];
    position = json["Position"];
  }

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() => {
        "EmployeeID": employeeID,
        "SubBusCode": subBusCode,
        "EmployeeName": employeeName,
        "PrivateMobile": privateMobile,
        "NIK": nik,
        "HomeAdr": homeAdr,
        "Position": position,
      };
}
