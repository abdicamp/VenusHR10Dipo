import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../data/datasource/auth_remote_datasource.dart';

part 'get_date_event.dart';
part 'get_date_state.dart';
part 'get_date_bloc.freezed.dart';

class GetDateBloc extends Bloc<GetDateEvent, GetDateState> {
  final AuthRemoteDatasource _authRemoteDatasource;
  GetDateBloc(this._authRemoteDatasource) : super(_Initial()) {
    on<GetDateEvent>((event, emit) async {
      emit(const _Loading());
      if (event is _GetDate) {
        final result = await _authRemoteDatasource.getDateHoliday();
        result.fold((message) => emit(_Error(message)), (data) {
          if (data.isEmpty) {
            emit(const _Empty());
          } else {
            emit(_Loaded(data));
          }
        });
      }
    });
  }
}
