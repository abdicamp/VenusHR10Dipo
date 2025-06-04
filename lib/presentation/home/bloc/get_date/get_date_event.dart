part of 'get_date_bloc.dart';

@freezed
class GetDateEvent with _$GetDateEvent {
  const factory GetDateEvent.started() = _Started;
  const factory GetDateEvent.getDate() = _GetDate;
}
