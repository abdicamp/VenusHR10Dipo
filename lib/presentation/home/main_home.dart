import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:venushr_10_dipo_mobile/core/core.dart';
import 'package:venushr_10_dipo_mobile/presentation/auth/pages/login_page.dart';
import 'package:venushr_10_dipo_mobile/presentation/home/attendance_log/page/attendance_log_view.dart';

import 'package:venushr_10_dipo_mobile/presentation/home/leave/page/leave_view.dart';
import 'package:venushr_10_dipo_mobile/presentation/home/main_home_viewmodel.dart';
import 'package:venushr_10_dipo_mobile/presentation/home/report/report_attendance_log.dart';
import '../../core/components/styles.dart';
import '../../data/datasource/auth_local_datasource.dart';
import '../../widget/button_bouncing.dart';
import 'package:stacked/stacked.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String? faceEmbedding;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
        viewModelBuilder: () => MainHomeViewmodel(ctx: context),
        builder: (context, vm, child) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.fill,
                              image: Assets.images.bgHome.provider(),
                              alignment: Alignment.topCenter,
                            ),
                          ),
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  const SpaceHeight(25.0),
                                  Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(50.0),
                                        child: Image.network(
                                          'https://i.pinimg.com/originals/1b/14/53/1b14536a5f7e70664550df4ccaa5b231.jpg',
                                          width: 48.0,
                                          height: 48.0,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      const SpaceWidth(12.0),
                                      Expanded(
                                        child: FutureBuilder(
                                          future: AuthLocalDatasource()
                                              .getAuthData(),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return const Text('Loading...');
                                            } else {
                                              final user =
                                                  snapshot.data?.userId;
                                              return Text(
                                                'Hello, ${user ?? 'Hello, Chopper Sensei'}',
                                                style: const TextStyle(
                                                  fontSize: 18.0,
                                                  color: AppColors.white,
                                                ),
                                                maxLines: 2,
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () async {
                                          await AuthLocalDatasource()
                                              .removeAuthData();
                                          context.pushReplacement(LoginPage());
                                        },
                                        icon: Icon(Icons.logout_outlined),
                                      ),
                                    ],
                                  ),
                                  const SpaceHeight(24.0),
                                  Column(
                                    children: [
                                      const Divider(),
                                      Padding(
                                        padding: const EdgeInsets.all(5),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.map_outlined,
                                                  color: Colors.white,
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      2,
                                                  child: Text(
                                                    "${vm.namaJalan}",
                                                    softWrap: true,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w100,
                                                        overflow:
                                                            TextOverflow.fade),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            InkWell(
                                                onTap: () =>
                                                    vm.getAddressLocation(),
                                                child: Card(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(5),
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons.refresh,
                                                          size: 16,
                                                        ),
                                                        SizedBox(
                                                            width:
                                                                4), // Jarak antara ikon dan teks
                                                        Text(
                                                          "Refresh Location",
                                                          style: TextStyle(
                                                              fontSize: 10),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ))
                                          ],
                                        ),
                                      ),
                                      const Divider(),
                                      Text(
                                        DateTime.now().toFormattedTime(),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 32.0,
                                          color: AppColors.white,
                                        ),
                                      ),
                                      Text(
                                        DateTime.now().toFormattedDate(),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: AppColors.white,
                                        ),
                                      ),
                                      const SpaceHeight(10.0),
                                      const Divider(),
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: vm.dataSaldo.map((e) {
                                            return Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Column(
                                                children: [
                                                  Text(
                                                    "${e['LeaveTypeName']} (${e['LeaveYear']}) ",
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 10,
                                                    ),
                                                  ),
                                                  const SpaceHeight(18.0),
                                                  Text(
                                                    "${e['Saldo']}",
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 10,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            );
                                          }).toList()),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )),
                    ),
                    Expanded(
                      flex: 2,
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: GridView(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16.0,
                              mainAxisSpacing: 16.0,
                            ),
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            children: [
                              BouncingButton(
                                  urlImage: "assets/images/biometrics.png",
                                  judul: "Check In",
                                  onTap: () => vm.getLokasi("IN")),
                              BouncingButton(
                                  urlImage: "assets/images/biometrics.png",
                                  judul: "Check Out",
                                  onTap: () => vm.getLokasi("OUT")),
                              BouncingButton(
                                  onTap: () async {
                                    await Future.delayed(
                                        Duration(milliseconds: 500));
                                    await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => LeaveView()));
                                  },
                                  urlImage: "assets/images/calender.png",
                                  judul: "Leave"),
                              BouncingButton(
                                  onTap: () async {
                                    await Future.delayed(
                                        Duration(milliseconds: 500));
                                    await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AttendanceLogView()));
                                  },
                                  urlImage: "assets/images/biometrics.png",
                                  judul: "Attendance Log"),
                              BouncingButton(
                                  onTap: () async {
                                    await Future.delayed(
                                        Duration(milliseconds: 500));
                                    await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ReportAttendanceLog()));
                                  },
                                  urlImage: "assets/images/permission.png",
                                  judul: "Report"),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
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
            ),
          );
        });
  }
}
