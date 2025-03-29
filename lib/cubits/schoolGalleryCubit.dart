import 'package:yocut/data/models/gallery.dart';
import 'package:yocut/data/repositories/schoolRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class SchoolGalleryState {}

class SchoolGalleryInitial extends SchoolGalleryState {}

class SchoolGalleryFetchInProgress extends SchoolGalleryState {}

class SchoolGalleryFetchSuccess extends SchoolGalleryState {
  final List<Gallery> gallery;

  SchoolGalleryFetchSuccess({required this.gallery});
}


class SchoolGalleryFetchFailure extends SchoolGalleryState {
  final String errorMessage;

  SchoolGalleryFetchFailure(this.errorMessage);
}

class SchoolGalleryCubit extends Cubit<SchoolGalleryState> {
  final SchoolRepository _schoolRepository;

  SchoolGalleryCubit(this._schoolRepository) : super(SchoolGalleryInitial());

  void fetchSchoolGallery(
      {required bool useParentApi,
      int? childId,
      required int sessionYearId,
      int? galleryId}) async {
    try {
      emit(SchoolGalleryFetchInProgress());
      emit(
        SchoolGalleryFetchSuccess(
          gallery: await _schoolRepository.fetchSchoolGallery(
            sessionYearId: sessionYearId,
            useParentApi: useParentApi,
            childId: childId,
            galleryId: galleryId,
          ),
        ),
      );
    } catch (e) {
      emit(SchoolGalleryFetchFailure(e.toString()));
    }
  }

  List<Gallery> getSchoolGallery() {
    if (state is SchoolGalleryFetchSuccess) {
      return (state as SchoolGalleryFetchSuccess).gallery;
    }
    return [];
  }
}
