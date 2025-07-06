import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:securehealth/constants/colors.dart';
import 'package:securehealth/constants/network.dart';
import 'package:securehealth/constants/pages.dart';
import 'package:securehealth/constants/routes.dart';

void main() {
  // await GetStorage.init();
  if (!kIsWeb) {
    dio.interceptors.add(CookieManager(cookieJar));
  } else {
    // For web platform, add interceptor to handle cookies
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // Ensure cookies are sent with requests on web
        options.extra['withCredentials'] = true;
        handler.next(options);
      },
    ));
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SecureHealth App',
      theme: ThemeData(
        primaryColor: SecureHealthColors.coolOrange,
        scaffoldBackgroundColor: SecureHealthColors.neutralGrey10,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          iconTheme: const IconThemeData(color: SecureHealthColors.neutralDark),
          titleTextStyle: GoogleFonts.manrope(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: SecureHealthColors.neutralDark,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
              if (states.contains(WidgetState.pressed)) {
                return SecureHealthColors.coolOrange.withOpacity(0.8);
              }
              return SecureHealthColors.coolOrange;
            }),
            foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
            elevation: WidgetStateProperty.resolveWith<double>((states) {
              if (states.contains(WidgetState.pressed)) {
                return 0;
              }
              return 2;
            }),
            padding: WidgetStateProperty.all<EdgeInsets>(
              const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            minimumSize: WidgetStateProperty.all<Size>(
              const Size(double.infinity, 48),
            ),
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: ButtonStyle(
            foregroundColor: WidgetStateProperty.all<Color>(SecureHealthColors.coolOrange),
            side: WidgetStateProperty.all<BorderSide>(
              const BorderSide(color: SecureHealthColors.coolOrange, width: 1.5),
            ),
            padding: WidgetStateProperty.all<EdgeInsets>(
              const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            minimumSize: WidgetStateProperty.all<Size>(
              const Size(double.infinity, 48),
            ),
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            foregroundColor: WidgetStateProperty.all<Color>(SecureHealthColors.coolOrange),
            padding: WidgetStateProperty.all<EdgeInsets>(
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: SecureHealthColors.neutralGrey3),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: SecureHealthColors.neutralGrey3),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: SecureHealthColors.coolOrange, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
          labelStyle: GoogleFonts.manrope(
            fontSize: 14,
            color: SecureHealthColors.neutralMedium,
          ),
          hintStyle: GoogleFonts.manrope(
            fontSize: 14,
            color: SecureHealthColors.neutralGrey2,
          ),
        ),
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: Colors.white,
          surfaceTintColor: Colors.transparent,
        ),
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
        ),
        dividerTheme: const DividerThemeData(
          color: SecureHealthColors.neutralGrey4,
          thickness: 1,
        ),
        textTheme: TextTheme(
          displayLarge: GoogleFonts.manrope(
            fontSize: 48,
            fontWeight: FontWeight.w800,
            color: SecureHealthColors.neutralDark,
          ),
          displayMedium: GoogleFonts.manrope(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: SecureHealthColors.neutralDark,
          ),
          displaySmall: GoogleFonts.manrope(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: SecureHealthColors.neutralDark,
          ),
          headlineLarge: GoogleFonts.manrope(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: SecureHealthColors.neutralDark,
          ),
          headlineMedium: GoogleFonts.manrope(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: SecureHealthColors.neutralDark,
          ),
          headlineSmall: GoogleFonts.manrope(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: SecureHealthColors.neutralDark,
          ),
          bodyLarge: GoogleFonts.manrope(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: SecureHealthColors.neutralDark,
          ),
          bodyMedium: GoogleFonts.manrope(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: SecureHealthColors.neutralDark,
          ),
          bodySmall: GoogleFonts.manrope(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: SecureHealthColors.neutralMedium,
          ),
          labelLarge: GoogleFonts.manrope(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: SecureHealthColors.neutralDark,
          ),
          labelMedium: GoogleFonts.manrope(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: SecureHealthColors.neutralDark,
          ),
          labelSmall: GoogleFonts.manrope(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: SecureHealthColors.neutralMedium,
          ),
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: SecureHealthColors.coolOrange,
          primary: SecureHealthColors.coolOrange,
          secondary: SecureHealthColors.darkPurple,
          tertiary: SecureHealthColors.coolBlue,
          surface: Colors.white,
          surfaceContainerHighest: SecureHealthColors.neutralGrey10,
          error: Colors.red,
        ),
        useMaterial3: true,
      ),

      getPages: pages,
      initialRoute: Routes.login,
    );
  }
}
