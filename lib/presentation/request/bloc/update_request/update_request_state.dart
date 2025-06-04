part of 'update_request_bloc.dart';

@freezed
class UpdateRequestState with _$UpdateRequestState {
  const factory UpdateRequestState.initial() = _Initial;
  const factory UpdateRequestState.loading() = _Loading;
  const factory UpdateRequestState.error(String message) = _Error;
  const factory UpdateRequestState.success(String? message) = _Success;
}
