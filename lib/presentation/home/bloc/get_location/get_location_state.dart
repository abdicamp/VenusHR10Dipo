part of 'get_location_bloc.dart';

@freezed
class GetLocationState with _$GetLocationState {
  const factory GetLocationState.initial() = _Initial;
  const factory GetLocationState.loading() = _Loading;
  const factory GetLocationState.success(List<dynamic> data) = _Success;
  const factory GetLocationState.error(String error) = _Error;
}
