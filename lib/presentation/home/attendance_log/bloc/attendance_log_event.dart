part of 'attendance_log_bloc.dart';

@freezed
class AttendanceLogEvent with _$AttendanceLogEvent {
  const factory AttendanceLogEvent.started() = _Started;
  const factory AttendanceLogEvent.getAttendance(String date) = _GetAttendance;
}