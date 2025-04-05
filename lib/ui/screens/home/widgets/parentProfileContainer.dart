import 'package:yocut/cubits/studentGuardianDetailsCubit.dart';
import 'package:yocut/ui/styles/colors.dart';
import 'package:yocut/ui/widgets/customShimmerContainer.dart';
import 'package:yocut/ui/widgets/errorContaineer.dart';
import 'package:yocut/ui/widgets/guardianDetailsContainer.dart';
import 'package:yocut/ui/widgets/screenTopBackgroundContainer.dart';
import 'package:yocut/ui/widgets/shimmerLoadingContainer.dart';
import 'package:yocut/utils/labelKeys.dart';
import 'package:yocut/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GuardianProfileContainer extends StatefulWidget {
  const GuardianProfileContainer({Key? key}) : super(key: key);

  @override
  State<GuardianProfileContainer> createState() =>
      _GuardianProfileContainerState();
}

class _GuardianProfileContainerState extends State<GuardianProfileContainer> {
  @override
  void initState() {
    super.initState();
    fetchGuardianDetails();
  }

  void fetchGuardianDetails() {
    Future.delayed(Duration.zero, () {
      context.read<StudentGuardianDetailsCubit>().getStudentGuardianDetails();
    });
  }

  Widget _buildGuardianDetailsValueShimmerLoading(
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

  Widget _buildGuardianDetailsShimmerLoading() {
    return Container(
      width: MediaQuery.of(context).size.width * (0.8),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.0)),
      child: LayoutBuilder(
        builder: (context, boxConstraints) {
          return Stack(
            clipBehavior: Clip.none,
            children: [
              PositionedDirectional(
                top: -40,
                start: MediaQuery.of(context).size.width * (0.4) - 42.5,
                child: ShimmerLoadingContainer(
                  child: Container(
                    width: 85.0,
                    height: 85.0,
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(shape: BoxShape.circle),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: shimmerContentColor,
                      ),
                    ),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ShimmerLoadingContainer(
                    child: Divider(
                      color: shimmerContentColor,
                      height: 2,
                    ),
                  ),
                  _buildGuardianDetailsValueShimmerLoading(boxConstraints),
                  const SizedBox(
                    height: 70,
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAppBar() {
    return ScreenTopBackgroundContainer(
      padding: EdgeInsets.zero,
      heightPercentage: Utils.appBarSmallerHeightPercentage,
      child: Stack(
        children: [
          Align(
            child: Text(
              Utils.getTranslatedLabel(guardianDetailsKey),
              style: TextStyle(
                color: Theme.of(context).scaffoldBackgroundColor,
                fontSize: Utils.screenTitleFontSize,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BlocBuilder<StudentGuardianDetailsCubit, StudentGuardianDetailsState>(
          builder: (context, state) {
            if (state is StudentGuardianDetailsFetchSuccess) {
              return Align(
                alignment: Alignment.topCenter,
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(
                    bottom: Utils.getScrollViewBottomPadding(context),
                    top: MediaQuery.of(context).size.height *
                        (Utils.appBarSmallerHeightPercentage + 0.075),
                  ),
                  child: Column(
                    children: [
                      GuardianDetailsContainer(
                        guardian: state.guardian,
                      ),
                    ],
                  ),
                ),
              );
            }
            if (state is StudentGuardianDetailsFetchFailure) {
              return Center(
                  child: ErrorContainer(
                      onTapRetry: () {
                        context
                            .read<StudentGuardianDetailsCubit>()
                            .getStudentGuardianDetails();
                      },
                      errorMessageCode: state.errorMessage));
            }

            return Align(
              alignment: Alignment.topCenter,
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  bottom: Utils.getScrollViewBottomPadding(context),
                  top: MediaQuery.of(context).size.height *
                      (Utils.appBarSmallerHeightPercentage + 0.075),
                ),
                child: Center(
                  child: _buildGuardianDetailsShimmerLoading(),
                ),
              ),
            );
          },
        ),
        Align(
          alignment: Alignment.topCenter,
          child: _buildAppBar(),
        ),
      ],
    );
  }
}
