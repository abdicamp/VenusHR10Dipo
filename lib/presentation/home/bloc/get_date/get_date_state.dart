part of 'get_date_bloc.dart';

@freezed
class GetDateState with _$GetDateState {
  const factory GetDateState.initial() = _Initial;
  const factory GetDateState.loading() = _Loading;
  const factory GetDateState.loaded(List<dynamic> data) = _Loaded;
  const factory GetDateState.error(String message) = _Error;
  const factory GetDateState.empty() = _Empty;
}
