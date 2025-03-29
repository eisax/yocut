import 'package:equatable/equatable.dart';
import 'package:yocut/data/repositories/authRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class ChangePasswordState extends Equatable {}

class ChangePasswordInitial extends ChangePasswordState {
  @override
  List<Object?> get props => [];
}

class ChangePasswordInProgress extends ChangePasswordState {
  @override
  List<Object?> get props => [];
}

class ChangePasswordSuccess extends ChangePasswordState {
  @override
  List<Object?> get props => [];
}

class ChangePasswordFailure extends ChangePasswordState {
  final String errorMessage;

  ChangePasswordFailure(this.errorMessage);

  @override
  List<Object?> get props => [];
}

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  final AuthRepository _authRepository;

  ChangePasswordCubit(this._authRepository) : super(ChangePasswordInitial());

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String newConfirmedPassword,
  }) async {
    emit(ChangePasswordInProgress());
    try {
      await _authRepository.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
        newConfirmedPassword: newConfirmedPassword,
      );
      emit(ChangePasswordSuccess());
    } catch (e) {
      emit(ChangePasswordFailure(e.toString()));
    }
  }
}
