import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../data/datasource/auth_remote_datasource.dart';
part 'get_location_event.dart';
part 'get_location_state.dart';
part 'get_location_bloc.freezed.dart';

class GetLocationBloc extends Bloc<GetLocationEvent, GetLocationState> {
  final AuthRemoteDatasource _authRemoteDatasource;

  GetLocationBloc(
    this._authRemoteDatasource,
  ) : super(const _Initial()) {
    on<GetLocationEvent>((event, emit) async {
      emit(const _Loading());
      final result = await _authRemoteDatasource.location();

      result.fold(
        (l) => emit(_Error(l)),
        (r) => emit(_Success(r)),
      );
    });
  }
}
