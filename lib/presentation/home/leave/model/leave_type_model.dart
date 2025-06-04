class LeaveTypeModel {
  String? leaveTypeCode;
  String? leaveTypeName;

  LeaveTypeModel({
    this.leaveTypeCode,
    this.leaveTypeName
  });

  LeaveTypeModel.fromJson(Map<String, dynamic> json){
    leaveTypeCode = json["LeaveTypeCode"];
    leaveTypeName = json["LeaveTypeName"];
  }
 
}
