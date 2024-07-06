import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dioResponse;
import 'package:securehealth/constants/network.dart';

class SignUpController extends GetxController{
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  Future<bool> signup() async{
    dioResponse.Response response;
    response = await dio.post("/signup/",data: {
      'name': nameController.text,
      'email': emailController.text,
      'password': passwordController.text
    
    });
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