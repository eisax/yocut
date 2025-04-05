import 'package:yocut/app/routes.dart';
import 'package:yocut/cubits/authCubit.dart';
import 'package:yocut/cubits/studentSubjectAndSlidersCubit.dart';
import 'package:yocut/utils/labelKeys.dart';
import 'package:yocut/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({Key? key}) : super(key: key);

  void showLogOutDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        content: Text(Utils.getTranslatedLabel(sureToLogoutKey)),
        actions: [
          CupertinoButton(
            child: Text(Utils.getTranslatedLabel(yesKey)),
            onPressed: () {
              //clear the student subjects list at the time of logout
              context.read<StudentSubjectsAndSlidersCubit>().clearSubjects();

              if (context.read<AuthCubit>().isParent()) {
                //If parent is logging out then pop the dialog
                Get.back();
              }
              context.read<AuthCubit>().signOut();
              Get.back();
              Get.offNamed(Routes.auth);
            },
          ),
          CupertinoButton(
            child: Text(Utils.getTranslatedLabel(noKey)),
            onPressed: () {
              Get.back();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: InkWell(
        onTap: () {
          showLogOutDialog(context);
        },
        borderRadius: BorderRadius.circular(20.0),
        child: Container(
          width: MediaQuery.of(context).size.width * (0.4),
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: Theme.of(context).colorScheme.secondary,
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 16,
                  width: 16,
                  child: SvgPicture.asset(
                    Utils.getImagePath("logout_icon.svg"),
                  ),
                ),
                const SizedBox(
                  width: 10.0,
                ),
                Text(
                  Utils.getTranslatedLabel(logoutKey),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
