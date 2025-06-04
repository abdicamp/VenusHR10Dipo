import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:venushr_10_dipo_mobile/presentation/auth/model/auth_detail_user.dart';
import '../../../../data/datasource/auth_remote_datasource.dart';
import '../../model/auth_response_model.dart';
part 'login_bloc.freezed.dart';
part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRemoteDatasource _authRemoteDatasource;
  LoginBloc(
    this._authRemoteDatasource,
  ) : super(const _Initial()) {
    on<LoginEvent>((event, emit) async {
      emit(const _Loading());
      if (event is _Login) {
        final result = await _authRemoteDatasource.login(
            event.userId, event.password, event.deviceId);
        result.fold(
          (l) => emit(_Error(l)),
          (r) {
            emit(_Success(r));
            add(_DataUserDetail());
          },
        );
      } else if (event is _DataUserDetail) {
        final result = await _authRemoteDatasource.dataUserDetail();
        result.fold(
            (l) => emit(_Error(l)),
            (r) => emit(
                  _SuccessUserDetail(r),
                ));
      }
    });
  }
}
