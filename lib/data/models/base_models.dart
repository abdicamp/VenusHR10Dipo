class ListModels {
  String? Position;
  String? AppRequest;
  String? Division;
  String? Section;
  num? SalaryPeriode;
  String? SubBusCode;
  String? LevelCode;
  num? Level;
  String? LevelAuth;
  String? type;
  String? typeCode;
  String? Requester;
  bool? OffDay;
  String? OffDay2;
  String? HolidayDate;
  String? AppStatus;
  bool? Holiday;

  bool? WorkDay;
  String? busCode;
  String? UserId;
  bool? IsSuspend;
  String? MobileLoginID;
  String? MobileDeviceID;
  String? CLAIMDate;
  String? VoucherDate;
  String? Approver;
  String? ImgPath;
  String? Periode;
  num? Duration;
  num? OTTimeDuration;
  String? OTNumber;
  String? UserCreated;
  String? TimeCreated;
  String? DateCreated;
  num? ClaimAmount;
  num? Presence;
  num? Permission;
  num? Leave;
  num? Cuti;
  num? Outstanding;
  int? ImageId;
  String? CLAIMNumber;
  num? Saldo;
  num? LVDay;
  String? TADate;
  String? EmployeeName;
  String? Checkin;
  String? CheckOut;
  String? AppDate;
  String? taPeriode;
  String? LOANNumber;
  String? PaymentStarDate;
  int? taDetailNumber;
  String? nik;
  String? EditAuthority;
  String? inOut;
  String? dateTimeCheck;
  String? latLang;
  String? location;
  String? UserName;
  String? UserNam;
  String? BusCode;
  String? EmployeeID;
  String? Coordinates;
  String? PrnAuthority;
  String? AbsNumber;
  String? ClaimTypeCode;
  String? VoucherNo;
  String? ClaimTypeName;
  String? PYAdditionCompCode;
  String? LeaveTypeCode;
  String? LeaveTypeName;
  String? LVNumber;
  String? OTTypeCode;
  String? OTStart;
  String? OTFinish;
  String? OTDate;
  String? Description;
  String? OTTypeName;
  String? TranNo;
  String? TranName;
  String? TranType;
  String? FromDate;
  String? ToDate;
  String? Reason;
  String? LVReason;
  String? LVDuration;
  String? ApprovedByID;
  String? AbsType;
  String? AbsReason;
  String? ApprovedBy;
  String? ApprovedByName;
  String? AppTenor;
  String? Notes;
  String? LOANTypeCode;
  String? LOANTypeName;
  String? LoanTypeCode;
  String? LoanTypeName;
  int? LoanAmount;
  num? MonthlyPayment;
  int? Tenor;

  ListModels(
      {this.type,
      this.typeCode,
      this.Position,
      this.Division,
      this.Coordinates,
      this.Section,
      this.AppStatus,
      this.SalaryPeriode,
      this.SubBusCode,
      this.LevelCode,
      this.Level,
      this.LevelAuth,
      this.busCode,
      this.AppRequest,
      this.OTNumber,
      this.ImgPath,
      this.Requester,
      this.ImageId,
      this.Outstanding,
      this.TADate,
      this.Periode,
      this.Duration,
      this.CLAIMNumber,
      this.EmployeeName,
      this.Checkin,
      this.CheckOut,
      this.IsSuspend,
      this.VoucherDate,
      this.ClaimAmount,
      this.Saldo,
      this.Cuti,
      this.ApprovedBy,
      this.MobileLoginID,
      this.MobileDeviceID,
      this.TimeCreated,
      this.DateCreated,
      this.UserCreated,
      this.CLAIMDate,
      this.Presence,
      this.Permission,
      this.Leave,
      this.LOANTypeName,
      this.VoucherNo,
      this.AppTenor,
      this.AbsReason,
      this.taPeriode,
      this.taDetailNumber,
      this.LoanTypeCode,
      this.LoanTypeName,
      this.nik,
      this.LOANNumber,
      this.PaymentStarDate,
      this.LOANTypeCode,
      this.EditAuthority,
      this.inOut,
      this.PrnAuthority,
      this.AppDate,
      this.UserId,
      this.dateTimeCheck,
      this.latLang,
      this.BusCode,
      this.Tenor,
      this.EmployeeID,
      this.UserName,
      this.AbsNumber,
      this.ClaimTypeCode,
      this.ClaimTypeName,
      this.PYAdditionCompCode,
      this.LeaveTypeCode,
      this.LeaveTypeName,
      this.OTTypeCode,
      this.OTTypeName,
      this.OffDay,
      this.OffDay2,
      this.MonthlyPayment,
      this.TranNo,
      this.TranName,
      this.TranType,
      this.UserNam,
      this.FromDate,
      this.ToDate,
      this.Reason,
      this.AbsType,
      this.LoanAmount,
      this.LVNumber,
      this.LVReason,
      this.LVDuration,
      this.ApprovedByID,
      this.Notes,
      this.LVDay,
      this.ApprovedByName,
      this.location});

  ListModels.fromJson(Map<String, dynamic> json) {
    Position = json['Position'];
    Coordinates = json['Coordinates'];
    AppStatus = json['AppStatus'];
    Division = json['Division'];
    Section = json['Section'];
    SalaryPeriode = json['SalaryPeriode'];
    SubBusCode = json['SubBusCode'];
    LevelCode = json['LevelCode'];
    Level = json['Level'];
    LevelAuth = json['LevelAuth'];
    busCode = json['BusCode'];
    AppRequest = json['AppRequest'];
    OTDate = json['OTDate'];
    Description = json['Description'];
    OTStart = json['OTStart'];
    OTFinish = json['OTFinish'];
    Presence = json['Presence'];
    Approver = json['Approver'];
    OffDay = json['OffDay'];
    ApprovedBy = json['ApprovedBy'];
    HolidayDate = json['HolidayDate'];
    OffDay2 = json['OffDay2'];
    OTNumber = json['OTNumber'];
    Permission = json['Permission'];
    Leave = json['Leave'];
    IsSuspend = json['IsSuspend'];
    CLAIMDate = json['CLAIMDate'];
    ImageId = json['ImageId'];
    UserCreated = json['UserCreated'];
    ClaimAmount = json['ClaimAmount'];
    VoucherNo = json['VoucherNo'];
    Duration = json['Duration'];
    MobileLoginID = json['MobileLoginID'];
    MobileDeviceID = json['MobileDeviceID'];
    VoucherDate = json['VoucherDate'];
    Requester = json['Requester'];
    ImgPath = json['ImgPath'];
    TimeCreated = json['TimeCreated'];
    DateCreated = json['DateCreated'];
    PrnAuthority = json['PrnAuthority'];
    AppDate = json['AppDate'];
    Cuti = json['Cuti'];
    AppTenor = json['AppTenor'];
    TADate = json['TADate'];
    Outstanding = json['Outstanding'];
    Saldo = json['Saldo'];
    Periode = json['Periode'];
    EmployeeName = json['EmployeeName'];
    Checkin = json['Checkin'];
    CheckOut = json['CheckOut'];
    UserId = json['UserId'];
    LVDay = json['LVDay'];
    CLAIMNumber = json['CLAIMNumber'];
    EditAuthority = json['EditAuthority'];
    PaymentStarDate = json['PaymentStarDate'];
    Tenor = json['Tenor'];
    LOANNumber = json['LOANNumber'];
    LOANTypeName = json['LOANTypeName'];
    AbsReason = json['AbsReason'];
    taPeriode = json['TAPeriode'];
    taDetailNumber = json['TADetailNumber'];
    nik = json['NIK'];
    Notes = json['Notes'];
    UserNam = json['UserNam'];
    LoanTypeCode = json['LoanTypeCode'];
    LoanTypeName = json['LoanTypeName'];
    inOut = json['InOut'];
    MonthlyPayment = json['MonthlyPayment'];
    dateTimeCheck = json['DateTimeCheck'];
    latLang = json['LatLang'];
    location = json['Location'];
    UserName = json['UserName'];
    BusCode = json['BusCode'];
    LoanAmount = json['LoanAmount'];
    EmployeeID = json['EmployeeID'];
    AbsNumber = json['AbsNumber'];
    ClaimTypeCode = json['ClaimTypeCode'];
    ClaimTypeName = json['ClaimTypeName'];
    PYAdditionCompCode = json['PYAdditionCompCode'];
    LeaveTypeCode = json['LeaveTypeCode'];
    LeaveTypeName = json['LeaveTypeName'];
    OTTypeCode = json['OTTypeCode'];
    OTTypeName = json['OTTypeName'];
    LVNumber = json['LVNumber'];
    TranNo = json['TranNo'];
    TranName = json['TranName'];
    TranType = json['TranType'];
    FromDate = json['FromDate'];
    ToDate = json['ToDate'];
    Reason = json['Reason'];
    AbsType = json['AbsType'];
    LVDuration = json['LVDuration'];
    ApprovedByID = json['ApprovedByID'];
    LVReason = json['LVReason'];
    LOANTypeCode = json['LOANTypeCode'];
    ApprovedByName = json['ApprovedByName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['busCode'] = this.busCode;
    data['Description'] = this.Description;
    data['OTDate'] = this.OTDate;
    data['Coordinates'] = this.Coordinates;
    data['ImageId'] = this.ImageId;
    data['OTStart'] = this.OTStart;
    data['OTFinish'] = this.OTFinish;
    data['Saldo'] = this.Saldo;
    data['ApprovedBy'] = this.ApprovedBy;
    data['OTNumber'] = this.OTNumber;
    data['Requester'] = this.Requester;
    data['Presence'] = this.Presence;
    data['Permission'] = this.Permission;
    data['Leave'] = this.Leave;
    data['ImgPath'] = this.ImgPath;
    data['AppRequest'] = this.AppRequest;
    data['CLAIMNumber'] = this.CLAIMNumber;
    data['AppDate'] = this.AppDate;
    data['VoucherDate'] = this.VoucherDate;
    data['CLAIMDate'] = this.CLAIMDate;
    data['IsSuspend'] = this.IsSuspend;
    data['Duration'] = this.Duration;
    data['ClaimAmount'] = this.ClaimAmount;
    data['LOANNumber'] = this.LOANNumber;
    data['AppTenor'] = this.AppTenor;
    data['Periode'] = this.Periode;
    data['LVDay'] = this.LVDay;
    data['UserCreated'] = this.UserCreated;
    data['PrnAuthority'] = this.PrnAuthority;
    data['PaymentStarDate'] = this.PaymentStarDate;
    data['taPeriode'] = this.taPeriode;
    data['Cuti'] = this.Cuti;
    data['VoucherNo'] = this.VoucherNo;
    data['EditAuthority'] = this.EditAuthority;
    data['AbsReason'] = this.AbsReason;
    data['UserNam'] = this.UserNam;
    data['taDetailNumber'] = this.taDetailNumber;
    data['nik'] = this.nik;
    data['Tenor'] = this.Tenor;
    data['LOANTypeCode'] = this.LOANTypeCode;
    data['Notes'] = this.Notes;
    data['inOut'] = this.inOut;
    data['TADate'] = this.TADate;
    data['EmployeeName'] = this.EmployeeName;
    data['Checkin'] = this.Checkin;
    data['CheckOut'] = this.CheckOut;
    data['UserId'] = this.UserId;
    data['LoanTypeCode'] = this.LoanTypeCode;
    data['LoanTypeName'] = this.LoanTypeName;
    data['LoanAmount'] = this.LoanAmount;
    data['dateTimeCheck'] = this.dateTimeCheck;
    data['latLang'] = this.latLang;
    data['ApprovedBy'] = this.ApprovedBy;
    data['LOANTypeName'] = this.LOANTypeName;
    data['location'] = this.location;
    data['UserName'] = this.UserName;
    data['BusCode'] = this.BusCode;
    data['AbsNumber'] = this.AbsNumber;
    data['EmployeeID'] = this.EmployeeID;
    data['MonthlyPayment'] = this.MonthlyPayment;
    data['ClaimTypeCode'] = this.ClaimTypeCode;
    data['ClaimTypeName'] = this.ClaimTypeName;
    data['PYAdditionCompCode'] = this.PYAdditionCompCode;
    data['LeaveTypeCode'] = this.LeaveTypeCode;
    data['LeaveTypeName'] = this.LeaveTypeName;
    data['LVNumber'] = this.LVNumber;
    data['OTTypeCode'] = this.OTTypeCode;
    data['OTTypeName'] = this.OTTypeName;
    data['TranNo'] = this.TranNo;
    data['TranName'] = this.TranName;
    data['TranType'] = this.TranType;
    data['FromDate'] = this.FromDate;
    data['ToDate'] = this.ToDate;
    data['Reason'] = this.Reason;
    data['AbsType'] = this.AbsType;
    data['LVReason'] = this.LVReason;
    data['LVDuration'] = this.LVDuration;
    data['ApprovedByID'] = this.ApprovedByID;
    data['ApprovedByName'] = this.ApprovedByName;
    return data;
  }
}
