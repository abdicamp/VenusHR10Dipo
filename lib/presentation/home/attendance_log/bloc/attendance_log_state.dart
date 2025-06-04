part of 'attendance_log_bloc.dart';

@freezed
class AttendanceLogState with _$AttendanceLogState {
  const factory AttendanceLogState.initial() = _Initial;
  const factory AttendanceLogState.loading() = _Loading;
  const factory AttendanceLogState.loaded(List<dynamic> data) = _Loaded;
  const factory AttendanceLogState.error(String message) = _Error;
  const factory AttendanceLogState.empty() = _Empty;
}
