import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_face_resgister_event.dart';
part 'update_face_resgister_state.dart';
part 'update_face_resgister_bloc.freezed.dart';

class UpdateFaceResgisterBloc
    extends Bloc<UpdateFaceResgisterEvent, UpdateFaceResgisterState> {
  UpdateFaceResgisterBloc() : super(_Initial()) {
    on<UpdateFaceResgisterEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
