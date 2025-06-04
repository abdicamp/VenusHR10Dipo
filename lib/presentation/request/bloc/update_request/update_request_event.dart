part of 'update_request_bloc.dart';

@freezed
class UpdateRequestEvent with _$UpdateRequestEvent {
  const factory UpdateRequestEvent.started() = _Started;
  const factory UpdateRequestEvent.updateRequestEvent(String employeeId, String tranNo, String tranName, String status) = _UpdateRequest;
}