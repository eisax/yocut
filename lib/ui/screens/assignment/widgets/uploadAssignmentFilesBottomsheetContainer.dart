import 'package:dotted_border/dotted_border.dart';
import 'package:yocut/cubits/uploadAssignmentCubit.dart';
import 'package:yocut/data/models/assignment.dart';
import 'package:yocut/ui/widgets/bottomsheetTopTitleAndCloseButton.dart';

import 'package:yocut/ui/widgets/customRoundedButton.dart';
import 'package:yocut/utils/labelKeys.dart';
import 'package:yocut/utils/utils.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/route_manager.dart';

class UploadAssignmentFilesBottomsheetContainer extends StatefulWidget {
  final Assignment assignment;

  const UploadAssignmentFilesBottomsheetContainer({
    super.key,
    required this.assignment,
  });

  @override
  State<UploadAssignmentFilesBottomsheetContainer> createState() =>
      _UploadAssignmentFilesBottomsheetContainerState();
}

class _UploadAssignmentFilesBottomsheetContainerState
    extends State<UploadAssignmentFilesBottomsheetContainer> {
  List<PlatformFile> uploadedFiles = [];

  Future<void> _pickFiles() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result != null) {
      uploadedFiles.addAll(result.files);
      setState(() {});
    }
  }

  Future<void> _addFiles() async {
    //upload files
    final permissionGiven = await Utils.hasStoragePermissionGiven();

    if (permissionGiven) {
      await _pickFiles();
    } else {
      if (context.mounted) {
        Utils.showCustomSnackBar(
            context: context,
            errorMessage:
                Utils.getTranslatedLabel(allowStoragePermissionToContinueKey),
            backgroundColor: Theme.of(context).colorScheme.error);
      }
    }
  }

  Widget _buildUploadedFileContainer(int fileIndex) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Theme.of(context).colorScheme.surface,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10.0),
      child: LayoutBuilder(
        builder: (context, boxConstraints) {
          return Row(
            children: [
              SizedBox(
                width: boxConstraints.maxWidth * (0.75),
                child: Text(
                  uploadedFiles[fileIndex].name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {
                  if (context.read<UploadAssignmentCubit>().state
                      is UploadAssignmentInProgress) {
                    return;
                  }
                  uploadedFiles.removeAt(fileIndex);
                  setState(() {});
                },
                icon: const Icon(Icons.close),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, _) {
        if (context.read<UploadAssignmentCubit>().state
            is UploadAssignmentInProgress) {
          context.read<UploadAssignmentCubit>().cancelUploadAssignmentProcess();
        }
      },
      child: SingleChildScrollView(
        child: Container(
          color: Theme.of(context).colorScheme.surface,
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * (0.075),
            vertical: MediaQuery.of(context).size.height * (0.04),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              BottomsheetTopTitleAndCloseButton(
                onTapCloseButton: () {
                  if (context.read<UploadAssignmentCubit>().state
                      is UploadAssignmentInProgress) {
                    context
                        .read<UploadAssignmentCubit>()
                        .cancelUploadAssignmentProcess();
                  }
                  Get.back();
                },
                titleKey: uploadFilesKey,
              ),
              uploadedFiles.isNotEmpty
                  ? Text(
                      Utils.getTranslatedLabel(
                        assignmentSubmissionDisclaimerKey,
                      ),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  : const SizedBox(),
              SizedBox(
                height: uploadedFiles.isNotEmpty
                    ? MediaQuery.of(context).size.height * (0.025)
                    : 0,
              ),
              InkWell(
                borderRadius: BorderRadius.circular(15),
                onTap: () async {
                  _addFiles();
                },
                child: DottedBorder(
                  borderType: BorderType.RRect,
                  dashPattern: const [10, 10],
                  radius: const Radius.circular(15.0),
                  color:
                      Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width * (0.8),
                    height: MediaQuery.of(context).size.height * (0.05),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).colorScheme.primary,
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 15,
                                offset: const Offset(0, 1.5),
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withValues(alpha: 0.3),
                              )
                            ],
                          ),
                          width: 25,
                          height: 25,
                          child: Icon(
                            Icons.add,
                            size: 15,
                            color: Theme.of(context).scaffoldBackgroundColor,
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * (0.05),
                        ),
                        Text(
                          Utils.getTranslatedLabel(addFilesKey),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * (0.025),
              ),
              ...List.generate(uploadedFiles.length, (index) => index)
                  .map((fileIndex) => _buildUploadedFileContainer(fileIndex))
                  ,
              uploadedFiles.isEmpty
                  ? const SizedBox()
                  : SizedBox(
                      height: MediaQuery.of(context).size.height * (0.025),
                    ),
              uploadedFiles.isNotEmpty
                  ? BlocConsumer<UploadAssignmentCubit, UploadAssignmentState>(
                      listener: (context, state) {
                        if (state is UploadAssignmentFetchSuccess) {
                          Get.back(result: {
                            "error": false,
                            "assignmentSubmission": state.assignmentSubmission
                          });
                        } else if (state is UploadAssignmentFailure) {
                          Get.back(result: {
                            "error": true,
                            "message": state.errorMessage
                          });
                        }
                      },



                      builder: (context, state) {
                        return CustomRoundedButton(
                          onTap: () {
                            if (state is UploadAssignmentInProgress) {
                              return;
                            }
                            final filePaths = uploadedFiles
                                .map((file) => file.path)
                                .whereType<String>()
                                .toList();
                            if (filePaths.isNotEmpty) {
                              context
                                  .read<UploadAssignmentCubit>()
                                  .uploadAssignment(
                                    assignmentId: widget.assignment.id,
                                    filePaths: filePaths,
                                  );
                            }
                          },
                          height: 40,
                          widthPercentage:
                              state is UploadAssignmentInProgress ? 0.65 : 0.35,
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          buttonTitle: state is UploadAssignmentInProgress
                              ? "${Utils.getTranslatedLabel(submittingKey)} (${state.uploadedProgress.toStringAsFixed(2)})%"
                              : Utils.getTranslatedLabel(submitKey),
                          showBorder: false,
                        );
                      },
                    )
                  : const SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}

