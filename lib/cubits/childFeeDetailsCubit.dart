import 'package:yocut/data/models/childFeeDetails.dart';
import 'package:yocut/data/repositories/feeRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class ChildFeeDetailsState {}

class ChildFeeDetailsInitial extends ChildFeeDetailsState {}

class ChildFeeDetailsFetchInProgress extends ChildFeeDetailsState {}

class ChildFeeDetailsFetchSuccess extends ChildFeeDetailsState {
  final List<ChildFeeDetails> fees;
  final int childId;

  ChildFeeDetailsFetchSuccess({required this.fees, required this.childId});
}

class ChildFeeDetailsFetchFailure extends ChildFeeDetailsState {
  final String errorMessage;

  ChildFeeDetailsFetchFailure(this.errorMessage);
}

class ChildFeeDetailsCubit extends Cubit<ChildFeeDetailsState> {
  final FeeRepository _feeRepository;

  ChildFeeDetailsCubit(this._feeRepository) : super(ChildFeeDetailsInitial());

  void fetchChildFeeDetails({required int childId}) async {
    try {
      emit(ChildFeeDetailsFetchInProgress());
      emit(ChildFeeDetailsFetchSuccess(
          childId: childId,
          fees: await _feeRepository.fetchChildFeeDetails(childId: childId)));
    } catch (e) {
      emit(ChildFeeDetailsFetchFailure(e.toString()));
    }
  }

  void refreshFees() {
    if (state is ChildFeeDetailsFetchSuccess) {
      fetchChildFeeDetails(
          childId: (state as ChildFeeDetailsFetchSuccess).childId);
    }
  }
}
