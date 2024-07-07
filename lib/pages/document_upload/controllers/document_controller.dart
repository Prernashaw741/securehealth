import 'package:get/get.dart';
import 'package:securehealth/constants/network.dart';
import 'package:securehealth/pages/document_upload/models/count_model.dart';
import 'package:securehealth/pages/document_upload/models/document_model.dart';
import 'package:dio/dio.dart' as dioResponse;
import 'package:securehealth/pages/signup/models/userModel.dart';

class DocumentController extends GetxController{

  RxList<DocumentModel> documents = <DocumentModel>[].obs;
  RxList<DocumentModel> sharedByYou = <DocumentModel>[].obs;
  RxList<DocumentModel> sharedWithYou = <DocumentModel>[].obs;
  void get_documents() async{
    dioResponse.Response response;
    response = await dio.get("/");
    if (response.statusCode == 200) {
      documents.value = (response.data as List).map((e) => DocumentModel.fromJson(e)).toList();
      sharedByYou.value = (
        documents.where((element) => element.isShared != null && element.isShared! == true)
      ).toList();
      
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
  Future<UserModel> current_user(){
    return dio.get("/login/").then((response) {
      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data);
      }else{
        return UserModel();
      }
    });
  }
  Future<CountModel> counts(){
    return dio.get("/counts/").then((response) {
      if (response.statusCode == 200) {
        return CountModel.fromJson(response.data);
      }else{
        return CountModel();
      }
    });
  }
  Future<bool> share_document(String email,int document_id) async {
    dioResponse.Response response;
    response = await dio.post("/share/",data: {
      'shared_with': email,
      'document_id': document_id
    });
    if (response.statusCode == 200) {
      return true;
    }else{
      return false;
    }
  }

  void get_shared_documents() async{
    dioResponse.Response response;
    response = await dio.get("/shared-with-you/");
    if (response.statusCode == 200) {
      sharedWithYou.value = (response.data as List).map((e) => DocumentModel.fromJson(e)).toList();
      
      
      
    }
  }

  @override
  void onInit() {
    super.onInit();
    get_documents();
    get_shared_documents();
  }
}