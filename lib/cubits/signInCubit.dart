import 'package:equatable/equatable.dart';
import 'package:yocut/data/models/guardian.dart';
import 'package:yocut/data/models/student.dart';
import 'package:yocut/data/repositories/authRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class SignInState extends Equatable {}

class SignInInitial extends SignInState {
  @override
  List<Object?> get props => [];
}

class SignInInProgress extends SignInState {
  @override
  List<Object?> get props => [];
}

class SignInSuccess extends SignInState {
  final String jwtToken;
  final bool isStudentLogIn;
  final Student student;
  final String schoolCode;

  final Guardian parent;

  SignInSuccess({
    required this.jwtToken,
    required this.isStudentLogIn,
    required this.student,
    required this.parent,
    required this.schoolCode,
  });

  @override
  List<Object?> get props => [jwtToken, isStudentLogIn, student];
}

class SignInFailure extends SignInState {
  final String errorMessage;

  SignInFailure(this.errorMessage);

  @override
  List<Object?> get props => [];
}

class SignInCubit extends Cubit<SignInState> {
  final AuthRepository _authRepository;

  SignInCubit(this._authRepository) : super(SignInInitial());

  Future<void> signInUser({
    required String userId,
    required String password,
    required String schoolCode,
    required bool isStudentLogin,
  }) async {
    emit(SignInInProgress());

    try {
      late Map<String, dynamic> result;

      
      if (isStudentLogin) {
        result = await _authRepository.signInStudent(
          grNumber: userId,
          schoolCode: schoolCode,
          password: password,
        );

        print(result);
      } else {
        result = await _authRepository.signInParent(
          email: userId,
          schoolCode: schoolCode,
          password: password,
        );
      }

      emit(
        SignInSuccess(
          schoolCode: schoolCode,
          jwtToken: result['jwtToken'],
          isStudentLogIn: isStudentLogin,
          student: isStudentLogin ? result['student'] : Student.fromJson({}),
          parent: isStudentLogin ? Guardian.fromJson({}) : result['parent'],
        ),
      );
    } catch (e) {
      
      emit(SignInFailure(e.toString()));
    }
  }
}
