import 'dart:convert';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timeline_calendar/timeline/widget/day.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:venushr_10_dipo_mobile/presentation/home/absen_result.dart';
import '../../core/constants/variables.dart';
import '../../presentation/auth/model/auth_detail_user.dart';
import '../../presentation/auth/model/auth_response_model.dart';
import '../get_version/get_version.dart';
import 'auth_local_datasource.dart';
import 'package:http_parser/http_parser.dart';

class AuthRemoteDatasource {
  Future<Either<String, AuthResponseModel>> login(
      String username, String password, String? deviceId) async {
    final url = Uri.parse(
        '${Variables.baseUrl}/getUser/VenusHR10Key/${username}/${password}');
    final response = await http.get(url);
    String? statusCode = response.statusCode.toString();
    final getVersion = GetVersion();
    final result = await getVersion.getCekVersions();

    if (result == false) {
      return Left("Version apps not compatible");
    } else {
      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);

        if (jsonResponse.isNotEmpty) {
          if (jsonResponse[0]['MobileLoginID'] == null ||
              jsonResponse[0]['MobileLoginID'] == "") {
            return Right(AuthResponseModel.fromJson(jsonResponse[0]));
          } else {
            if (jsonResponse[0]['MobileLoginID'] == deviceId) {
              return Right(AuthResponseModel.fromJson(jsonResponse[0]));
            }
            return const Left('Akun anda sedang di gunakan');
          }
        } else {
          return const Left('Username atau Password Salah');
        }
      } else {
        return Left('Failed to login | $statusCode ');
      }
    }
  }

  Future<Either<String, AuthResponseDetailModel>> dataUserDetail() async {
    final prefUser = await AuthLocalDatasource().getAuthData();
    final url = Uri.parse(
        '${Variables.baseUrl}/getDataEmployee/${prefUser?.employeeID}');
    final response = await http.get(url);
    String? statusCode = response.statusCode.toString();

    print("status Code : ${prefUser?.employeeID}");

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      print("jsonResponse detail : ${jsonResponse}");

      if (jsonResponse.isNotEmpty) {
        return Right(AuthResponseDetailModel.fromJson(jsonResponse[0]));
      } else {
        return const Left('Failed Read Data');
      }
    } else {
      return Left('Failed Read Data | $statusCode ');
    }
  }

  Future<Either<String, AuthResponseModel>> getDataBuscode() async {
    final prefUser = await AuthLocalDatasource().getAuthData();
    final url = Uri.parse(
        '${Variables.baseUrl}/getDataBusCode/${prefUser?.employeeID}');
    final response = await http.get(url);
    String? statusCode = response.statusCode.toString();

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);

      return Right(AuthResponseModel.fromJson(jsonResponse[0]));
    } else {
      return Left('Failed to login | $statusCode ');
    }
  }

  Future<Either<String, List<dynamic>>> location() async {
    final prefEmployee = await AuthLocalDatasource().getAuthData();
    final url = Uri.parse(
        '${Variables.baseUrl}/getDataMAssignMentLocation/${prefEmployee?.employeeID}');
    final response = await http.get(url);
    String? statusCode = response.statusCode.toString();
    print("statusCode Location : ${response.body}");

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return Right(jsonResponse);
    } else {
      return Left('Failed to Load Location | $statusCode ');
    }
  }

  Future<Either<String, AuthResponseModel>> updateDevice(
      AuthResponseModel data, String? deviceId) async {
    try {
      final updatedData = data.copyWith(
        employeeID: data.employeeID,
        mobileLoginID: deviceId,
      );

      final Map<String, String> headers = {
        'Content-Type': 'application/json; charset=UTF-8',
      };

      final url = Uri.parse('${Variables.baseUrl}/updateDeviceID');
      final response =
          await http.patch(url, body: updatedData.toJson(), headers: headers);

      String? statusCode = response.statusCode.toString();
      print("statusCode Update : ${statusCode} , ${updatedData.toJson()}");

      if (response.statusCode == 200) {
        return Right(updatedData);
      } else {
        return Left('Failed to Load Location | $statusCode ');
      }
    } catch (e) {
      return Left('Failed to Load Location | $e ');
    }
  }

  Future<Either<String, List<dynamic>>> getLeaveType() async {
    final url = Uri.parse('${Variables.baseUrl}/getLeaveType');
    final response = await http.get(url);
    String? statusCode = response.statusCode.toString();

    if (response.statusCode == 200) {
      // List<Map<String , dynamic>> listJson = jsonDecode(response.body);
      List<dynamic> jsonResponse = json.decode(response.body);

      return Right(jsonResponse);
    } else {
      return Left('Failed to Load Location | $statusCode ');
    }
  }

  Future<Either<String, List<dynamic>>> getDateHoliday() async {
    final url = Uri.parse('${Variables.baseUrl}/getDateHoliday');
    final response = await http.get(url);
    String? statusCode = response.statusCode.toString();

    if (response.statusCode == 200) {
      // List<Map<String , dynamic>> listJson = jsonDecode(response.body);
      List<dynamic> jsonResponse = json.decode(response.body);

      return Right(jsonResponse);
    } else {
      return Left('Failed to Load Location | $statusCode ');
    }
  }

  Future<Either<String, List<dynamic>>> getClaimType() async {
    final url = Uri.parse('${Variables.baseUrl}/getClaimType');
    final response = await http.get(url);
    String? statusCode = response.statusCode.toString();

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);

      return Right(jsonResponse);
    } else {
      return Left('Failed to Load Claim Type | $statusCode ');
    }
  }

  Future<Either<String, List<dynamic>>> getApprover() async {
    final prefUser = await AuthLocalDatasource().getAuthData();
    final url = Uri.parse(
        '${Variables.baseUrl}/getApprover/${prefUser?.busCode}/${prefUser?.employeeID}');
    final response = await http.get(url);
    String? statusCode = response.statusCode.toString();

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);

      return Right(jsonResponse);
    } else {
      return Left('Failed to Load Data | $statusCode ');
    }
  }

  Future<AbsenResult> postLeave(
    String leaveType,
    String leaveDuration,
    String? fromDate,
    String? toDate,
    String? reason,
    String? appRequest,
  ) async {
    try {
      DateTime dateTime = DateTime.now();
      final prefUser = await AuthLocalDatasource().getAuthData();
      final prefUserSub = await AuthLocalDatasource().getAuthDataDetail();

      final responseMonthlyPeriode = await http.get(Uri.parse(
          "${Variables.baseUrl}/getMonthlyPeriode/${prefUser?.busCode}/${DateFormat('yyyy-MM-dd').format(dateTime)}/${DateFormat('yyyy-MM-dd').format(dateTime)}"));
      final urlPost = Uri.parse('${Variables.baseUrl}/postLeave');

      String formatDate = DateFormat('yyyy-MM-dd 00:00:00').format(dateTime);
      String years = DateFormat('yyyy').format(dateTime);
      DateTime parseToDateTime = DateFormat('yyyy-MM-dd').parse(toDate!);
      DateTime parseFromDateTime = DateFormat('yyyy-MM-dd').parse(fromDate!);

      String? lastString = "";
      int? angkaLast;
      int? jumlah;
      double durasiHari;
      String? getPeriode;

      if (responseMonthlyPeriode.statusCode == 200) {
        getPeriode = jsonDecode(responseMonthlyPeriode.body)[0]['Periode'];
        print("getPeriode : ${getPeriode}");
      }

      final url = Uri.parse('${Variables.baseUrl}/getLeave/${getPeriode}');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> dataJson = jsonDecode(response.body);

        if (dataJson.isNotEmpty) {
          lastString = "${dataJson[0]['LVNumber']}";
          angkaLast = int.tryParse(lastString.split('/').last);
          print("angka last data json Is Not Empty ${angkaLast}");
          jumlah = angkaLast! + 1;
        } else {
          lastString = "1/000";
          angkaLast = int.tryParse(lastString.split('/').last);
          print("angka last data json Is Empty ${angkaLast}");
          jumlah = angkaLast! + 1;
        }
      }

      if (leaveDuration.contains('Half Day Leave')) {
        durasiHari = (0.5 *
                (parseToDateTime.difference(parseFromDateTime).inDays + 1)
                    .toInt())
            .toDouble();
      } else {
        durasiHari = parseToDateTime.difference(parseFromDateTime).inDays + 1;
      }

      final Map<String, dynamic> data = {
        "BusCode": "${prefUser?.busCode}",
        "SubBusCode": "${prefUserSub?.subBusCode}",
        "LVNumber":
            "LV/${prefUser?.busCode}/${getPeriode}/${jumlah.toString().padLeft(4, '0')}",
        "Periode": "${getPeriode}",
        "EmployeeID": "${prefUser?.employeeID}",
        "ApprovedBy": "",
        "LeaveTypeCode": "${leaveType}",
        "LVReason": "${reason}",
        "NoticedDate": "${formatDate}",
        "LVDuration": "${leaveDuration}",
        "FromDate": "${parseFromDateTime.toString().substring(0, 19)}",
        "ToDate": "${parseToDateTime.toString().substring(0, 19)}",
        "Description": "${reason}",
        "LVDay": durasiHari,
        "AppDate": "",
        "AppRequest": "",
        "IsSuspend": "0",
        "AppStatus": "",
        "LeaveYear": "${years}",
        "Payment": "False",
        "UserCreated": "${prefUser?.userId}",
        "DateCreated": "${DateFormat('yyyy-MM-dd 00:00:00').format(dateTime)}",
        "TimeCreated": "${DateFormat('kkmmss').format(dateTime)}",
        "UserModified": "",
        "DateModified": "",
        "TimeModified": "",
      };

      final Map<String, String> headers = {
        'Content-Type': 'application/json; charset=UTF-8',
      };

      print('data json not empty half day : ${data}');
      final responsePost = await http.post(
        urlPost,
        body: jsonEncode(data),
        headers: headers,
      );

      print("status code ${leaveDuration} : ${responsePost.statusCode} ");

      if (responsePost.statusCode == 201) {
        return AbsenResult(true, message: 'Sukses Post Leave');
      } else {
        return AbsenResult(false, message: 'Failed Post Leave');
      }
    } catch (e) {
      print("error post Leave ${e}");

      return AbsenResult(false, message: '${e}');
    }
  }

  Future<AbsenResult> postAbsen(String? typeAbsen, String? dataImage,
      String? latitude, String? address, num? getTimeZone) async {
    try {
      String? getPeriode;
      int? lastNumber;
      DateTime dateTime = DateTime.now();
      final getUser = await AuthLocalDatasource().getAuthData();

      final responseMonthlyPeriode = await http.get(Uri.parse(
          "${Variables.baseUrl}/getMonthlyPeriode/${getUser?.busCode}/${DateFormat('yyyy-MM-dd').format(dateTime)}/${DateFormat('yyyy-MM-dd').format(dateTime)}"));

      if (responseMonthlyPeriode.statusCode == 200) {
        List<dynamic> listdata = jsonDecode(responseMonthlyPeriode.body);

        if (listdata.isEmpty) {
          return AbsenResult(false, message: 'Periode Is Invalid');
        } else {
          getPeriode = listdata[0]['Periode'];
        }
      }

      final responseGetAbsenUser = await http.get(Uri.parse(
          "${Variables.baseUrl}/getAbsen/${getUser?.busCode}/${getPeriode}/${getUser?.employeeID}"));

      if (responseGetAbsenUser.statusCode == 200) {
        List<dynamic> listDAta = jsonDecode(responseGetAbsenUser.body);

        lastNumber = listDAta.isEmpty ? 1 : listDAta[0]['TADetailNumber'] + 1;
      }

      if (address == "" || address == null) {
        return AbsenResult(false,
            message: "Location Null , Please Refresh Aplication");
      }

      if (getTimeZone == null || getTimeZone == 'Null') {
        return AbsenResult(false, message: "Your Time Zone not yet set");
      }

      final Map<String, dynamic> dataJson = {
        "BusCode": "${getUser?.busCode}",
        "TAPeriode": "${getPeriode}",
        "TADetailNumber": "${lastNumber}",
        "EmployeeId": "${getUser?.employeeID}",
        "InOut": "${typeAbsen}",
        "LatLang": "${latitude}",
        "Location": "${address}",
        "TimeZone": getTimeZone,
      };

      final Map<String, String> headers = {
        'Content-Type': 'application/json; charset=UTF-8',
      };

      print('data json not empty half day : ${dataJson}');
      final responsePost = await http.post(
        Uri.parse("${Variables.baseUrl}/postDataAbsen"),
        body: jsonEncode(dataJson),
        headers: headers,
      );

      print("status code post : ${responsePost.statusCode}");

      if (responsePost.statusCode == 201) {
        return AbsenResult(true, message: "Absen Sukses");
      } else {
        return AbsenResult(false, message: "Gagal Absen");
      }
    } catch (e) {
      return AbsenResult(false, message: "Gagal Absen");
    }
  }

  Future<Either<String, String>> postClaim(
    String? claimType,
    String? claimAmount,
    String? claimVoucherNo,
    String? claimDate,
    String? appRequest,
    List<File>? listImage,
  ) async {
    try {
      final prefUser = await AuthLocalDatasource().getAuthData();
      final url = Uri.parse('${Variables.baseUrl}/getDataClaim');
      final urlPost = Uri.parse('${Variables.baseUrl}/postClaims');
      final response = await http.get(url);

      DateTime dateTime = DateTime.now();
      String periode = DateFormat('yyyyMM').format(dateTime);

      String? lastString = "";
      int? angkaLast;

      if (response.statusCode == 200) {
        List<dynamic> dataJson = jsonDecode(response.body);

        if (dataJson.isNotEmpty) {
          lastString = "${dataJson[0]['CLAIMNumber']}";
          angkaLast = int.tryParse(lastString.split('/').last);
          jumlah = angkaLast! + 1;
        } else {
          lastString = "1/000";
          angkaLast = int.tryParse(lastString.split('/').last);
          jumlah = angkaLast! + 1;
        }
      }

      final Map<String, dynamic> data = {
        "BusCode": "${prefUser?.busCode}",
        "CLAIMNumber":
            "CLM/${prefUser?.busCode}/${periode}/${lastString.toString().padLeft(3, '0')}",
        "CLAIMPeriode": "${periode}",
        "CLAIMDate": "${claimDate}",
        "EmployeeID": "${prefUser?.employeeID}",
        "ClaimTypeCode": "${claimType}",
        "ClaimAmount": "${claimAmount}",
        "VoucherNo": "${claimVoucherNo}",
        "VoucherDate": "${claimVoucherNo}",
        "Description": "",
        "ApprovedBy": "",
        "AppRequest": "${appRequest}",
        "AppDate": "",
        "AppStatus": "",
        "AppDescription": "",
        "UserCreated": "${prefUser?.userId}",
        "DateCreated": "${DateFormat('yyyy-MM-dd 00:00:00').format(dateTime)}",
        "TimeCreated": "${DateFormat('kkmmss').format(dateTime)}",
        "UserModified": "",
        "DateModified": "",
        "TimeModified": "",
      };

      final Map<String, String> headers = {
        'Content-Type': 'application/json; charset=UTF-8',
      };

      print('data json not empty half day : ${data}');
      final responsePost = await http.post(
        urlPost,
        body: jsonEncode(data),
        headers: headers,
      );

      if (responsePost.statusCode == 201) {
        return const Right('Sukses Post Leave');
      } else {
        return Left("Failed Post Leave");
      }
    } catch (e) {
      print("error ${e}");
      return Left("error");
    }
  }

  Future<Either<String, List<dynamic>>> getAttendanceLog(
      String selectedDate) async {
    try {
      final getUser = await AuthLocalDatasource().getAuthData();
      DateTime dateTimeNow = DateTime.now();
      DateTime lastMonth =
          DateTime(dateTimeNow.year, dateTimeNow.month - 1, dateTimeNow.day);

      String? dateFrom = DateFormat('yyyy-MM-dd 00:00:00').format(lastMonth);

      final response = await http.get(Uri.parse(
          "${Variables.baseUrl}/getListAttendanceLog/${getUser?.employeeID}/${dateFrom}/${selectedDate}"));
      print(
          "${Variables.baseUrl}/getListAttendanceLog/${getUser?.employeeID}/${dateFrom}/${selectedDate}");
      if (response.statusCode == 200) {
        List<dynamic> listdata = jsonDecode(response.body);

        return Right(listdata);
      }

      return Left("Status : ${response.statusCode}");
    } catch (e) {
      return Left("Error : ${e}");
    }
  }

  Future<Either<String, List<dynamic>>> getReqHistory(
    String? dateFrom,
    String? dateTo,
    String? historyType,
  ) async {
    try {
      final getUser = await AuthLocalDatasource().getAuthData();

      Map<String, dynamic> data = {
        "employee": "${getUser?.employeeID}",
        "date1": "${dateFrom}",
        "date2": "${dateTo}",
        "status": "${historyType}"
      };

      final Map<String, String> headers = {
        'Content-Type': 'application/json; charset=UTF-8',
      };

      final response = await http.post(
        Uri.parse("${Variables.baseUrl}/getListHRReqHistory"),
        body: jsonEncode(data),
        headers: headers,
      );

      if (response.statusCode == 200) {
        List<dynamic> listdata = jsonDecode(response.body);

        return Right(listdata);
      }

      return Left("Status : ${response.statusCode}");
    } catch (e) {
      return Left("Error : ${e}");
    }
  }

  Future<Either<String, List<dynamic>>> getListMyRequest() async {
    try {
      final getUser = await AuthLocalDatasource().getAuthData();

      final response = await http.get(Uri.parse(
          "${Variables.baseUrl}/getListMyRequest/${getUser?.employeeID}"));
      print("status Code My Request : ${response.statusCode}");
      if (response.statusCode == 200) {
        List<dynamic> listdata = jsonDecode(response.body);

        return Right(listdata);
      }

      return Left("Status : ${response.statusCode}");
    } catch (e) {
      return Left("Error : ${e}");
    }
  }

  Future<Either<String, List<dynamic>>> getListApprovelRequest() async {
    try {
      final getUser = await AuthLocalDatasource().getAuthData();

      final response = await http.get(Uri.parse(
          "${Variables.baseUrl}/getListAppRequest/${getUser?.employeeID}"));
      print("Status Approvel Request : ${response.statusCode}");

      if (response.statusCode == 200) {
        List<dynamic> listdata = jsonDecode(response.body);

        return Right(listdata);
      }

      return Left("Status Approvel Request : ${response.statusCode}");
    } catch (e) {
      return Left("Error : ${e}");
    }
  }

  Future<Either<String, List<dynamic>>> getListRequest() async {
    try {
      final getUser = await AuthLocalDatasource().getAuthData();

      final response = await http.get(Uri.parse(
          "${Variables.baseUrl}/getListRequest/${getUser?.employeeID}"));
      print("status Code List Request : ${response.statusCode}");
      if (response.statusCode == 200) {
        List<dynamic> listdata = jsonDecode(response.body);

        return Right(listdata);
      }

      return Left("Status : ${response.statusCode}");
    } catch (e) {
      return Left("Error : ${e}");
    }
  }

  Future<Either<String, List<dynamic>>> getListDataLeaveUser(
      String? tranNo, String? employeeId) async {
    try {
      final prefUser = await AuthLocalDatasource().getAuthData();
      DateTime dateTime = DateTime.now();
      final responseMonthlyPeriode = await http.get(Uri.parse(
          "${Variables.baseUrl}/getMonthlyPeriode/${prefUser?.busCode}/${DateFormat('yyyy-MM-dd').format(dateTime)}/${DateFormat('yyyy-MM-dd').format(dateTime)}"));

      String? getPeriode;

      if (responseMonthlyPeriode.statusCode == 200) {
        getPeriode = jsonDecode(responseMonthlyPeriode.body)[0]['Periode'];
        print("getPeriode : ${getPeriode}");
      }

      final Map<String, String> headers = {
        'Content-Type': 'application/json; charset=UTF-8',
      };
      final Map<String, dynamic> data = {
        'tranNo': '${tranNo}',
        'employee': '${employeeId}'
      };

      final response = await http.post(
          Uri.parse("${Variables.baseUrl}/getListDataLeave"),
          headers: headers,
          body: jsonEncode(data));

      if (response.statusCode == 200) {
        List<dynamic> listdata = jsonDecode(response.body);

        for (var i in listdata) {
          final Map<String, dynamic> data = {
            "Periode": "${getPeriode}",
            "EmployeeID": "${i['EmployeeID']}",
            "LeaveTypeCode": "${i['LeaveTypeCode']}",
            "LeaveYear": "${i['LeaveYear']}",
            "RefNumber": "${i['LVNumber']}",
            "RefDate": "${DateFormat('yyyy-MM-dd 00:00:00').format(dateTime)}",
            "BusCode": "${i['BusCode']}",
            "Incoming": 0,
            "Outgoing": i['LVDay'],
          };

          final Map<String, String> headers = {
            'Content-Type': 'application/json; charset=UTF-8',
          };

          final response = await http.post(
            Uri.parse("${Variables.baseUrl}/postHLeave"),
            headers: headers,
            body: jsonEncode(data),
          );

          if (response.statusCode == 201) {
            print("Sukses Upload Histoy ${response.statusCode}");
          } else {
            print("Gagal Upload History : ${response.statusCode}");
          }
        }
      }

      return Left("Status : ${response.statusCode}");
    } catch (e) {
      print("error list data leave : ${e}");
      return Left("Error : ${e}");
    }
  }

  Future<Either<String, String>> updateRequest(
      String employeeId, String tranNo, String tranName, String status) async {
    try {
      final getPrefUser = await AuthLocalDatasource().getAuthData();
      DateTime dateTime = DateTime.now();

      String? endPoint;
      String? tranNumber;
      String? enpointCancel;

      if (tranName == "Permission") {
        endPoint = "updatePermission";
        tranNumber = "AbsNumber";
      } else if (tranName == "Leave") {
        endPoint = "updateLeave";
        tranNumber = "LVNumber";
        enpointCancel = "cancelReqLeave";
      } else if (tranName == "Loan") {
        endPoint = "updateLoan";
        tranNumber = "LOANNumber";
      } else if (tranName == "Overtime") {
        endPoint = "updateOvertime";
        tranNumber = "OTNumber";
      }

      if (status == "Cancel") {
        final Map<String, dynamic> data = {
          "${tranNumber}": "${tranNo}",
          "EmployeeID": "${employeeId}",
        };
        final Map<String, String> headers = {
          'Content-Type': 'application/json; charset=UTF-8',
        };

        final response = await http.post(
            Uri.parse("${Variables.baseUrl}/${enpointCancel}"),
            body: jsonEncode(data),
            headers: headers);

        if (response.statusCode == 200) {
          getListRequest();

          return Right("Success Cancle");
        } else {
          return Left("Error Cancel");
        }
      } else {
        final Map<String, dynamic> data = {
          "${tranNumber}": "${tranNo}",
          "EmployeeID": "${employeeId}",
          "ApprovedBy": "${getPrefUser?.employeeID}",
          "AppStatus": "${status}",
          "AppDate": "${DateFormat('yyyy-MM-dd 00:00:00').format(dateTime)}",
          "UserModified": "${getPrefUser?.userId}",
          "DateModified":
              "${DateFormat('yyyy-MM-dd 00:00:00').format(dateTime)}",
          "TimeModified": "${DateFormat('kkmmss').format(dateTime)}",
        };
        final Map<String, String> headers = {
          'Content-Type': 'application/json; charset=UTF-8',
        };

        final response = await http.patch(
            Uri.parse("${Variables.baseUrl}/${endPoint}"),
            body: jsonEncode(data),
            headers: headers);

        if (response.statusCode == 200) {
          if (status == "Approved") {
            getListDataLeaveUser(tranNo, employeeId);
          }
          getListRequest();

          return Right("Success Update");
        } else {
          return Left("Error Update");
        }
      }
    } catch (e) {
      return Left("Error Update ${e}");
    }
  }

  int? angkaLast;
  late int jumlah;

  Future<Either<String, String>> postAttendance(List<File> imageFiles) async {
    try {
      final prefUser = await AuthLocalDatasource().getAuthData();
      final url = Uri.parse('${Variables.baseUrl}/postImgAttendance');
      DateTime dateTime = DateTime.now();

      for (var i in imageFiles) {
        var request = http.MultipartRequest('POST', url);
        request.fields['TranIdx'] = "05003";
        request.fields['TranNumber'] =
            "ABS/${prefUser?.busCode}/${DateFormat('yyyyMM').format(dateTime)}/${angkaLast}";
        request.fields['ImageId'] = "${jumlah}";
        request.fields['FileName'] =
            "ABS${prefUser?.busCode}${DateFormat('yyyyMM').format(dateTime)}${angkaLast}${jumlah}";

        var file = await http.MultipartFile.fromBytes(
          'Attachment',
          File(i.path).readAsBytesSync(),
          filename: i.path,
          contentType: MediaType('image', 'jpeg'), // Sesuaikan tipe media file
        );

        request.files.add(file);

        print("notif request.fields : ${request.fields} }");
        print("notif request.files : ${request.files}");

        var response = await request.send();

        print("response attendance : ${response.stream.bytesToString()}");

        jumlah++;
      }

      return Right("");
    } catch (e) {
      return Left("Gagagl Post Attendance ${e}");
    }
  }

  Future<Either<String, String>> postPermission(
      String permissionType,
      String? fromDate,
      String? toDate,
      String? reason,
      String? appRequest,
      List<File>? listImage) async {
    try {
      final prefUser = await AuthLocalDatasource().getAuthData();
      final url = Uri.parse(
          '${Variables.baseUrl}/getPermission/${prefUser?.employeeID}');
      final urlPost = Uri.parse('${Variables.baseUrl}/postPermission');
      final response = await http.get(url);
      DateTime dateTime = DateTime.now();
      String formatDate = DateFormat('yyyy-MM-dd 00:00:00').format(dateTime);
      DateTime parseToDateTime = DateFormat('yyyy-MM-dd').parse(toDate!);
      DateTime parseFromDateTime = DateFormat('yyyy-MM-dd').parse(fromDate!);

      String? lastString = "";

      if (response.statusCode == 200) {
        List<dynamic> dataJson = jsonDecode(response.body);

        if (dataJson.isNotEmpty) {
          lastString = "${dataJson[0]['AbsNumber']}";
          angkaLast = int.tryParse(lastString.split('/').last);
          jumlah = angkaLast! + 1;
        } else {
          lastString = "1/000";
          angkaLast = int.tryParse(lastString.split('/').last);
          jumlah = angkaLast! + 1;
        }
      }

      final Map<String, dynamic> data = {
        "BusCode": "${prefUser?.busCode}",
        "AbsNumber":
            "ABS/${prefUser?.busCode}/${DateFormat('yyyyMM').format(dateTime)}/${jumlah.toString().padLeft(4, '0')}",
        "Periode": "${DateFormat('yyyyMM').format(dateTime)}",
        "EmployeeID": "${prefUser?.employeeID}",
        "ApprovedBy": "",
        "AbsType": "${permissionType}",
        "AbsReason": "${reason}",
        "NoticedDate": "${formatDate}",
        "FromDate": "${fromDate}",
        "ToDate": "${toDate}",
        "Description": "${response}",
        "Duration":
            "${parseToDateTime.difference(parseFromDateTime).inDays + 1}",
        "AppDescription": "",
        "AppRequest": "${appRequest}",
        "AppStatus": "",
        "UserCreated": "${prefUser?.userId}",
        "DateCreated": "${formatDate}",
        "TimeCreated": "${DateFormat('kkmmss').format(dateTime)}",
        "UserModified": "",
        "TimeModified": "",
      };

      final Map<String, String> headers = {
        'Content-Type': 'application/json; charset=UTF-8',
      };

      print('data json data Permission: ${data}');

      final responsePost = await http.post(
        urlPost,
        body: jsonEncode(data),
        headers: headers,
      );

      print("status code post permission : ${responsePost.statusCode} ");

      if (responsePost.statusCode == 201) {
        await postAttendance(listImage!);
        return const Right('Sukses Post Permission');
      } else {
        await postAttendance(listImage!);
        return Left("Failed Post Permission");
      }
    } catch (e) {
      print("error ${e}");
      return Left("error");
    }
  }

// Overtime
  Future<Either<String, List<dynamic>>> getOvertimeType() async {
    final url = Uri.parse('${Variables.baseUrl}/getOvertimeType');
    final response = await http.get(url);
    String? statusCode = response.statusCode.toString();

    if (response.statusCode == 200) {
      // List<Map<String , dynamic>> listJson = jsonDecode(response.body);
      List<dynamic> jsonResponse = json.decode(response.body);

      return Right(jsonResponse);
    } else {
      return Left('Failed to Load Location | $statusCode ');
    }
  }

  Future<Either<String, String>> postOvertime(
    TimeOfDay? selectedTime,
    TimeOfDay? selectedTime2,
    TextEditingController? overtimeDate,
    TextEditingController? timeFrom,
    TextEditingController? timeTo,
    String? selectOTTypeString,
    String? reason,
    String? appRequest,
  ) async {
    try {
      final prefUser = await AuthLocalDatasource().getAuthData();
      final urlPost = Uri.parse('${Variables.baseUrl}/postHOvertime');
      DateTime dateTime = DateTime.now();
      String? otindeks;

      final minutes1 = selectedTime!.hour * 60 + selectedTime.minute;
      final minutes2 = selectedTime2!.hour * 60 + selectedTime2.minute;

      final diffreneceInMinutes = (minutes2 - minutes1).abs();

      final hours = diffreneceInMinutes ~/ 60;
      final minutes = diffreneceInMinutes % 60;

      if (selectOTTypeString == 'NMI_HARIKERJA') {
        if (diffreneceInMinutes >= 60) {
          double indexForFirstHour = 1.5;
          int remainingMinutes = diffreneceInMinutes - 60;
          int intervals = remainingMinutes ~/ 30;
          double index = indexForFirstHour;
          otindeks = "${indexForFirstHour}";

          for (int i = 0; i < intervals; i++) {
            index += 1.0;
            otindeks = "${index}";
            printDataEvery30Minutes(index);
          }
        }
      } else {
        if (diffreneceInMinutes > 60) {
          double indexForFirstHour = 2.0;

          int remainingMinutes = diffreneceInMinutes - 60;
          int intervals = remainingMinutes ~/ 30;
          double index = indexForFirstHour;
          otindeks = "${indexForFirstHour}";
          for (int i = 0; i < intervals; i++) {
            index += 1.0;
            otindeks = "${index}";
            printDataEvery30Minutes(index);
          }
        }
      }

      if (diffreneceInMinutes < 60) {
        return Left("Jam Tidak Memenuhi Syarat");
      } else {
        final Map<String, dynamic> data = {
          "BusCode": "${prefUser?.busCode}",
          "OTNumber":
              "${prefUser?.employeeID}${DateFormat('yyyyMM').format(dateTime)}${overtimeDate?.text}",
          "OTPeriode": "${DateFormat('yyyyMM').format(dateTime)}",
          "OTDate": "${overtimeDate?.text}",
          "EmployeeID": "${prefUser?.employeeID}",
          "OTTypeCode": "${selectOTTypeString}",
          "OTStart": "${overtimeDate?.text} ${timeFrom?.text}",
          "OTFinish": "${overtimeDate?.text} ${timeTo?.text}",
          "OTBreak": "",
          "OTTimeDuration": "${diffreneceInMinutes}",
          "OTIndeks": "${otindeks}",
          "OTMeals": "0",
          "OTTransport": "0",
          "OTOther": "0",
          "Description": "${reason}",
          "ActualOTIndeks": "0",
          "ActualOTMeals": "0",
          "ActualOTTransport": "0",
          "DefaultOvertime": false,
          "AppRequest": "${appRequest}",
          "ApprovedBy": "",
          "OTHourDuration": "${hours}.${minutes}",
          "UserCreated": "${prefUser?.userId}",
          "DateCreated":
              "${DateFormat('yyyy-MM-dd 00:00:00').format(dateTime)}",
          "TimeCreated": "${DateFormat('kkmmss').format(dateTime)}",
          "UserModified": "",
          "DateModified": "",
          "TimeModified": ""
        };

        final Map<String, String> headers = {
          'Content-Type': 'application/json; charset=UTF-8',
        };

        print("data : ${data}");

        final response = await http.post(
          urlPost,
          headers: headers,
          body: jsonEncode(data),
        );

        if (response.statusCode == 201) {
          return Right("Sukses Post Overtime");
        } else {
          return Left("Gagal Post Overtime : ${response.statusCode}");
        }
      }
    } catch (e) {
      return Left("error ${e}");
    }
  }

  void printDataEvery30Minutes(double minutes) {}

  // Loan

  Future<Either<String, List<dynamic>>> getLoanType() async {
    final url = Uri.parse('${Variables.baseUrl}/getLoanType');
    final response = await http.get(url);
    String? statusCode = response.statusCode.toString();

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);

      return Right(jsonResponse);
    } else {
      return Left('Failed to Load Location | $statusCode ');
    }
  }

  Future<AbsenResult> getLeaveSaldo() async {
    final getUser = await AuthLocalDatasource().getAuthData();
    
    final url = Uri.parse(
        '${Variables.baseUrl}/getListLeaveSaldo/${getUser?.employeeID}');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      print("json response : ${jsonResponse}");

      return AbsenResult(true, data: jsonResponse);
    } else {
      return AbsenResult(false, data: []);
    }
  }

  Future<Either<String, List<dynamic>>> getLoanSaldo() async {
    final getUser = await AuthLocalDatasource().getAuthData();
    final url = Uri.parse(
        '${Variables.baseUrl}/getListDataLoanSaldo/${getUser?.busCode}/${getUser?.employeeID}');
    final response = await http.get(url);
    String? statusCode = response.statusCode.toString();

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      print("json response : ${jsonResponse}");

      return Right(jsonResponse);
    } else {
      return Left('Failed to Load Saldo Leave | $statusCode ');
    }
  }

  Future<Either<String, String>> postLoan(
    String? loanType,
    String? loanDate,
    String? loanAmount,
    String? loanTenor,
    double? loanHasil,
    String? loanApprovel,
  ) async {
    try {
      final prefUser = await AuthLocalDatasource().getAuthData();
      final url = Uri.parse('${Variables.baseUrl}/getLoan');
      final urlPost = Uri.parse('${Variables.baseUrl}/postLoan');
      final response = await http.get(url);
      DateTime dateTime = DateTime.now();
      String periode = DateFormat('yyyyMM').format(dateTime);

      String? lastString = "";
      int? angkaLast;
      int? jumlah;

      if (response.statusCode == 200) {
        List<dynamic> dataJson = jsonDecode(response.body);

        if (dataJson.isNotEmpty) {
          lastString = "${dataJson[0]['LOANNumber']}";
          angkaLast = int.tryParse(lastString.split('/').last);
          jumlah = angkaLast! + 1;
        } else {
          lastString = "1/000";
          angkaLast = int.tryParse(lastString.split('/').last);
          jumlah = angkaLast! + 1;
        }
      }

      final Map<String, dynamic> data = {
        "BusCode": "${prefUser?.busCode}",
        "LOANNumber":
            "LN/${prefUser?.busCode}/${periode}/${jumlah.toString().padLeft(4, '0')}",
        "LOANPeriode": "${periode}",
        "LOANDate": "${loanDate}",
        "EmployeeID": "${prefUser?.employeeID}",
        "LOANTypeCode": "${loanType}",
        "LoanAmount": "${int.parse(loanAmount!.toString())}",
        "Tenor": "${loanTenor}",
        "MonthlyPayment": loanHasil,
        "PaymentStarDate": "${loanDate}",
        "PaymentStarPeriode":
            "${DateFormat('yyyyMM').format(DateTime.parse(loanDate!))}",
        "Description": "",
        "ApprovedBy": "",
        "AppRequest": "${loanApprovel}",
        "UserCreated": "${prefUser!.userId}",
        "DateCreated": "${DateFormat('yyyy-MM-dd').format(dateTime)} 00:00:00",
        "TimeCreated": "${DateFormat('kkmmss').format(dateTime)}",
        "UserModified": "",
        "DateModified": "",
        "TimeModified": "",
      };
      final Map<String, String> headers = {
        'Content-Type': 'application/json; charset=UTF-8',
      };

      print('data json not empty half day : ${data}');
      final responsePost = await http.post(
        urlPost,
        body: jsonEncode(data),
        headers: headers,
      );

      if (responsePost.statusCode == 201) {
        int sisaPembayaran = int.parse(loanAmount);
        for (int i = 1; i <= int.parse(loanTenor!); i++) {
          sisaPembayaran -= loanHasil!.toInt();
          final Map<String, dynamic> data = {
            "Periode": "${periode}",
            "BusCode": "${prefUser.busCode}",
            "LOANNumber":
                "LN/${prefUser.busCode}/${periode}/${i.toString().padLeft(4, '0')}",
            "BegBal":
                "${i == 1 ? int.parse(loanAmount) : sisaPembayaran + loanHasil.toInt()}",
            "MonthlyPayment": "${loanHasil.toInt()}",
            "EndBal":
                "${i == 1 ? int.parse(loanAmount) - loanHasil.toInt() : sisaPembayaran}",
            "Proceed": "False",
          };
          final Map<String, String> headers = {
            'Content-Type': 'application/json; charset=UTF-8',
          };

          print("data post history Loan : ${data}");
          final response = await http.post(
            Uri.parse("${Variables.baseUrl}/postHLoan"),
            headers: headers,
            body: jsonEncode(data),
          );

          print("response status code :  ${response.statusCode}");
        }
        return Right("Sukses Post Loan");
      } else {
        return Left("Failed Post Leave");
      }
    } catch (e) {
      print("error ${e}");
      return Left("error ${e}");
    }
  }

  // Slip Gaji
  Future<Either<String, List<dynamic>>> getSlipGaji(String? periode) async {
    final prefUser = await AuthLocalDatasource().getAuthData();
    final url = Uri.parse(
        '${Variables.baseUrl}/getGetSlipGaji/${prefUser?.employeeID}/${periode}');
    // final url = Uri.parse(
    //     '${Variables.baseUrl}/getGetSlipGaji/${prefUser?.employeeID}/${periode}');

    final response = await http.get(url);
    String? statusCode = response.statusCode.toString();

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);

      return Right(jsonResponse);
    } else {
      return Left('Failed to Load Slip Gaji | $statusCode ');
    }
  }
}
