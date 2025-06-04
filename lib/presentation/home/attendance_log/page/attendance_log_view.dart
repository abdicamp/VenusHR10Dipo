import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_timeline_calendar/timeline/flutter_timeline_calendar.dart';
import 'package:flutter_timeline_calendar/timeline/provider/instance_provider.dart';
import 'package:flutter_timeline_calendar/timeline/utils/datetime_extension.dart';
import 'package:intl/intl.dart';
import 'package:venushr_10_dipo_mobile/core/components/spaces.dart';
import 'package:venushr_10_dipo_mobile/core/constants/colors.dart';
import 'package:venushr_10_dipo_mobile/presentation/home/attendance_log/bloc/attendance_log_bloc.dart';

import '../../../../core/assets/assets.gen.dart';

class AttendanceLogView extends StatefulWidget {
  const AttendanceLogView({super.key});

  @override
  State<AttendanceLogView> createState() => _AttendanceLogViewState();
}

class _AttendanceLogViewState extends State<AttendanceLogView> {
  late CalendarDateTime selectedDateTime;

  late DateTime? weekStart;
  late DateTime? weekEnd;

  getLatestWeek() {
    setState(() {
      weekStart = selectedDateTime.toDateTime().findFirstDateOfTheWeek();
      weekEnd = selectedDateTime.toDateTime().findLastDateOfTheWeek();
    });
  }

  @override
  void initState() {
    final currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    context
        .read<AttendanceLogBloc>()
        .add(AttendanceLogEvent.getAttendance(currentDate));
    super.initState();
    TimelineCalendar.calendarProvider = createInstance();
    selectedDateTime = TimelineCalendar.calendarProvider.getDateTime();

    getLatestWeek();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Attendance Log"),
      ),
      body: ListView(
        padding: EdgeInsets.all(18.0),
        children: [
          TimelineCalendar(
            calendarType: CalendarType.GREGORIAN,
            calendarLanguage: "en",
            calendarOptions: CalendarOptions(
                viewType: ViewType.DAILY,
                toggleViewType: true,
                headerMonthElevation: 10,
                headerMonthShadowColor: Colors.transparent,
                headerMonthBackColor: Colors.transparent,
                weekStartDate: DateTime.now(),
                weekEndDate: DateTime.now()),
            dayOptions: DayOptions(
                compactMode: true,
                dayFontSize: 14.0,
                disableFadeEffect: true,
                weekDaySelectedColor: const Color(0xff3AC3E2),
                differentStyleForToday: true,
                todayBackgroundColor: Colors.black,
                selectedBackgroundColor: const Color(0xff3AC3E2),
                todayTextColor: Colors.white),
            headerOptions: HeaderOptions(
                weekDayStringType: WeekDayStringTypes.SHORT,
                monthStringType: MonthStringTypes.FULL,
                backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                headerTextSize: 14,
                headerTextColor: Colors.black),
            onChangeDateTime: (dateTime) {
              context.read<AttendanceLogBloc>().add(
                  AttendanceLogEvent.getAttendance(
                      DateFormat('yyy-MM-dd 00:00:00')
                          .format(DateTime.parse(dateTime.toString()))));
            },
          ),
          const SpaceHeight(20.0),
          BlocBuilder<AttendanceLogBloc, AttendanceLogState>(
            builder: (context, state) {
              return state.maybeWhen(
                  orElse: () {
                    return const SizedBox.shrink();
                  },
                  error: (message) {
                    return Center(
                      child: Text(
                        message,
                      ),
                    );
                  },
                  empty: () {
                    return const Center(
                        child: Text(
                      "Data Empty",
                      style: const TextStyle(
                        color: AppColors.grey,
                        fontSize: 12.0,
                      ),
                    ));
                  },
                  loading: () => const Center(
                        child: CircularProgressIndicator(),
                      ),
                  loaded: (attendance) {
                    return Column(
                      children: attendance.map((e) {
                        return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              padding: const EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Absensi',
                                        style: const TextStyle(
                                          fontSize: 16.0,
                                          color: AppColors.white,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Column(
                                            children: [
                                              Text(
                                                "Check In",
                                                style: const TextStyle(
                                                  fontSize: 12.0,
                                                  color: AppColors.white,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              Text(
                                                "${e['CheckIn'] == null ? '-' : e['CheckIn']}",
                                                style: const TextStyle(
                                                  fontSize: 12.0,
                                                  color: AppColors.white,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Column(
                                            children: [
                                              Text(
                                                "Check Out",
                                                style: const TextStyle(
                                                  fontSize: 12.0,
                                                  color: AppColors.white,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              Text(
                                                "${e['CheckOut'] == null ? '-' : e['CheckOut']}",
                                                style: const TextStyle(
                                                  fontSize: 12.0,
                                                  color: AppColors.white,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  const SpaceHeight(20.0),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Check In Loc :",
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: AppColors.white,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          Assets.icons.location.svg(),
                                          const SpaceWidth(8.0),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                1.7,
                                            child: Text(
                                              '${e['CheckInLoc'] == null ? '-' : e['CheckInLoc']} ',
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: AppColors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SpaceHeight(10.0),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Check Out Loc :",
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: AppColors.white,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          Assets.icons.location.svg(),
                                          const SpaceWidth(8.0),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                1.7,
                                            child: Text(
                                              '${e['CheckOutLoc'] == null ? '-' : e['CheckOutLoc']} ',
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: AppColors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SpaceHeight(10.0),
                                  Row(
                                    children: [
                                      Assets.icons.calendar.svg(),
                                      const SpaceWidth(8.0),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1.7,
                                        child: Text(
                                          '${e['TADate']}',
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: AppColors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ));
                      }).toList(),
                    );
                  });
            },
          )
        ],
      ),
    );
  }
}
