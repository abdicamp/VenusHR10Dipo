import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:venushr_10_dipo_mobile/data/datasource/auth_local_datasource.dart';
import 'package:venushr_10_dipo_mobile/presentation/request/bloc/update_request/update_request_bloc.dart';
import '../../core/components/spaces.dart';
import '../../core/constants/colors.dart';
import 'bloc/list_request/list_request_bloc.dart';

class RequestView extends StatefulWidget {
  const RequestView({super.key});

  @override
  State<RequestView> createState() => _RequestViewState();
}

class _RequestViewState extends State<RequestView>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  String? prefEmployeeId;

  @override
  void initState() {
    context
        .read<ListRequestBloc>()
        .add(const ListRequestEvent.getListRequest());
    tabController = TabController(vsync: this, length: 2);
    getDataPref();
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  Future<void> getDataPref() async {
    final prefUser = await AuthLocalDatasource().getAuthData();
    setState(() {
      prefEmployeeId = prefUser?.employeeID;
    });
  }

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.simpleCurrency(
      locale: 'id_ID',
      name: "Rp.",
      decimalDigits: 0,
    );
    return DefaultTabController(
      length: 2, // Jumlah tab pada TabBar pertama
      child: Scaffold(
        appBar: AppBar(
          title: Text('Request'),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            setState(() {
              context
                  .read<ListRequestBloc>()
                  .add(const ListRequestEvent.getListRequest());
            });
          },
          child: ListView(
            children: [
              BlocListener<UpdateRequestBloc, UpdateRequestState>(
                listener: (context, state) {
                  state.maybeWhen(
                      orElse: () {},
                      loading: () {
                        Container(
                          color: Colors.white,
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      },
                      success: (data) {
                        context
                            .read<ListRequestBloc>()
                            .add(const ListRequestEvent.getListRequest());
                      });
                },
                child: BlocBuilder<ListRequestBloc, ListRequestState>(
                    builder: (context, state) {
                  return state.maybeWhen(orElse: () {
                    return Container(
                      height: MediaQuery.of(context).size.height,
                      color: Colors.white,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }, empty: () {
                    return Container(
                      color: Colors.white,
                      height: MediaQuery.of(context).size.height,
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Data Empty",
                            style: TextStyle(
                              fontSize: 13.5,
                              color: AppColors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    );
                  }, loading: () {
                    return Container(
                      height: MediaQuery.of(context).size.height,
                      color: Colors.white,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }, success: (data) {
                    return Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                            children: data.map((e) {
                          String? pisahkoma = e['Notes'].split('.').toString();
                          String? pisahkoma2 = e['Notes'].split(',').toString();

                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(
                                        0.1), // Warna bayangan dan opasitas
                                    spreadRadius:
                                        1, // Jarak penyebaran bayangan
                                    blurRadius: 9, // Radius blur bayangan
                                    offset: Offset(
                                        0, 1), // Offset (x, y) dari bayangan
                                  ),
                                ],
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(25),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  "TranName : ",
                                                  style: TextStyle(
                                                    fontSize: 13.5,
                                                    color: AppColors.black,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "${e['TranName']}",
                                                  style: const TextStyle(
                                                    fontSize: 13.5,
                                                    color: AppColors.grey,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                const SpaceHeight(10),
                                                const Text(
                                                  "TranType : ",
                                                  style: const TextStyle(
                                                    fontSize: 13.5,
                                                    color: AppColors.black,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "${e['TranType']}",
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    color: AppColors.grey,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  "Note : ",
                                                  style: TextStyle(
                                                    fontSize: 13.5,
                                                    color: AppColors.black,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                const SpaceHeight(5),
                                                e['TranName'] == "Loan"
                                                    ? Text(
                                                        "${formatCurrency.format(int.parse(pisahkoma.toString()))} / ${pisahkoma2}",
                                                        style: const TextStyle(
                                                          fontSize: 13.5,
                                                          color: AppColors.grey,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      )
                                                    : Text(
                                                        "${e['Notes']}",
                                                        maxLines: 1,
                                                        style: const TextStyle(
                                                          fontSize: 10,
                                                          color: AppColors.grey,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                const SpaceHeight(10),
                                                const Text(
                                                  "Name Request : ",
                                                  style: const TextStyle(
                                                    fontSize: 13.5,
                                                    color: AppColors.black,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "${e['Requester']}",
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    color: AppColors.grey,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SpaceHeight(10),
                                        const Text(
                                          "Reason : ",
                                          style: const TextStyle(
                                            fontSize: 13.5,
                                            color: AppColors.black,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          "${e['Reason']}",
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: AppColors.grey,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const Divider(),
                                        const SpaceHeight(5),
                                        Row(
                                          children: [
                                            const Text(
                                              "Status : ",
                                              style: TextStyle(
                                                fontSize: 13.5,
                                                color: AppColors.black,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Text(
                                              "${e['AppStatus'] == null || e['AppStatus'] == "" ? "-" : e['AppStatus']}",
                                              style: TextStyle(
                                                fontSize: 13.5,
                                                color: AppColors.black,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SpaceHeight(10),
                                        prefEmployeeId == e['EmployeeID']
                                            ? Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child: ElevatedButton(
                                                    onPressed: () {
                                                      print(
                                                          "tran Name : ${e['TranName']}");
                                                      context
                                                          .read<
                                                              UpdateRequestBloc>()
                                                          .add(UpdateRequestEvent
                                                              .updateRequestEvent(
                                                                  e['EmployeeID'],
                                                                  e['TranNo'],
                                                                  e['TranName'],
                                                                  "Cancel"));
                                                    },
                                                    child: Text("Cancel")),
                                              )
                                            : e['ApprovedByID']
                                                    .toString()
                                                    .contains(prefEmployeeId!)
                                                ? Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        ElevatedButton(
                                                            onPressed: () {
                                                              context
                                                                  .read<
                                                                      UpdateRequestBloc>()
                                                                  .add(UpdateRequestEvent.updateRequestEvent(
                                                                      e['EmployeeID'],
                                                                      e['TranNo'],
                                                                      e['TranName'],
                                                                      "Rejected"));
                                                            },
                                                            child: Text(
                                                                "Rejected")),
                                                        ElevatedButton(
                                                            onPressed: () {
                                                              context
                                                                  .read<
                                                                      UpdateRequestBloc>()
                                                                  .add(UpdateRequestEvent.updateRequestEvent(
                                                                      e['EmployeeID'],
                                                                      e['TranNo'],
                                                                      e['TranName'],
                                                                      "Approved"));
                                                            },
                                                            child: Text(
                                                                "Approve")),
                                                      ],
                                                    ),
                                                  )
                                                : Container()
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList()),
                      ),
                    );
                  });
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
