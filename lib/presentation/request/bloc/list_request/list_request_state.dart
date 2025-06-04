part of 'list_request_bloc.dart';

@freezed
class ListRequestState with _$ListRequestState {
  const factory ListRequestState.initial() = _Initial;
  const factory ListRequestState.loading() = _Loading;
  const factory ListRequestState.empty() = _Empty;
  const factory ListRequestState.error(String error) = _Error;
  const factory ListRequestState.success(List<dynamic> data) = _Success;
}
