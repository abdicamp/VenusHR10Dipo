part of 'list_request_bloc.dart';

@freezed
class ListRequestEvent with _$ListRequestEvent {
  const factory ListRequestEvent.started() = _Started;
  const factory ListRequestEvent.getListRequest() = _GetListRequest;
}
