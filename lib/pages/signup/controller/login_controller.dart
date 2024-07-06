import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:securehealth/constants/network.dart';
import 'package:dio/dio.dart' as dioResponse;

class LoginController extends GetxController{

  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  Future<bool> login() async{
    
    dioResponse.Response response;
    response = await dio.post("/login/",data: {
      'email': email.text,
      'password': password.text
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