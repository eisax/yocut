import 'dart:io';

// import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:yocut/app/appTranslation.dart';
import 'package:yocut/cubits/assignmentReportCubit.dart';
import 'package:yocut/cubits/assignmentsCubit.dart';
import 'package:yocut/cubits/childFeeDetailsCubit.dart';
import 'package:yocut/cubits/onlineExamReportCubit.dart';
import 'package:yocut/cubits/resultsOnlineCubit.dart';
import 'package:yocut/cubits/schoolConfigurationCubit.dart';
import 'package:yocut/cubits/schoolDetailsCubit.dart';
import 'package:yocut/cubits/socketSettingCubit.dart';
import 'package:yocut/data/repositories/assignmentRepository.dart';
import 'package:yocut/data/repositories/feeRepository.dart';
import 'package:yocut/data/repositories/resultRepository.dart';
import 'package:yocut/data/repositories/schoolDetailsRepository.dart';
import 'package:yocut/data/repositories/schoolRepository.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:yocut/app/routes.dart';

import 'package:yocut/cubits/appConfigurationCubit.dart';
import 'package:yocut/cubits/appLocalizationCubit.dart';
import 'package:yocut/cubits/authCubit.dart';
import 'package:yocut/cubits/examDetailsCubit.dart';
import 'package:yocut/cubits/examsOnlineCubit.dart';
import 'package:yocut/cubits/noticeBoardCubit.dart';
import 'package:yocut/cubits/notificationSettingsCubit.dart';
import 'package:yocut/cubits/postFeesPaymentCubit.dart';
import 'package:yocut/cubits/reportTabSelectionCubit.dart';
import 'package:yocut/cubits/resultTabSelectionCubit.dart';
import 'package:yocut/cubits/studentSubjectAndSlidersCubit.dart';
import 'package:yocut/cubits/examTabSelectionCubit.dart';

import 'package:yocut/data/repositories/announcementRepository.dart';
import 'package:yocut/data/repositories/authRepository.dart';
import 'package:yocut/data/repositories/onlineExamRepository.dart';
import 'package:yocut/data/repositories/settingsRepository.dart';
import 'package:yocut/data/repositories/studentRepository.dart';
import 'package:yocut/data/repositories/systemInfoRepository.dart';

import 'package:yocut/cubits/onlineExamQuestionsCubit.dart';
import 'package:yocut/data/repositories/reportRepository.dart';
import 'package:yocut/ui/styles/colors.dart';

import 'package:yocut/utils/hiveBoxKeys.dart';
import 'package:yocut/utils/notificationUtility.dart';
import 'package:yocut/utils/utils.dart';
import 'package:intl/date_symbol_data_local.dart';

//to avoid handshake error on some devices
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  //Register the licence of font
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await AppTranslation.loadJsons();

  await NotificationUtility.initializeAwesomeNotification();

  await Hive.initFlutter();
  await Hive.openBox(showCaseBoxKey);
  await Hive.openBox(authBoxKey);
  await Hive.openBox(notificationsBoxKey);
  await Hive.openBox(settingsBoxKey);
  await Hive.openBox(studentSubjectsBoxKey);
  await initializeDateFormatting('en_US', null);

  runApp(const MyApp());
}

class GlobalScrollBehavior extends ScrollBehavior {
  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const BouncingScrollPhysics();
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // AwesomeNotifications().setListeners(
    //   onActionReceivedMethod: NotificationUtility.onActionReceivedMethod,
    //   onNotificationCreatedMethod:
    //       NotificationUtility.onNotificationCreatedMethod,
    //   onNotificationDisplayedMethod:
    //       NotificationUtility.onNotificationDisplayedMethod,
    //   onDismissActionReceivedMethod:
    //       NotificationUtility.onDismissActionReceivedMethod,
    // );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //preloading some of the imaegs
    precacheImage(
      AssetImage(Utils.getImagePath("upper_pattern.png")),
      context,
    );
    precacheImage(
      AssetImage(Utils.getImagePath("lower_pattern.png")),
      context,
    );
    return MultiBlocProvider(
      providers: [
        BlocProvider<SchooldetailsCubit>(
          create: (_) => SchooldetailsCubit(SchooldetailsfetchRepository()),
        ),
        BlocProvider<AppLocalizationCubit>(
          create: (_) => AppLocalizationCubit(SettingsRepository()),
        ),
        BlocProvider<NotificationSettingsCubit>(
          create: (_) => NotificationSettingsCubit(SettingsRepository()),
        ),
        BlocProvider<AuthCubit>(create: (_) => AuthCubit(AuthRepository())),
        BlocProvider<StudentSubjectsAndSlidersCubit>(
          create: (_) => StudentSubjectsAndSlidersCubit(),
        ),
        BlocProvider<NoticeBoardCubit>(
          create: (context) => NoticeBoardCubit(AnnouncementRepository()),
        ),
        BlocProvider<AppConfigurationCubit>(
          create: (context) => AppConfigurationCubit(SystemRepository()),
        ),
        BlocProvider<ExamDetailsCubit>(
          create: (context) => ExamDetailsCubit(StudentRepository()),
        ),
        BlocProvider<PostFeesPaymentCubit>(
          create: (context) => PostFeesPaymentCubit(StudentRepository()),
        ),
        BlocProvider<ResultTabSelectionCubit>(
          create: (_) => ResultTabSelectionCubit(),
        ),
        BlocProvider<ReportTabSelectionCubit>(
          create: (_) => ReportTabSelectionCubit(),
        ),
        BlocProvider<OnlineExamReportCubit>(
          create: (_) => OnlineExamReportCubit(ReportRepository()),
        ),
        BlocProvider<AssignmentReportCubit>(
          create: (_) => AssignmentReportCubit(ReportRepository()),
        ),
        BlocProvider<ExamTabSelectionCubit>(
          create: (_) => ExamTabSelectionCubit(),
        ),
        BlocProvider<OnlineExamQuestionsCubit>(
          create: (_) => OnlineExamQuestionsCubit(OnlineExamRepository()),
        ),
        BlocProvider<ExamsOnlineCubit>(
          create: (_) => ExamsOnlineCubit(OnlineExamRepository()),
        ),
        BlocProvider<ResultsOnlineCubit>(
          create: (_) => ResultsOnlineCubit(ResultRepository()),
        ),
        BlocProvider<AssignmentsCubit>(
          create: (_) => AssignmentsCubit(AssignmentRepository()),
        ),
        BlocProvider<SchoolConfigurationCubit>(
            create: (_) => SchoolConfigurationCubit(SchoolRepository())),
        BlocProvider<ChildFeeDetailsCubit>(
            create: (_) => ChildFeeDetailsCubit(FeeRepository())),
        BlocProvider<SocketSettingCubit>(
            create: (context) => SocketSettingCubit())
      ],
      child: Builder(
        builder: (context) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            theme: Theme.of(context).copyWith(
              textTheme:
                  GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
              scaffoldBackgroundColor: pageBackgroundColor,
              colorScheme: Theme.of(context).colorScheme.copyWith(
                    primary: primaryColor,
                    onPrimary: onPrimaryColor,
                    secondary: secondaryColor,
                    surface: backgroundColor,
                    error: errorColor,
                    onSecondary: onSecondaryColor,
                    onSurface: onBackgroundColor,
                  ),
            ),
            locale: context.read<AppLocalizationCubit>().state.language,
            getPages: Routes.getPages,
            initialRoute: Routes.splash,
            fallbackLocale: const Locale("en"),
            translationsKeys: AppTranslation.translationsKeys,
          );
        },
      ),
    );
  }
}
