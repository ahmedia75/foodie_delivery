import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../constants/app_colors.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.system;

  bool get isDarkMode {
    if (themeMode == ThemeMode.system) {
      final brightness =
          SchedulerBinding.instance.platformDispatcher.platformBrightness;
      return brightness == Brightness.dark;
    } else {
      return themeMode == ThemeMode.dark;
    }
  }

  void toggleTheme(bool isOn) {
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class MyThemes {
  static final darkTheme = ThemeData(
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: AppColors.secondaryColor,
      selectionColor: AppColors.midtoneColor,
      selectionHandleColor: AppColors.midtoneColor,
    ),
    scaffoldBackgroundColor: AppColors.secondaryColor,
    fontFamily: "MuseoSans",
    primaryColor: AppColors.primaryColor,
    colorScheme: const ColorScheme.dark(
      onPrimary: AppColors.primaryColor,
      secondary: AppColors.primaryColor,
      surface: AppColors.primaryColor,
      primary: AppColors.secondaryColor,
      onSecondary: AppColors.secondaryColor,
      onSurface: AppColors.secondaryColor,
    ),
    iconTheme: const IconThemeData(color: AppColors.secondaryColor),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    pageTransitionsTheme: const PageTransitionsTheme(builders: {
      TargetPlatform.iOS: CustomTransitionBuilder(),
      TargetPlatform.android: CustomTransitionBuilder(),
    }),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primaryColor,
        backgroundColor: AppColors.secondaryColor,
      ),
    ),
    inputDecorationTheme: inputDecorationThemeDark(),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primaryColor,
      ),
    ),
  );

//   static final lightTheme = ThemeData(
//     textSelectionTheme: const TextSelectionThemeData(
//       cursorColor: AppColors.secondaryColor,
//       selectionColor: AppColors.midtoneColor,
//       selectionHandleColor: AppColors.midtoneColor,
//     ),
//     scaffoldBackgroundColor: AppColors.backgroundlightColor,
//     fontFamily: "MuseoSans",
//     primaryColor: AppColors.secondaryColor,
//     // colorScheme: const ColorScheme.light(
//     //   primary: AppColors.primaryColor,
//     //   onPrimary: AppColors.secondaryColor,
//     //   secondary: AppColors.secondaryColor,
//     //   onSecondary: AppColors.primaryColor,
//     //   surface: AppColors.backgroundlightColor,
//     //   onSurface: AppColors.secondaryColor,
//     // ),
//     iconTheme:
//         const IconThemeData(color: AppColors.secondaryColor, opacity: 0.8),
//     visualDensity: VisualDensity.adaptivePlatformDensity,
//     pageTransitionsTheme: const PageTransitionsTheme(builders: {
//       TargetPlatform.iOS: CustomTransitionBuilder(),
//       TargetPlatform.android: CustomTransitionBuilder(),
//     }),
//     textButtonTheme: TextButtonThemeData(
//       style: TextButton.styleFrom(
//         foregroundColor: AppColors.secondaryColor,
//         backgroundColor: AppColors.primaryColor,
//       ),
//     ),
//     inputDecorationTheme: inputDecorationThemeLight(),
//     outlinedButtonTheme: OutlinedButtonThemeData(
//       style: OutlinedButton.styleFrom(
//         foregroundColor: AppColors.primaryColor,
//       ),
//     ),
//   );
// }

  static final lightTheme = ThemeData(
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: AppColors.secondaryColor,
      selectionColor: AppColors.midtoneColor,
      selectionHandleColor: AppColors.midtoneColor,
    ),
    scaffoldBackgroundColor: AppColors.secondaryColor,
    fontFamily: "MuseoSans",
    primaryColor: AppColors.primaryColor,
    colorScheme: const ColorScheme.dark(
      onPrimary: AppColors.primaryColor,
      secondary: AppColors.primaryColor,
      surface: AppColors.primaryColor,
      primary: AppColors.secondaryColor,
      onSecondary: AppColors.secondaryColor,
      onSurface: AppColors.secondaryColor,
    ),
    iconTheme: const IconThemeData(color: AppColors.secondaryColor),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    pageTransitionsTheme: const PageTransitionsTheme(builders: {
      TargetPlatform.iOS: CustomTransitionBuilder(),
      TargetPlatform.android: CustomTransitionBuilder(),
    }),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primaryColor,
        backgroundColor: AppColors.secondaryColor,
      ),
    ),
    inputDecorationTheme: inputDecorationThemeDark(),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primaryColor,
      ),
    ),
  );
}

InputDecorationTheme inputDecorationThemeLight() {
  OutlineInputBorder outlineInputBorder = OutlineInputBorder(
    borderSide: const BorderSide(width: 1, color: AppColors.secondaryColor),
    borderRadius: BorderRadius.circular(8),
    gapPadding: 3,
  );
  return InputDecorationTheme(
    floatingLabelStyle: const TextStyle(color: AppColors.secondaryColor),
    isDense: true,
    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    enabledBorder: outlineInputBorder,
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: AppColors.secondaryColor, width: 1.5),
      borderRadius: BorderRadius.circular(8),
    ),
    border: outlineInputBorder,
    prefixIconColor: AppColors.secondaryColor,
  );
}

InputDecorationTheme inputDecorationThemeDark() {
  OutlineInputBorder outlineInputBorder = OutlineInputBorder(
    borderSide: const BorderSide(width: 1, color: AppColors.secondaryColor),
    borderRadius: BorderRadius.circular(8),
    gapPadding: 3,
  );
  return InputDecorationTheme(
    floatingLabelStyle: const TextStyle(color: AppColors.secondaryColor),
    isDense: true,
    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    enabledBorder: outlineInputBorder,
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: AppColors.secondaryColor, width: 1.5),
      borderRadius: BorderRadius.circular(8),
    ),
    border: outlineInputBorder,
    prefixIconColor: AppColors.secondaryColor,
  );
}

class CustomTransitionBuilder extends PageTransitionsBuilder {
  const CustomTransitionBuilder();
  @override
  Widget buildTransitions<T>(
      PageRoute<T> route,
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    const begin = Offset(1.0, 0.0);
    const end = Offset.zero;
    const curve = Curves.ease;

    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
    return SlideTransition(position: tween.animate(animation), child: child);
  }
}
