import 'package:equatable/equatable.dart';
import 'package:yocut/data/repositories/authRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class ForgotPasswordRequestState extends Equatable {}

class ForgotPasswordRequestInitial extends ForgotPasswordRequestState {
  @override
  List<Object?> get props => [];
}

class ForgotPasswordRequestInProgress extends ForgotPasswordRequestState {
  @override
  List<Object?> get props => [];
}

class ForgotPasswordRequestSuccess extends ForgotPasswordRequestState {
  @override
  List<Object?> get props => [];
}

class ForgotPasswordRequestFailure extends ForgotPasswordRequestState {
  final String errorMessage;

  ForgotPasswordRequestFailure(this.errorMessage);

  @override
  List<Object?> get props => [];
}

class ForgotPasswordRequestCubit extends Cubit<ForgotPasswordRequestState> {
  final AuthRepository _authRepository;

  ForgotPasswordRequestCubit(this._authRepository)
      : super(ForgotPasswordRequestInitial());

  Future<void> requestforgotPassword(
      {required String email, required String schoolCode}) async {
    emit(ForgotPasswordRequestInProgress());
    try {
      await _authRepository.forgotPassword(
          email: email, schoolCode: schoolCode);
      emit(ForgotPasswordRequestSuccess());
    } catch (e) {
      emit(ForgotPasswordRequestFailure(e.toString()));
    }
  }
}
