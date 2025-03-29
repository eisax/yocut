import 'package:yocut/utils/labelKeys.dart';
import 'package:yocut/utils/systemModules.dart';
import 'package:yocut/utils/utils.dart';

class Menu {
  final String title;
  final String iconUrl;
  final String menuModuleId; //This is fixed

  Menu(
      {required this.iconUrl, required this.title, required this.menuModuleId});
}

//To add all more menu here

final List<Menu> homeBottomSheetMenu = [
  Menu(
      menuModuleId: attendanceManagementModuleId.toString(),
      iconUrl: Utils.getImagePath("attendance_icon.svg"),
      title: attendanceKey),
  Menu(
    menuModuleId: timetableManagementModuleId.toString(),
    iconUrl: Utils.getImagePath("timetable_icon.svg"),
    title: timeTableKey,
  ),
  Menu(
    menuModuleId: announcementManagementModuleId.toString(),
    iconUrl: Utils.getImagePath("noticeboard_icon.svg"),
    title: noticeBoardKey,
  ),
  Menu(
      menuModuleId: examManagementModuleId.toString(),
      iconUrl: Utils.getImagePath("exam_icon.svg"),
      title: examsKey),
  Menu(
      menuModuleId: examManagementModuleId.toString(),
      iconUrl: Utils.getImagePath("result_icon.svg"),
      title: resultKey),

  //Report module is combination of assginement and exam
  Menu(
      menuModuleId:
          "$assignmentManagementModuleId$moduleIdJoiner$examManagementModuleId",
      iconUrl: Utils.getImagePath("reports_icon.svg"),
      title: reportsKey),
  Menu(
    menuModuleId: defaultModuleId.toString(),
    iconUrl: Utils.getImagePath("parent_icon.svg"),
    title: guardianDetailsKey,
  ),
  Menu(
      iconUrl: Utils.getImagePath("holiday_icon.svg"),
      title: holidaysKey,
      menuModuleId: holidayManagementModuleId.toString()),
  Menu(
      iconUrl: Utils.getImagePath("gallery.svg"),
      title: galleryKey,
      menuModuleId: galleryManagementModuleId.toString()),
  Menu(
      iconUrl: Utils.getImagePath("setting_icon.svg"),
      title: settingsKey,
      menuModuleId: defaultModuleId.toString()),
];
