import 'package:yocut/cubits/schoolConfigurationCubit.dart';
import 'package:yocut/cubits/studentAllProfileDetailsCubit.dart';
import 'package:yocut/data/models/student.dart';
import 'package:yocut/data/repositories/studentRepository.dart';
import 'package:yocut/ui/styles/colors.dart';
import 'package:yocut/ui/widgets/customShimmerContainer.dart';
import 'package:yocut/ui/widgets/customUserProfileImageWidget.dart';
import 'package:yocut/ui/widgets/customAppbar.dart';
import 'package:yocut/ui/widgets/errorContaineer.dart';
import 'package:yocut/ui/widgets/shimmerLoadingContainer.dart';
import 'package:yocut/utils/labelKeys.dart';
import 'package:yocut/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class StudentProfileScreen extends StatefulWidget {
  final int? childId;

  const StudentProfileScreen({Key? key, this.childId}) : super(key: key);

  @override
  State<StudentProfileScreen> createState() => _StudentProfileScreenState();

  static Widget routeInstance() {
    return BlocProvider(
      create: (context) => StudentAllProfileDetailsCubit(StudentRepository()),
      child: StudentProfileScreen(
        childId: Get.arguments as int?,
      ),
    );
  }
}

class _StudentProfileScreenState extends State<StudentProfileScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      fetchStudentAllProfileDetails();
    });
  }

  void fetchStudentAllProfileDetails() {
    context.read<StudentAllProfileDetailsCubit>().getStudentAllProfileDetails(
        useParentApi: widget.childId != null, childId: widget.childId);
  }

  Widget _buildProfileDetailsTile({
    required String label,
    required String value,
    required String iconUrl,
    Color? iconColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12.5),
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              boxShadow: const [
                BoxShadow(
                  color: Color(0x1a212121),
                  offset: Offset(0, 10),
                  blurRadius: 16,
                )
              ],
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: SvgPicture.asset(
              iconUrl,
              theme: SvgTheme(
                  currentColor:
                      iconColor ?? Theme.of(context).scaffoldBackgroundColor),
              colorFilter: iconColor == null
                  ? null
                  : ColorFilter.mode(iconColor, BlendMode.srcIn),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * (0.05),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(top: 3.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.w400,
                      fontSize: 12.0,
                    ),
                  ),
                  Text(
                    value,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.w500,
                      fontSize: 14.0,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Align(
      alignment: Alignment.topCenter,
      child: CustomAppBar(
        title: Utils.getTranslatedLabel(profileKey),
      ),
    );
  }

  Widget _buildProfileDetailsContainer({required Student studentDetails}) {
    return Align(
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          top: Utils.getScrollViewTopPadding(
            context: context,
            appBarHeightPercentage: Utils.appBarSmallerHeightPercentage,
          ),
        ),
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * (0.25),
              height: MediaQuery.of(context).size.width * (0.25),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.primary,
              ),
              child: CustomUserProfileImageWidget(
                profileUrl: studentDetails.image ?? "",
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              studentDetails.getFullName(),
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.secondary,
                fontSize: 18.0,
              ),
            ),
            const SizedBox(
              height: 5.0,
            ),
            Text(
              "${Utils.getTranslatedLabel(grNumberKey)} - ${studentDetails.admissionNo}",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 12.0,
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * (0.075),
              ),
              child: Divider(
                color:
                    Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.75),
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * (0.075),
              ),
              child: Column(
                children: [
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      Utils.getTranslatedLabel(personalDetailsKey),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 15.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  _buildProfileDetailsTile(
                    label: Utils.getTranslatedLabel(schoolKey),
                    value: Utils.formatEmptyValue(
                        ("${studentDetails.school?.name} (${studentDetails.school?.code})")),
                    iconUrl: Utils.getImagePath("school.svg"),
                  ),
                  _buildProfileDetailsTile(
                    label: Utils.getTranslatedLabel(classKey),
                    value: Utils.formatEmptyValue(
                      studentDetails.classSection?.fullName ?? "",
                    ),
                    iconUrl: Utils.getImagePath("user_pro_class_icon.svg"),
                  ),
                  (studentDetails.classSection?.classDetails
                                  ?.includeSemesters ??
                              0) ==
                          1
                      ? _buildProfileDetailsTile(
                          label: Utils.getTranslatedLabel(semesterKey),
                          value: Utils.formatEmptyValue(
                            context
                                    .read<SchoolConfigurationCubit>()
                                    .getSchoolConfiguration()
                                    .semesterDetails
                                    .name ??
                                "",
                          ),
                          iconColor: Theme.of(context).scaffoldBackgroundColor,
                          iconUrl: Utils.getImagePath("sem_pro_icon.svg"),
                        )
                      : const SizedBox(),
                  (studentDetails.classSection?.classDetails?.streamDetails
                                  ?.name ??
                              "")
                          .isNotEmpty
                      ? _buildProfileDetailsTile(
                          label: Utils.getTranslatedLabel(streamKey),
                          value: Utils.formatEmptyValue(
                            studentDetails.classSection?.classDetails
                                    ?.streamDetails?.name ??
                                "",
                          ),
                          iconColor: Theme.of(context).scaffoldBackgroundColor,
                          iconUrl: Utils.getImagePath("stream_pro_icon.svg"),
                        )
                      : const SizedBox(),
                  _buildProfileDetailsTile(
                    label: Utils.getTranslatedLabel(mediumKey),
                    value: Utils.formatEmptyValue(
                      studentDetails.classSection?.medium?.name ?? "",
                    ),
                    iconUrl: Utils.getImagePath("medium_icon.svg"),
                  ),
                  if (studentDetails.classSection?.classDetails?.shift?.name !=
                          null &&
                      (studentDetails.classSection?.classDetails?.shift?.name ??
                              "")
                          .trim()
                          .isNotEmpty)
                    _buildProfileDetailsTile(
                      label: Utils.getTranslatedLabel(shiftKey),
                      value: Utils.formatEmptyValue(
                        "${studentDetails.classSection!.classDetails!.shift!.name} (${studentDetails.classSection!.classDetails!.shift!.startToEndTime ?? ''})",
                      ),
                      iconUrl: Utils.getImagePath("user_pro_shift_icon.svg"),
                    ),
                  _buildProfileDetailsTile(
                    label: Utils.getTranslatedLabel(rollNumberKey),
                    value: studentDetails.rollNumber.toString(),
                    iconUrl: Utils.getImagePath("Hello.svg"),
                  ),
                  _buildProfileDetailsTile(
                    label: Utils.getTranslatedLabel(dateOfBirthKey),
                    value: Utils.formatEmptyValue(
                        DateTime.tryParse(studentDetails.dob ?? "") == null
                            ? "-"
                            : Utils.formatDate(
                                DateTime.tryParse(studentDetails.dob!)!)),
                    iconUrl: Utils.getImagePath("user_pro_dob_icon.svg"),
                  ),
                  _buildProfileDetailsTile(
                    label: Utils.getTranslatedLabel(
                      currentAddressKey,
                    ),
                    value: Utils.formatEmptyValue(
                      studentDetails.currentAddress ?? "",
                    ),
                    iconUrl: Utils.getImagePath("user_pro_address_icon.svg"),
                  ),
                  _buildProfileDetailsTile(
                    label: Utils.getTranslatedLabel(
                      permanentAddressKey,
                    ),
                    value: Utils.formatEmptyValue(
                      studentDetails.permanentAddress ?? "",
                    ),
                    iconUrl: Utils.getImagePath("user_pro_address_icon.svg"),
                  ),
                  ...(studentDetails.studentProfileExtraDetails ?? [])
                      .map(
                        (details) => _buildProfileDetailsTile(
                          label: Utils.getTranslatedLabel(
                            details.formField?.name ?? "",
                          ),
                          value: Utils.formatEmptyValue(
                            details.data ?? "",
                          ),
                          iconColor: Theme.of(context).scaffoldBackgroundColor,
                          iconUrl: Utils.getImagePath("info_pro_icon.svg"),
                        ),
                      )
                      .toList(),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * (0.1),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentDetailsValueShimmerLoading(
      BoxConstraints boxConstraints) {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        ShimmerLoadingContainer(
          child: CustomShimmerContainer(
            margin: EdgeInsetsDirectional.only(
              end: boxConstraints.maxWidth * (0.7),
            ),
            height: 8,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        ShimmerLoadingContainer(
          child: CustomShimmerContainer(
            margin: EdgeInsetsDirectional.only(
              end: boxConstraints.maxWidth * (0.5),
            ),
            height: 8,
          ),
        ),
      ],
    );
  }

  Widget _buildStudentDetailsShimmerLoading() {
    return Padding(
      padding: EdgeInsets.only(
        top: Utils.getScrollViewTopPadding(
          context: context,
          appBarHeightPercentage: Utils.appBarSmallerHeightPercentage,
        ),
      ),
      child: Center(
        child: LayoutBuilder(
          builder: (context, boxConstraints) {
            return Column(
              children: [
                ShimmerLoadingContainer(
                  child: Container(
                    width: MediaQuery.of(context).size.width * (0.25),
                    height: MediaQuery.of(context).size.width * (0.25),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ShimmerLoadingContainer(
                        child: Divider(
                          color: shimmerContentColor,
                          height: 2,
                        ),
                      ),
                      _buildStudentDetailsValueShimmerLoading(boxConstraints),
                      const SizedBox(
                        height: 20,
                      ),
                      _buildStudentDetailsValueShimmerLoading(boxConstraints),
                      const SizedBox(
                        height: 20,
                      ),
                      _buildStudentDetailsValueShimmerLoading(boxConstraints),
                      const SizedBox(
                        height: 20,
                      ),
                      _buildStudentDetailsValueShimmerLoading(boxConstraints),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BlocBuilder<StudentAllProfileDetailsCubit,
              StudentAllProfileDetailsState>(builder: (context, state) {
            if (state is StudentAllProfileDetailsFetchSuccess) {
              return _buildProfileDetailsContainer(
                  studentDetails: state.student);
            }
            if (state is StudentAllProfileDetailsFetchFailure) {
              return Center(
                child: ErrorContainer(
                  errorMessageCode: state.errorMessage,
                  onTapRetry: () {
                    fetchStudentAllProfileDetails();
                  },
                ),
              );
            }

            return _buildStudentDetailsShimmerLoading();
          }),
          _buildAppBar(),
        ],
      ),
    );
  }
}
