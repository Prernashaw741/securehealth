import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:securehealth/constants/routes.dart';
import 'package:securehealth/pages/document_upload/document_upload.dart';
import 'package:securehealth/pages/document_upload/shared.dart';
import 'package:securehealth/pages/document_upload/shared_with_you.dart';
import 'package:securehealth/pages/signup/login.dart';
import 'package:securehealth/pages/signup/signup.dart';

var pages = [
  GetPage(name: Routes.signup, page: () => SignUpPage(),transition: Transition.rightToLeftWithFade,
  transitionDuration: Durations.long1

  ),
  GetPage(name: Routes.dashboard, page: () => DocumentUpload(),transition: Transition.rightToLeftWithFade,
  transitionDuration: Durations.long1
  ),
  GetPage(name: Routes.login, page: () => LoginPage(),transition: Transition.rightToLeftWithFade,),
  GetPage(name: Routes.shared, page: () => SharedList(),transition: Transition.rightToLeftWithFade,),
  GetPage(name: Routes.sharedWithYou, page: () => SharedWithYouList(),transition: Transition.rightToLeftWithFade,)
];