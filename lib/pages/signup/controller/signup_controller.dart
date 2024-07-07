import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dioResponse;
import 'package:securehealth/constants/network.dart';

class SignUpController extends GetxController{
  final Rx<TextEditingController> nameController = TextEditingController().obs;
  final Rx<TextEditingController> emailController = TextEditingController().obs;
  final Rx<TextEditingController> passwordController = TextEditingController().obs;
  Future<bool> signup() async{
    dioResponse.Response response;
    response = await dio.post("/signup/",data: {
      'name': nameController.value.text,
      'email': emailController.value.text,
      'password': passwordController.value.text
    
    });
    Get.snackbar("RESPONSE", response.statusCode.toString());
    if (response.statusCode == 200) {
      return true;
    }else{
      return false;
    }
  }

  @override
  void onInit() {
    super.onInit();
  }

}