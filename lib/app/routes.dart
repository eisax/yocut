import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:yocut/ui/screens/auth/authScreen.dart';
import 'package:yocut/ui/screens/home/homeScreen.dart';
import 'package:yocut/ui/screens/splashScreen.dart';

class Routes{
  static const String splash = "/splash";
  static const String home = "/";
  static const String auth = "/auth";

  static List<GetPage> getPages = [
    GetPage(name: splash, page: () => SplashScreen.routeInstance()),
    GetPage(name: home, page: () => HomeScreen.routeInstance()),
    GetPage(name: auth, page: () => AuthScreen.routeInstance()),
  ];
}