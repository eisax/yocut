import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:yocut/data/models/assignment.dart';
import 'package:yocut/data/repositories/assignmentRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class UploadAssignmentState extends Equatable {}

class UploadAssignmentInitial extends UploadAssignmentState {
  @override
  List<Object?> get props => [];
}

class UploadAssignmentInProgress extends UploadAssignmentState {
  final double uploadedProgress;

  UploadAssignmentInProgress(this.uploadedProgress);
  @override
  List<Object?> get props => [uploadedProgress];
}

class UploadAssignmentFetchSuccess extends UploadAssignmentState {
  final AssignmentSubmission assignmentSubmission;

  UploadAssignmentFetchSuccess({required this.assignmentSubmission});
  @override
  List<Object?> get props => [assignmentSubmission];
}

class UploadAssignmentCanceled extends UploadAssignmentState {
  @override
  List<Object?> get props => [];
}

class UploadAssignmentFailure extends UploadAssignmentState {
  final String errorMessage;

  UploadAssignmentFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

class UploadAssignmentCubit extends Cubit<UploadAssignmentState> {
  final AssignmentRepository _assignmentRepository;

  UploadAssignmentCubit(this._assignmentRepository)
      : super(UploadAssignmentInitial());

  final CancelToken _cancelToken = CancelToken();

  void _uploadAssignmentPercentage(double percentage) {
    emit(UploadAssignmentInProgress(percentage));
  }

  Future<void> uploadAssignment({
    required int assignmentId,
    required List<String> filePaths,
  }) async {
    emit(UploadAssignmentInProgress(0.0));
    try {
      final result = await _assignmentRepository.submitAssignment(
        assignmentId: assignmentId,
        filePaths: filePaths,
        cancelToken: _cancelToken,
        updateUploadAssignmentPercentage: _uploadAssignmentPercentage,
      );

      emit(UploadAssignmentFetchSuccess(assignmentSubmission: result));
    } catch (e) {
      if (_cancelToken.isCancelled) {
        emit(UploadAssignmentCanceled());
      } else {
        emit(UploadAssignmentFailure(e.toString()));
      }
    }
  }

  void cancelUploadAssignmentProcess() {
    _cancelToken.cancel();
  }
}
