part of 'history_bloc.dart';

@freezed
class HistoryState with _$HistoryState {
  const factory HistoryState.initial() = _Initial;
  const factory HistoryState.loading() = _Loading;
  const factory HistoryState.success(List<dynamic> data) = _Success;
  const factory HistoryState.error(String error) = _Error;
  const factory HistoryState.empty() = _Empty;
}
