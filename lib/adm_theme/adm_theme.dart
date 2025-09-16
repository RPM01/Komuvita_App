import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:nb_utils/nb_utils.dart';

import '../constant/adm_colors.dart';

abstract class AdmTheme {
  static const double letterSpacing = 0.3;
  static const double letterHeight = 1.5;

  static var fontFamily = 'Urbanist';

  static final ThemeData admLightTheme = ThemeData(
      splashColor: Colors.transparent,  // Removes the splash color
      highlightColor: Colors.transparent,  // Removes the highlight color
          scaffoldBackgroundColor: whiteColor,
          primaryColor: admColorPrimary,
          primaryColorDark: admColorPrimary,
          fontFamily: fontFamily,
          bottomNavigationBarTheme:
              const BottomNavigationBarThemeData(backgroundColor: whiteColor),
          appBarTheme: const AppBarTheme(
            actionsIconTheme: IconThemeData(color: whiteColor),
            backgroundColor: whiteColor,
            // color: whiteColor,
            // iconTheme: IconThemeData(color: appTextColorPrimary),
            systemOverlayStyle: SystemUiOverlayStyle(
                statusBarIconBrightness: Brightness.dark,
                statusBarColor: Colors.black),
          ),
          textSelectionTheme:
              const TextSelectionThemeData(cursorColor: Colors.black),
          colorScheme: const ColorScheme.light(primary: Colors.white),
          cardTheme: const CardThemeData(color: Colors.white),
          cardColor: cardLightColor,
          iconTheme: const IconThemeData(color: Colors.black),
          bottomSheetTheme:
              const BottomSheetThemeData(backgroundColor: whiteColor),
          primaryTextTheme: TextTheme(
            titleLarge: TextStyle(
              color: admTextColor,
              letterSpacing: letterSpacing,
              height: letterHeight,
              fontFamily: fontFamily,
            ),
            labelSmall: TextStyle(
                fontFamily: fontFamily,
                color: admTextColor,
                letterSpacing: letterSpacing,
                height: letterHeight),
          ),
          textTheme: TextTheme(
            displayLarge: TextStyle(
              fontSize: 48.0,
              color: admTextColor,
              fontFamily: fontFamily,
            ),
            displayMedium: TextStyle(
              fontSize: 40.0,
              color: admTextColor,
              fontFamily: fontFamily,
            ),
            displaySmall: TextStyle(
              fontSize: 32.0,
              color: admTextColor,
              fontFamily: fontFamily,
            ),
            headlineMedium: TextStyle(
              fontSize: 24.0,
              fontFamily: fontFamily,
              color: admTextColor,
            ),
            headlineSmall: TextStyle(
              fontSize: 20.0,
              color: admTextColor,
              fontFamily: fontFamily,
            ),
            titleLarge: TextStyle(
              fontSize: 18.0,
              color: admTextColor,
              fontFamily: fontFamily,
            ),
            bodyLarge: TextStyle(
                fontSize: 16.0,
                color: admTextColor,
                fontFamily: fontFamily,
                fontWeight: FontWeight.w700),
            bodyMedium: TextStyle(
              fontSize: 14.0,
              color: admTextColor,
              fontFamily: fontFamily,
            ),
            bodySmall: TextStyle(
              fontSize: 12.0,
              color: admTextColor,
              fontFamily: fontFamily,
            ),
            headlineLarge: TextStyle(
              fontSize: 8.0,
              color: admTextColor,
              fontFamily: fontFamily,
            ),

            //grey colors
            labelLarge: TextStyle(
              fontSize: 28.0,
              color: admGreyTextColor,
              fontFamily: fontFamily,
            ),
            labelMedium: TextStyle(
              fontSize: 18.0,
              color: admGreyTextColor,
              fontFamily: fontFamily,
            ),
            labelSmall: TextStyle(
              fontSize: 16.0,
              color: admGreyTextColor,
              fontFamily: fontFamily,
            ),
            titleSmall: TextStyle(
              fontSize: 12.0,
              color: admGreyTextColor,
              fontFamily: fontFamily,
            ),
            titleMedium: TextStyle(
              fontSize: 14.0,
              fontFamily: fontFamily,
              color: admGreyTextColor,
            ),
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
          popupMenuTheme: const PopupMenuThemeData(color: whiteColor))
      .copyWith(
    pageTransitionsTheme: const PageTransitionsTheme(
        builders: <TargetPlatform, PageTransitionsBuilder>{
          TargetPlatform.android: OpenUpwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.linux: OpenUpwardsPageTransitionsBuilder(),
          TargetPlatform.macOS: OpenUpwardsPageTransitionsBuilder(),
        }),
  );

  static final ThemeData admDarkTheme = ThemeData(
    scaffoldBackgroundColor: admDarkPrimary,
    splashColor: Colors.transparent,  // Removes the splash color
    highlightColor: Colors.transparent,  // Removes the highlight color
    bottomNavigationBarTheme:
        const BottomNavigationBarThemeData(backgroundColor: admDarkPrimary),
    appBarTheme: const AppBarTheme(
      actionsIconTheme: IconThemeData(color: whiteColor),
      titleTextStyle: TextStyle(color: Colors.white),
      backgroundColor: admDarkPrimary,
      iconTheme: IconThemeData(color: whiteColor),
      systemOverlayStyle: SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.light,
          statusBarColor: Colors.white),
    ),
    primaryColor: admDarkPrimary,
    dividerColor: const Color(0xFFDADADA).withOpacity(0.3),
    primaryColorDark: admDarkPrimary,
    textSelectionTheme: const TextSelectionThemeData(
        cursorColor: Colors.white, selectionColor: Colors.white),
    hoverColor: Colors.black12,
    fontFamily: fontFamily,
    bottomSheetTheme:
        const BottomSheetThemeData(backgroundColor: admDarkPrimary),
    primaryTextTheme: TextTheme(
        titleLarge: TextStyle(
            color: Colors.white,
            letterSpacing: letterSpacing,
            fontFamily: fontFamily,
            height: letterHeight),
        labelSmall: TextStyle(
            color: Colors.white,
            fontFamily: fontFamily,
            letterSpacing: letterSpacing,
            height: letterHeight)),
    cardTheme: const CardThemeData(color: admDarkPrimary),
    //cardColor: foodCardDark,
    iconTheme: const IconThemeData(color: whiteColor),
    textTheme: TextTheme(
      //admTextColor
      displayLarge: TextStyle(
        fontSize: 48.0,
        color: Colors.white,
        fontFamily: fontFamily,
      ),
      displayMedium: TextStyle(
        fontSize: 40.0,
        color: Colors.white,
        fontFamily: fontFamily,
      ),
      displaySmall: TextStyle(
        fontSize: 32.0,
        color: Colors.white,
        fontFamily: fontFamily,
      ),
      headlineMedium: TextStyle(
        fontSize: 24.0,
        color: Colors.white,
        fontFamily: fontFamily,
      ),
      headlineSmall: TextStyle(
        fontSize: 20.0,
        color: Colors.white,
        fontFamily: fontFamily,
      ),
      titleLarge: TextStyle(
        fontSize: 18.0,
        color: Colors.white,
        fontFamily: fontFamily,
        // letterSpacing: 1.5
      ),
      bodyLarge: TextStyle(
        fontSize: 16.0,
        color: Colors.white,
        fontFamily: fontFamily,
      ),
      bodyMedium: TextStyle(
        fontSize: 14.0,
        color: Colors.white,
        fontFamily: fontFamily,
      ),
      bodySmall: TextStyle(
        fontSize: 12.0,
        color: Colors.white,
        fontFamily: fontFamily,
      ),

      //grey colors
      labelLarge: TextStyle(
        fontSize: 28.0,
        color: greyColor,
        fontFamily: fontFamily,
      ),
      labelMedium: TextStyle(
        fontSize: 18.0,
        color: greyColor,
        fontFamily: fontFamily,
      ),
      labelSmall: TextStyle(
        fontSize: 16.0,
        color: greyColor,
        fontFamily: fontFamily,
      ),
      titleSmall: TextStyle(
        fontSize: 12.0,
        color: greyColor,
        fontFamily: fontFamily,
      ),
      titleMedium: TextStyle(
        fontSize: 14.0,
        fontFamily: fontFamily,
        color: greyColor,
      ),
    ),

    popupMenuTheme: const PopupMenuThemeData(color: Colors.white),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    colorScheme: const ColorScheme.dark(
      primary: admDarkPrimary,
      //onPrimary: foodCardDark
    ).copyWith(secondary: whiteColor),
  ).copyWith(
    pageTransitionsTheme: const PageTransitionsTheme(
        builders: <TargetPlatform, PageTransitionsBuilder>{
          TargetPlatform.android: OpenUpwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.linux: OpenUpwardsPageTransitionsBuilder(),
          TargetPlatform.macOS: OpenUpwardsPageTransitionsBuilder(),
        }),
  );
}
