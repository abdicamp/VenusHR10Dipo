part of 'get_location_bloc.dart';

@freezed
class GetLocationEvent with _$GetLocationEvent {
  const factory GetLocationEvent.started() = _Started;
  const factory GetLocationEvent.location() = _GetLocation;
}
