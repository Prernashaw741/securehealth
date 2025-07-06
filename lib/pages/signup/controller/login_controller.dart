import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:securehealth/constants/network.dart';
import 'package:dio/dio.dart' as dioResponse;
import 'package:securehealth/pages/signup/models/userModel.dart';

class LoginController extends GetxController{

  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final RxBool isLoading = false.obs;

  Future<bool> login() async{
    try {
      isLoading.value = true;
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
    } catch (e) {
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<UserModel> current_user(){
    return dio.get("/login/").then((response) {
      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data);
      }else{
        return UserModel();
      }
    });
  }

  @override
  void onInit() {
    super.onInit();
  }
}