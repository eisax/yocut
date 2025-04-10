import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:yocut/data/models/credentials.dart';
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
      late Credentials? loginResponse;

      if (isStudentLogin) {
        loginResponse = await _authRepository.loginUser(
          regNumber: userId,
          password: password,
        );
      }

      emit(
        SignInSuccess(
          schoolCode: "",
          jwtToken: loginResponse?.token ?? "",
          isStudentLogIn: isStudentLogin,
          student: Student.fromJson({}),
          parent: Guardian.fromJson({}),
        ),
      );
    } catch (e) {
      emit(SignInFailure(e.toString()));
    }
  }
}
