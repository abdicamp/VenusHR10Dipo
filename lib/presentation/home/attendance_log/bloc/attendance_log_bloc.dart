import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:venushr_10_dipo_mobile/data/datasource/auth_remote_datasource.dart';

part 'attendance_log_event.dart';
part 'attendance_log_state.dart';
part 'attendance_log_bloc.freezed.dart';

class AttendanceLogBloc extends Bloc<AttendanceLogEvent, AttendanceLogState> {
  final AuthRemoteDatasource _authRemoteDatasource;
  AttendanceLogBloc(this._authRemoteDatasource) : super(_Initial()) {
    on<AttendanceLogEvent>((event, emit) async {
      emit(const _Loading());
      if (event is _GetAttendance) {
        final result = await _authRemoteDatasource.getAttendanceLog(event.date);
        result.fold((message) => emit(_Error(message)), (attendance) {
          if (attendance.isEmpty) {
            emit(const _Empty());
          } else {
            emit(_Loaded(attendance));
          }
        });
      }
    });
  }
}
