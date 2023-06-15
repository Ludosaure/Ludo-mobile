part of 'upload_picture_cubit.dart';

@immutable
abstract class UploadPictureState {}

class UploadPictureInitial extends UploadPictureState {}

class OperationLoading extends UploadPictureState {}

class OperationSuccess extends UploadPictureState {}

class OperationFailure extends UploadPictureState {
  final String message;

  OperationFailure(this.message);
}

class UserMustBeLoggedIn extends UploadPictureState {}
