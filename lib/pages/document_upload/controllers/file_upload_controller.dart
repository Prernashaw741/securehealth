import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' as getx;
import 'package:securehealth/constants/network.dart';

class FileUploadController extends getx.GetxController{

  getx.RxBool is_uploaded = false.obs;
  final TextEditingController documentNameController = TextEditingController();
  getx.Rx<PlatformFile> file = PlatformFile(name: '', size: 0).obs;

  Future<bool> UploadFile() async{
    MultipartFile multipartFile;
    
    if (kIsWeb) {
      // On web, use bytes instead of path
      if (file.value.bytes != null) {
        multipartFile = MultipartFile.fromBytes(
          file.value.bytes!,
          filename: file.value.name,
        );
      } else {
        print('Error: File bytes are null');
        return false;
      }
    } else {
      // On mobile/desktop, use file path
      multipartFile = await MultipartFile.fromFile(
        file.value.path!,
        filename: file.value.name,
      );
    }
    
    FormData formData = FormData.fromMap({
      'document_name': documentNameController.text,
      'document': multipartFile,
    });

    // Send the file to the API
    
    try {
      Response response = await dio.post('/', data: formData);
      if (response.statusCode == 200) {
        // getx.Get.snackbar("Success", "Uploaded");
        return true;
      } else {
        print('Failed to upload file');
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }
  
  @override
  void onInit() {
    super.onInit();
  }
}