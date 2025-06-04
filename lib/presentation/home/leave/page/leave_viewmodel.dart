import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:venushr_10_dipo_mobile/presentation/main_page.dart';

import '../../../../core/constants/colors.dart';
import '../../../../data/datasource/auth_remote_datasource.dart';
import '../../../../data/models/base_models.dart';
import '../../absen_result.dart';

class LeaveViewmodel extends FutureViewModel {
  BuildContext? ctx;
  TextEditingController? fromdateLeaveController = new TextEditingController();
  TextEditingController? todateLeaveController = new TextEditingController();
  TextEditingController? reasonController = new TextEditingController();
  String? selectLeaveType;
  ListModels? selectLeaveDuration;
  String? selectApprovel;
  DateTime? fromDate;
  List<dynamic> dataListType = [];

  LeaveViewmodel({this.ctx});

  List<ListModels>? datalistDurasi = [
    ListModels(type: "Full Day Leave"),
    ListModels(type: "Half Day Leave"),
  ];

  String formatDate(DateTime date) {
    final dateFormatter = DateFormat('yyyy-MM-dd 00:00:00');
    return dateFormatter.format(date);
  }

  getLevaeType() async {
    try {
      setBusy(true);
      AbsenResult result = await AuthRemoteDatasource().getLeaveSaldo();

      if (result.success == true) {
        dataListType = List.from(result.data!);
        setBusy(false);
        notifyListeners();
      } else {
        dataListType = List.from(result.data!);
        setBusy(false);
        notifyListeners();
      }
    } catch (e) {
      dataListType = [];
      setBusy(false);
      notifyListeners();
    }
  }

  postLeave() async {
    setBusy(true);
    AbsenResult results = await AuthRemoteDatasource().postLeave(
        selectLeaveType ?? "",
        selectLeaveDuration?.type ?? "",
        fromdateLeaveController!.text,
        todateLeaveController!.text,
        reasonController!.text,
        selectApprovel ?? "");
    if (results.success == true) {
      ScaffoldMessenger.of(ctx!).showSnackBar(
        SnackBar(
          content: Text(results.message!),
          backgroundColor: AppColors.green,
        ),
      );
      Navigator.push(ctx!, MaterialPageRoute(builder: (context) => MainPage()));
      setBusy(false);
      notifyListeners();
    } else {
      ScaffoldMessenger.of(ctx!).showSnackBar(
        SnackBar(
          content: Text(results.message!),
          backgroundColor: AppColors.red,
        ),
      );
      setBusy(false);
      notifyListeners();
    }
  }

  @override
  Future futureToRun() async {
    await getLevaeType();
    fromdateLeaveController = TextEditingController();
    todateLeaveController = TextEditingController();
    reasonController = TextEditingController();
  }
}
