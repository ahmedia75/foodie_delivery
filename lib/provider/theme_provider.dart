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
    // textSelectionTheme: const TextSelectionThemeData(
    //     cursorColor: Colors.white, selectionColor: Colors.blue),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: Colors.black,
      selectionColor: AppColors.backgroundlightColor,
      selectionHandleColor: AppColors.backgrounddarklightColor,
    ),
    scaffoldBackgroundColor: const Color(0xff16202b),
    fontFamily: "PTSans",
    primaryColor: Colors.white,
    colorScheme: const ColorScheme.dark(),
    iconTheme: const IconThemeData(color: AppColors.white),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    pageTransitionsTheme: const PageTransitionsTheme(builders: {
      TargetPlatform.iOS: CustomTransitionBuilder(),
      TargetPlatform.android: CustomTransitionBuilder(),
    }),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
          foregroundColor: Colors.black, backgroundColor: AppColors.secondary),
    ),
    inputDecorationTheme: inputDecorationThemeDark(),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
      ),
    ),
    // radioTheme:  Radio()
  );

  static final lightTheme = ThemeData(
    // textSelectionTheme: const TextSelectionThemeData(
    //     cursorColor: Colors.black, selectionColor: AppColors.primaryColor),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: Colors.black,
      selectionColor: AppColors.backgroundlightColor,
      selectionHandleColor: AppColors.backgrounddarklightColor,
    ),
    scaffoldBackgroundColor: Colors.white,
    fontFamily: "PTSans",
    primaryColor: Colors.black,
    // colorScheme: const ColorScheme.light(),
    colorScheme: const ColorScheme.light(
      primary: AppColors.primaryColor,
      onPrimary: AppColors.white,
      onSurface: AppColors.primaryColor,
    ),
    iconTheme: const IconThemeData(color: AppColors.secondary, opacity: 0.8),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    pageTransitionsTheme: const PageTransitionsTheme(builders: {
      TargetPlatform.iOS: CustomTransitionBuilder(),
      TargetPlatform.android: CustomTransitionBuilder(),
    }),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
        // backgroundColor: AppColors.primaryColor
      ),
    ),

    inputDecorationTheme: inputDecorationThemeLight(),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primaryColor,
      ),
    ),
  );
}

InputDecorationTheme inputDecorationThemeLight() {
  OutlineInputBorder outlineInputBorder = OutlineInputBorder(
    borderSide: const BorderSide(width: 1, color: AppColors.primaryColor),
    borderRadius: BorderRadius.circular(8),
    gapPadding: 3,
  );
  return InputDecorationTheme(
      floatingLabelStyle: const TextStyle(color: AppColors.primaryColor),
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      enabledBorder: outlineInputBorder,
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.primaryColor, width: 1.5),
        borderRadius: BorderRadius.circular(8),
      ),
      border: outlineInputBorder,
      prefixIconColor: AppColors.primaryColor);
}

InputDecorationTheme inputDecorationThemeDark() {
  OutlineInputBorder outlineInputBorder = OutlineInputBorder(
    borderSide: const BorderSide(width: 1, color: AppColors.primaryColor),
    borderRadius: BorderRadius.circular(8),
    gapPadding: 3,
  );
  return InputDecorationTheme(
      floatingLabelStyle: const TextStyle(color: AppColors.primaryColor),
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      enabledBorder: outlineInputBorder,
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.primaryColor, width: 1.5),
        borderRadius: BorderRadius.circular(8),
      ),
      border: outlineInputBorder,
      prefixIconColor: AppColors.primaryColor);
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
