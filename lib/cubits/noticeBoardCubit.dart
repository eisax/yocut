import 'package:yocut/data/models/announcement.dart';
import 'package:yocut/data/repositories/announcementRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class NoticeBoardState {}

class NoticeBoardInitial extends NoticeBoardState {}

class NoticeBoardFetchInProgress extends NoticeBoardState {}

class NoticeBoardFetchSuccess extends NoticeBoardState {
  final List<Announcement> announcements;
  final int totalPage;
  final int currentPage;
  final bool moreAnnouncementsFetchError;
  final bool fetchMoreAnnouncementsInProgress;

  NoticeBoardFetchSuccess({
    required this.announcements,
    required this.fetchMoreAnnouncementsInProgress,
    required this.moreAnnouncementsFetchError,
    required this.currentPage,
    required this.totalPage,
  });

  NoticeBoardFetchSuccess copyWith({
    List<Announcement>? newAnnouncements,
    bool? newFetchMoreAnnouncementsInProgress,
    bool? newMoreAnnouncementsFetchError,
    int? newCurrentPage,
    int? newTotalPage,
  }) {
    return NoticeBoardFetchSuccess(
      announcements: newAnnouncements ?? announcements,
      fetchMoreAnnouncementsInProgress: newFetchMoreAnnouncementsInProgress ??
          fetchMoreAnnouncementsInProgress,
      moreAnnouncementsFetchError:
          newMoreAnnouncementsFetchError ?? moreAnnouncementsFetchError,
      currentPage: newCurrentPage ?? currentPage,
      totalPage: newTotalPage ?? totalPage,
    );
  }
}

class NoticeBoardFetchFailure extends NoticeBoardState {
  final String errorMessage;

  NoticeBoardFetchFailure({required this.errorMessage});
}

class NoticeBoardCubit extends Cubit<NoticeBoardState> {
  final AnnouncementRepository _announcementRepository;

  NoticeBoardCubit(this._announcementRepository) : super(NoticeBoardInitial());

  Future<void> fetchNoticeBoardDetails(
      {required bool useParentApi, int? childId}) async {
    try {
      emit(NoticeBoardFetchInProgress());
      final result = await _announcementRepository.fetchAnnouncements(
        isGeneralAnnouncement: true,
        childId: childId ?? 0,
        useParentApi: useParentApi,
      );
      emit(
        NoticeBoardFetchSuccess(
          announcements: result['announcements'],
          fetchMoreAnnouncementsInProgress: false,
          moreAnnouncementsFetchError: false,
          currentPage: result['currentPage'],
          totalPage: result['totalPage'],
        ),
      );
    } catch (e) {
      emit(NoticeBoardFetchFailure(errorMessage: e.toString()));
    }
  }

  bool hasMore() {
    if (state is NoticeBoardFetchSuccess) {
      return (state as NoticeBoardFetchSuccess).currentPage <
          (state as NoticeBoardFetchSuccess).totalPage;
    }
    return false;
  }

  Future<void> fetchMoreAnnouncements({required bool useParentApi}) async {
    if (state is NoticeBoardFetchSuccess) {
      if ((state as NoticeBoardFetchSuccess).fetchMoreAnnouncementsInProgress) {
        return;
      }
      try {
        emit(
          (state as NoticeBoardFetchSuccess)
              .copyWith(newFetchMoreAnnouncementsInProgress: true),
        );
        //fetch more announcements
        //more announcements result
        final moreAssignmentsResult =
            await _announcementRepository.fetchAnnouncements(
          isGeneralAnnouncement: true,
          childId: 0,
          useParentApi: useParentApi,
          page: (state as NoticeBoardFetchSuccess).currentPage + 1,
        );

        final currentState = state as NoticeBoardFetchSuccess;
        List<Announcement> announcements = currentState.announcements;

        //add more announcements into original announcements list
        announcements.addAll(moreAssignmentsResult['announcements']);

        emit(
          NoticeBoardFetchSuccess(
            fetchMoreAnnouncementsInProgress: false,
            announcements: announcements,
            moreAnnouncementsFetchError: false,
            currentPage: moreAssignmentsResult['currentPage'],
            totalPage: moreAssignmentsResult['totalPage'],
          ),
        );
      } catch (e) {
        emit(
          (state as NoticeBoardFetchSuccess).copyWith(
            newFetchMoreAnnouncementsInProgress: false,
            newMoreAnnouncementsFetchError: true,
          ),
        );
      }
    }
  }
}
