import 'package:get/get.dart';
import 'package:securehealth/constants/network.dart';
import 'package:securehealth/pages/document_upload/models/document_model.dart';
import 'package:dio/dio.dart' as dioResponse;

class DocumentController extends GetxController{

  RxList<DocumentModel> documents = <DocumentModel>[].obs;

  void get_documents() async{
    dioResponse.Response response;
    response = await dio.get("/");
    if (response.statusCode == 200) {
      documents.value = (response.data as List).map((e) => DocumentModel.fromJson(e)).toList();
    }
  }
  Future<bool> delete_document(id) async{
    dioResponse.Response response;
    response = await dio.delete("/",queryParameters: {
      'id': id
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
    get_documents();
  }
}