part of 'login_bloc.dart';

@freezed
class LoginEvent with _$LoginEvent {
  const factory LoginEvent.started() = _Started;
  const factory LoginEvent.login(
      String userId, String password, String deviceId) = _Login;
  const factory LoginEvent.dataUserDetail() = _DataUserDetail;
}
