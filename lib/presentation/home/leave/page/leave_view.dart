import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:venushr_10_dipo_mobile/core/core.dart';
import 'package:venushr_10_dipo_mobile/presentation/home/leave/page/leave_viewmodel.dart';
import 'package:venushr_10_dipo_mobile/presentation/main_page.dart';
import 'package:venushr_10_dipo_mobile/widget/search_dropdwon.dart';
import 'package:stacked/stacked.dart';
import '../../../../core/components/buttons.dart';
import '../../../../core/components/custom_date_picker.dart';
import '../../../../core/components/custom_text_field.dart';
import '../../../../core/components/spaces.dart';
import '../../../../core/components/styles.dart';
import '../../../../core/constants/colors.dart';
import '../../../../data/models/base_models.dart';

class LeaveView extends StatefulWidget {
  const LeaveView({super.key});

  @override
  State<LeaveView> createState() => _LeaveViewState();
}

class _LeaveViewState extends State<LeaveView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
        viewModelBuilder: () => LeaveViewmodel(ctx: context),
        builder: (context, vm, child) {
          return Stack(
            children: [
              Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  title: const Text('Leave'),
                ),
                body: ListView(
                  padding: const EdgeInsets.all(18.0),
                  children: [
                    const Text(
                      "Leave Type",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    Container(
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomSearchableDropDown(
                            isReadOnly: false,
                            items: vm.dataListType,
                            label: 'Search Leave Type',
                            padding: EdgeInsets.zero,
                            // searchBarHeight: SDP.sdp(40),
                            hint: 'Leave Type',
                            dropdownHintText: 'Cari Leave Type',
                            dropdownItemStyle: GoogleFonts.getFont("Lato"),
                            onChanged: (value) {
                              if (value != null) {
                                vm.selectLeaveType = value['LeaveTypeCode'];
                              }
                            },
                            dropDownMenuItems: vm.dataListType.map((item) {
                              return "Tipe Cuti : ${item['LeaveTypeName']} , Tahun : ${item['LeaveYear']} , Saldo : ${item['Saldo']}";
                            }).toList()),
                      ),
                    ),
                    const SpaceHeight(16.0),
                    const Text(
                      "Leave Duration",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    Container(
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomSearchableDropDown(
                            isReadOnly: false,
                            items: vm.datalistDurasi!,
                            label: 'Search Leave Duration',
                            padding: EdgeInsets.zero,
                            // searchBarHeight: SDP.sdp(40),
                            hint: 'Leave Duration',
                            dropdownHintText: 'Cari Leave Duration',
                            dropdownItemStyle: GoogleFonts.getFont("Lato"),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  vm.selectLeaveDuration = value;
                                  print("valuee: ${value}");
                                  print(
                                      "selectLeaveType?.type : ${vm.selectLeaveType}");
                                });
                              }
                            },
                            dropDownMenuItems: vm.datalistDurasi!.map((item) {
                              return "${item.type}";
                            }).toList()),
                      ),
                    ),
                    const SpaceHeight(16.0),
                    CustomDatePicker(
                        label: 'From Date Leave',
                        onDateSelected: (selectedDate) {
                          vm.fromdateLeaveController!.text =
                              vm.formatDate(selectedDate).toString();

                          vm.fromDate = selectedDate;
                        }),
                    const SpaceHeight(16.0),
                    CustomDatePicker(
                      beforeDate: vm.fromDate,
                      label: 'To Date Leave',
                      onDateSelected: (selectedDate) {
                        vm.todateLeaveController!.text =
                            vm.formatDate(selectedDate).toString();
                        // print("vm.fromdateLeaveController.text : ${fromdateLeaveController.text}");
                      },
                    ),
                    const SpaceHeight(16.0),
                    CustomTextField(
                      controller: vm.reasonController!,
                      label: 'Reason',
                      maxLines: 5,
                    ),
                    const SpaceHeight(26.0),
                    Button.filled(
                      onPressed: () {
                        vm.postLeave();
                      },
                      label: 'Create',
                    )
                  ],
                ),
              ),
              vm.isBusy
                  ? Stack(
                      children: [
                        ModalBarrier(
                          dismissible: false,
                          color: const Color.fromARGB(118, 0, 0, 0),
                        ),
                        Center(
                          child: loadingSpin,
                        ),
                      ],
                    )
                  : Stack()
            ],
          );
        });
  }
}
