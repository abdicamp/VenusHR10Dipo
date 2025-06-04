import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../data/datasource/auth_remote_datasource.dart';

part 'list_request_event.dart';
part 'list_request_state.dart';
part 'list_request_bloc.freezed.dart';

class ListRequestBloc extends Bloc<ListRequestEvent, ListRequestState> {
  final AuthRemoteDatasource _authRemoteDatasource;
  ListRequestBloc(this._authRemoteDatasource) : super(_Initial()) {
    on<ListRequestEvent>((event, emit) async {
      emit(const _Loading());
      if (event is _GetListRequest) {
        final result = await _authRemoteDatasource.getListRequest();

        result.fold((message) => emit(_Error(message)), (listData) {
          if (listData.isNotEmpty) {
            emit(_Success(listData));
          } else {
            emit(_Empty());
          }
        });
      }
    });
  }
}
