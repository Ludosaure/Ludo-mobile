import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:ludo_mobile/data/repositories/media_repository.dart';
import 'package:meta/meta.dart';

part 'upload_picture_state.dart';

@injectable
class UploadPictureCubit extends Cubit<UploadPictureState> {
  final MediaRepository _mediaRepository;

  UploadPictureCubit(
    this._mediaRepository,
  ) : super(UploadPictureInitial());

  void uploadPicture() {
    emit(OperationLoading());
  }
}
