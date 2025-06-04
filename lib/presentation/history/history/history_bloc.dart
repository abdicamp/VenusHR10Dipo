import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:venushr_10_dipo_mobile/data/datasource/auth_remote_datasource.dart';

part 'history_event.dart';
part 'history_state.dart';
part 'history_bloc.freezed.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final AuthRemoteDatasource _authRemoteDatasource;

  HistoryBloc(
    this._authRemoteDatasource,
  ) : super(_Initial()) {
    on<HistoryEvent>((event, emit) async {
      emit(const _Loading());
      if (event is _GetHistory) {
        final result = await _authRemoteDatasource.getReqHistory(
          event.dateFrom,
          event.dateTo,
          event.historyType,
        );

        result.fold((l) => emit(_Error(l)), (r) {
          if (r.isEmpty) {
            emit(const _Empty());
          } else {
            emit(_Success(r));
          }
        });
      }
    });
  }
}
