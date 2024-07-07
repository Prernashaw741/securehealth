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
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(SecureHealthColors.coolOrange),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
        
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: SecureHealthColors.coolOrange,
          textTheme: ButtonTextTheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2),
          ),
        
        ),
        textTheme: TextTheme(
          displayLarge: GoogleFonts.manrope(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            // color: SecureHealthColors.neutralDark,
          ),
          displayMedium: GoogleFonts.manrope(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            // color: SecureHealthColors.neutralDark,
          
          ),
          displaySmall: GoogleFonts.manrope(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            // color: SecureHealthColors.neutralDark,
          ),
          bodyLarge: GoogleFonts.manrope(
            fontSize: 16,
            fontWeight: FontWeight.normal,
            // color: SecureHealthColors.neutralDark,
          
          ),
          bodyMedium: GoogleFonts.manrope(
            fontSize: 14,
            fontWeight: FontWeight.normal,
            // color: SecureHealthColors.neutralDark,
          ),
          bodySmall: GoogleFonts.manrope(
            fontSize: 12,
            fontWeight: FontWeight.normal,
            // color: SecureHealthColors.neutralDark,
          ),
          headlineLarge: GoogleFonts.manrope(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            // color: SecureHealthColors.neutralDark,
          ),
          headlineMedium: GoogleFonts.manrope(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            // color: SecureHealthColors.neutralDark,
          
          ),
          headlineSmall: GoogleFonts.manrope(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            // color: SecureHealthColors.neutralDark,
          )

        ),
        colorScheme: ColorScheme.fromSeed(seedColor: SecureHealthColors.coolOrange),
        useMaterial3: true,
      ),

      getPages: pages,
      initialRoute: Routes.login,
      
    );
  }
}
