import 'package:flutter/widgets.dart';
import 'package:memshelf/src/Presentation/blocs/app_bloc.dart';
import 'package:memshelf/src/Presentation/views/screens/home_screen.dart';
import 'package:memshelf/src/Presentation/views/screens/login_screen.dart';
import 'package:memshelf/src/Presentation/views/screens/recover_password_screen.dart';
import 'package:memshelf/src/Presentation/views/screens/signup_screen.dart';

// abstract class Routes {
//   static final Map<String, WidgetBuilder> routeList = {
//     LoginScreen.routeName: (context) => LoginScreen(),
//     RecoverPasswordScreen.routeName: (context) => RecoverPasswordScreen(),
//     SignUpScreen.routeName: (context) => SignUpScreen(),
//   };
  
// }

List<Page> onGenerateAppViewPages(AppStatus state, List<Page<dynamic>> pages) {
  switch (state) {
    case AppStatus.authenticated:
      return [HomeScreen.page()];
    case AppStatus.unauthenticated:
      return [LoginScreen.page()];
  }
}

