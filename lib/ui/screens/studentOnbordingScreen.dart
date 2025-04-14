import 'package:cached_network_image/cached_network_image.dart';
import 'package:yocut/app/routes.dart';
import 'package:yocut/cubits/schoolDetailsCubit.dart';
import 'package:yocut/utils/hiveBoxKeys.dart';
import 'package:yocut/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class StudentOnbordingScreen extends StatefulWidget {
  const StudentOnbordingScreen({super.key});

  @override
  State<StudentOnbordingScreen> createState() => _StudentOnbordingScreenState();
  static Widget routeInstance() {
    return StudentOnbordingScreen();
  }
}

class _StudentOnbordingScreenState extends State<StudentOnbordingScreen> {
  @override
  void initState() {
    context.read<SchooldetailsCubit>().fetchSchooldetails();
    super.initState();
    _checkFirstTimeUser();
  }

  Future<void> _checkFirstTimeUser() async {
    var box = await Hive.openBox(studentBoxKey);
    bool isFirstTime = box.get('isFirstTimestudent', defaultValue: true);
    if (isFirstTime) {
      await box.put('isFirstTimestudent', false);

      Future.delayed(Duration(seconds: 5), () {
        Get.offNamedUntil(Routes.home, (Route<dynamic> route) => false);
      });
    } else {
      Get.offNamedUntil(Routes.home, (Route<dynamic> route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: BlocBuilder<SchooldetailsCubit, SchooldetailsState>(
      builder: (context, state) {
        if (state is SchooldetailsFetchSuccess) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                  top: context.height * (0.06), left: 15, right: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CachedNetworkImage(
                    imageUrl: '${state.schoolDetails.body.profile.firstName}',
                    errorWidget: (context, url, error) => SvgPicture.asset(
                      fit: BoxFit.fill,
                      Utils.getImagePath("appLogo.svg"),
                    ),
                    height: context.height * 0.17,
                    width: context.width * 0.4,
                    fit: BoxFit.fill,
                  ),
                  SizedBox(height: context.height * 0.03),
                  Text(
                    '${state.schoolDetails.body.profile.firstName}',
                    style: TextStyle(
                      fontSize: Utils.screenOnbordingTitleFontSize,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff22577a),
                    ),
                  ),
                  GridView.builder(
                    padding: EdgeInsets.only(top: context.height * 0.03),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 8,
                      mainAxisExtent: context.height * 0.22,
                    ),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      String? imageUrl = (state.schoolDetails.body.profile.firstName !=
                                  null &&
                              state.schoolDetails.body.profile.firstName!.length > index)
                          ? state.schoolDetails.body.profile.firstName![index]
                          : '';

                      return ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: imageUrl.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: imageUrl,
                                placeholder: (context, url) => Center(
                                  child: CircularProgressIndicator(),
                                ),
                                errorWidget: (context, url, error) =>
                                    SvgPicture.asset(
                                  Utils.getImagePath("appLogo.svg"),
                                  fit: BoxFit.fill,
                                ),
                                fit: BoxFit.fill,
                              )
                            : SvgPicture.asset(
                                Utils.getImagePath("appLogo.svg"),
                                fit: BoxFit.fill,
                              ),
                      );
                    },
                  ),
                  SizedBox(height: context.height * 0.03),
                  Text(
                    '${state.schoolDetails.body.profile.firstName}',
                    style: TextStyle(
                      fontSize: Utils.screenOnbordingTitleFontSize,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff22577a),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }
        if (state is SchooldetailsFetchInProgress) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Container();
      },
    ));
  }
}
