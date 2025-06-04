import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:venushr_10_dipo_mobile/core/core.dart';
import 'package:venushr_10_dipo_mobile/data/datasource/auth_remote_datasource.dart';
import 'package:venushr_10_dipo_mobile/data/models/base_models.dart';
import 'package:venushr_10_dipo_mobile/presentation/history/history/history_bloc.dart';
import '../../widget/search_dropdwon.dart';

class HistoryView extends StatefulWidget {
  const HistoryView({super.key});

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView>
    with SingleTickerProviderStateMixin {
  TextEditingController? fromdatePermissionController;
  TextEditingController? todatePermissionController;
  ListModels? selectedHistoryType;
  DateTime? fromDate;
  DateTime? selectedDate;
  DateTime? selectedDate2;

  List<ListModels> listHistoryType = [
    ListModels(type: "Permission"),
    ListModels(type: "Leave"),
    ListModels(type: "Overtime"),
    ListModels(type: "Loan"),
  ];

  String formatDate(DateTime date) {
    final dateFormatter = DateFormat('yyyy-MM-dd 00:00:00');
    return dateFormatter.format(date);
  }

  @override
  void initState() {
    super.initState();
    fromdatePermissionController = new TextEditingController();
    todatePermissionController = new TextEditingController();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        fromdatePermissionController?.text = formatDate(selectedDate!);
      });
    }
  }

  Future<void> _selectDate2(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate2 = picked;
        todatePermissionController?.text = formatDate(selectedDate2!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.simpleCurrency(
      locale: 'id_ID',
      name: "Rp.",
      decimalDigits: 0,
    );
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('History'),
        ),
        body: BlocProvider(
          create: (context) => HistoryBloc(AuthRemoteDatasource()),
          child: SingleChildScrollView(
            child: ListView(
              padding: const EdgeInsets.all(18.0),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Date From",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    TextFormField(
                      controller: fromdatePermissionController,
                      onTap: () => _selectDate(context),
                      readOnly: true,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Assets.icons.calendar.svg(),
                          ),
                          hintText: "From Date"),
                    ),
                    const SizedBox(height: 20.0),
                    const Text(
                      "Date To",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    TextFormField(
                      controller: todatePermissionController,
                      onTap: () => _selectDate2(context),
                      readOnly: true,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Assets.icons.calendar.svg(),
                          ),
                          hintText: "To Date"),
                    ),
                    const SizedBox(height: 20.0),
                    const Text(
                      "History Type",
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
                            items: listHistoryType,
                            label: 'Search History Type',
                            padding: EdgeInsets.zero,
                            // searchBarHeight: SDP.sdp(40),
                            hint: 'History Type',
                            dropdownHintText: 'Cari History Type',
                            dropdownItemStyle: GoogleFonts.getFont("Lato"),
                            onChanged: (value) {
                              if (value != null) {
                                selectedHistoryType = value;
                              }
                            },
                            dropDownMenuItems: listHistoryType.map((item) {
                              return "${item.type}";
                            }).toList()),
                      ),
                    ),
                    const SizedBox(height: 15.0),
                    BlocListener<HistoryBloc, HistoryState>(
                      listener: (context, state) {
                        state.maybeWhen(
                          orElse: () {},
                          success: (data) {
                            return;
                          },
                          error: (message) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(message),
                                backgroundColor: AppColors.red,
                              ),
                            );
                          },
                        );
                      },
                      child: BlocBuilder<HistoryBloc, HistoryState>(
                          builder: (context, state) {
                        return state.maybeWhen(
                          orElse: () {
                            return Button.filled(
                              onPressed: () {
                                context
                                    .read<HistoryBloc>()
                                    .add(HistoryEvent.getHistory(
                                      fromdatePermissionController?.text,
                                      todatePermissionController?.text,
                                      selectedHistoryType?.type,
                                    ));
                              },
                              label: 'Search',
                            );
                          },
                        );
                      }),
                    ),
                    BlocBuilder<HistoryBloc, HistoryState>(
                        builder: (context, state) {
                      return state.maybeWhen(orElse: () {
                        return Container();
                      }, success: (data) {
                        return Container(
                          color: Colors.white,
                          height: MediaQuery.of(context).size.height / 2.55,
                          child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: Column(
                                children: data.map((e) {
                                  String? pisahkoma =
                                      e["Notes"].split('.').toString();
                                  String? pisahkoma2 =
                                      e["Notes"].split(',').toString();
                                  print("pisahkoma : ${pisahkoma2}");
                                  return InkWell(
                                    onTap: () {},
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(
                                                  0.1), // Warna bayangan dan opasitas
                                              spreadRadius:
                                                  1, // Jarak penyebaran bayangan
                                              blurRadius:
                                                  9, // Radius blur bayangan
                                              offset: Offset(0,
                                                  1), // Offset (x, y) dari bayangan
                                            ),
                                          ],
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(15),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "Tran Name : ",
                                                        style:
                                                            GoogleFonts.getFont(
                                                                "PT Serif",
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text(
                                                        "${e["TranName"]}",
                                                        style:
                                                            GoogleFonts.getFont(
                                                          "PT Serif",
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "Tran Type :",
                                                        style:
                                                            GoogleFonts.getFont(
                                                                "PT Serif",
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      SizedBox(
                                                        width: 130,
                                                        child: Text(
                                                          "${e["TranType"]}",
                                                          maxLines: 2,
                                                          style: GoogleFonts
                                                              .getFont(
                                                                  "PT Serif",
                                                                  fontSize: 11),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "Notes : ",
                                                        style:
                                                            GoogleFonts.getFont(
                                                                "PT Serif",
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          e["TranName"] ==
                                                                  "Loan"
                                                              ? Container(
                                                                  width: 86,
                                                                  child: Text(
                                                                    "${formatCurrency.format(int.parse(pisahkoma.toString()))} / ${pisahkoma2}",
                                                                    maxLines: 2,
                                                                    style: GoogleFonts.getFont(
                                                                        "PT Serif",
                                                                        fontSize:
                                                                            13,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                )
                                                              : Text(
                                                                  "${e["Notes"] ?? 'Nul'}",
                                                                  style: GoogleFonts.getFont(
                                                                      "PT Serif",
                                                                      fontSize:
                                                                          11,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "Status :",
                                                        style:
                                                            GoogleFonts.getFont(
                                                                "PT Serif",
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      SizedBox(
                                                        width: 130,
                                                        child: Text(
                                                          "${e["AppStatus"]} by ${e['ApprovedName']}",
                                                          maxLines: 2,
                                                          style: GoogleFonts
                                                              .getFont(
                                                                  "PT Serif",
                                                                  fontSize: 11),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                "Reason : ",
                                                style: GoogleFonts.getFont(
                                                    "PT Serif",
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                "${e["Reason"]}",
                                                style: GoogleFonts.getFont(
                                                  "PT Serif",
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              )),
                        );
                      }, loading: () {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }, empty: () {
                        return Center(
                          child: Column(
                            children: [
                              const SizedBox(height: 50.0),
                              Text("Data Empty")
                            ],
                          ),
                        );
                      });
                    }),
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
