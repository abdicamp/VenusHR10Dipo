import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:venushr_10_dipo_mobile/data/datasource/auth_remote_datasource.dart';

part 'update_request_event.dart';
part 'update_request_state.dart';
part 'update_request_bloc.freezed.dart';

class UpdateRequestBloc extends Bloc<UpdateRequestEvent, UpdateRequestState> {
  final AuthRemoteDatasource _authRemoteDatasource;

  UpdateRequestBloc(this._authRemoteDatasource) : super(_Initial()) {
    on<UpdateRequestEvent>((event, emit) async {
      emit(const _Loading());
      if (event is _UpdateRequest) {
        final result = await _authRemoteDatasource.updateRequest(
            event.employeeId, event.tranNo, event.tranName, event.status);
        result.fold((message) => emit(_Error(message)),
            (success) => emit(_Success(success)));
      }
    });
  }
}
