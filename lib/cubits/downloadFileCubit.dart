import 'dart:io';

import 'package:dio/dio.dart';
import 'package:yocut/data/models/studyMaterial.dart';
import 'package:yocut/data/repositories/subjectRepository.dart';
import 'package:yocut/utils/errorMessageKeysAndCodes.dart';
import 'package:yocut/utils/utils.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

abstract class DownloadFileState {}

class DownloadFileInitial extends DownloadFileState {}

class DownloadFileInProgress extends DownloadFileState {
  final double uploadedPercentage;

  DownloadFileInProgress(this.uploadedPercentage);
}

class DownloadFileSuccess extends DownloadFileState {
  final String downloadedFileUrl;

  DownloadFileSuccess(this.downloadedFileUrl);
}

class DownloadFileProcessCanceled extends DownloadFileState {}

class DownloadFileFailure extends DownloadFileState {
  final String errorMessage;

  DownloadFileFailure(this.errorMessage);
}

class DownloadFileCubit extends Cubit<DownloadFileState> {
  final SubjectRepository _subjectRepository;

  DownloadFileCubit(this._subjectRepository) : super(DownloadFileInitial());

  final CancelToken _cancelToken = CancelToken();

  void _downloadedFilePercentage(double percentage) {
    emit(DownloadFileInProgress(percentage));
  }

  Future<void> writeFileFromTempStorage({
    required String sourcePath,
    required String destinationPath,
  }) async {
    final tempFile = File(sourcePath);
    final byteData = await tempFile.readAsBytes();
    final downloadedFile = File(destinationPath);
    //write into downloaded file
    await downloadedFile.writeAsBytes(
      byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes),
    );
  }

  Future<void> downloadFile({
    required StudyMaterial studyMaterial,
    required bool storeInExternalStorage,
  }) async {
    emit(DownloadFileInProgress(0.0));
    try {
      //if wants to download the file then
      if (storeInExternalStorage) {
        Future<void> thingsToDoAfterPermissionIsGiven(
            bool isPermissionGranted) async {
          //storing the fie temp
          final Directory tempDir = await getTemporaryDirectory();
          final tempFileSavePath =
              "${tempDir.path}/${studyMaterial.fileName}.${studyMaterial.fileExtension}";

          await _subjectRepository.downloadStudyMaterialFile(
            cancelToken: _cancelToken,
            savePath: tempFileSavePath,
            updateDownloadedPercentage: _downloadedFilePercentage,
            url: studyMaterial.fileUrl,
          );

          //download file
          String downloadFilePath = Platform.isAndroid && isPermissionGranted
              ? (await getExternalStorageDirectory())?.path ?? ""
              : (await getApplicationDocumentsDirectory()).path;

          downloadFilePath =
              "$downloadFilePath/${studyMaterial.fileName}.${studyMaterial.fileExtension}";

          await writeFileFromTempStorage(
            sourcePath: tempFileSavePath,
            destinationPath: downloadFilePath,
          );

          emit(DownloadFileSuccess(downloadFilePath));
        }

        //if user has given permission to download and view file or if it is for android
        if (await Utils.hasStoragePermissionGiven()) {
          await thingsToDoAfterPermissionIsGiven(true);
        } else {
          //if user does not give permission to store files in download directory
          emit(
            DownloadFileFailure(
              ErrorMessageKeysAndCode.permissionNotGivenCode,
            ),
          );
          openAppSettings();
        }
      } else {
        //download file for just to see
        final Directory tempDir = await getTemporaryDirectory();
        final savePath =
            "${tempDir.path}/${studyMaterial.fileName}.${studyMaterial.fileExtension}";

        await _subjectRepository.downloadStudyMaterialFile(
          cancelToken: _cancelToken,
          savePath: savePath,
          updateDownloadedPercentage: _downloadedFilePercentage,
          url: studyMaterial.fileUrl,
        );

        emit(DownloadFileSuccess(savePath));
      }
    } catch (e) {
      if (_cancelToken.isCancelled) {
        emit(DownloadFileProcessCanceled());
      } else {
        emit(DownloadFileFailure(e.toString()));
      }
    }
  }

  void cancelDownloadProcess() {
    _cancelToken.cancel();
  }
}
