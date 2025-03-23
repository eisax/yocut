import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:yocut/ui/screens/splashScreen.dart';

class Routes{
  static const String splash = "/splash";

  static List<GetPage> getPages = [
    GetPage(name: splash, page: () => SplashScreen.routeInstance()),
  ];
}