import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' as getx;
import 'package:securehealth/constants/network.dart';

class FileUploadController extends getx.GetxController {
  // Observable states
  getx.RxBool is_uploaded = false.obs;
  getx.RxBool isUploading = false.obs;
  getx.RxDouble uploadProgress = 0.0.obs;
  getx.RxString uploadStatus = ''.obs;
  getx.RxString errorMessage = ''.obs;
  
  // Controllers
  final TextEditingController documentNameController = TextEditingController();
  
  // File data
  getx.Rx<PlatformFile?> file = getx.Rx<PlatformFile?>(null);

  // Reset form state
  void resetForm() {
    is_uploaded.value = false;
    isUploading.value = false;
    uploadProgress.value = 0.0;
    uploadStatus.value = '';
    errorMessage.value = '';
    documentNameController.clear();
    file.value = null;
  }

  // Select file with enhanced error handling
  Future<bool> selectFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        withData: true,
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png'],
      );
      
      if (result != null && result.files.isNotEmpty) {
        PlatformFile selectedFile = result.files.first;
        
        // Validate file size (10MB limit)
        if (selectedFile.size > 10 * 1024 * 1024) {
          errorMessage.value = 'File size must be less than 10MB';
          return false;
        }
        
        file.value = selectedFile;
        is_uploaded.value = true;
        errorMessage.value = '';
        uploadStatus.value = 'File selected successfully';
        
        // Auto-populate document name if empty
        if (documentNameController.text.isEmpty) {
          String fileName = selectedFile.name;
          // Remove extension from filename
          if (fileName.contains('.')) {
            fileName = fileName.substring(0, fileName.lastIndexOf('.'));
          }
          documentNameController.text = fileName;
        }
        
        return true;
      } else {
        uploadStatus.value = 'No file selected';
        return false;
      }
    } catch (e) {
      errorMessage.value = 'Failed to select file: ${e.toString()}';
      is_uploaded.value = false;
      return false;
    }
  }

  // Enhanced upload method with proper error handling and progress
  Future<bool> uploadFile() async {
    if (file.value == null) {
      errorMessage.value = 'No file selected';
      return false;
    }

    if (documentNameController.text.trim().isEmpty) {
      errorMessage.value = 'Document name is required';
      return false;
    }

    try {
      isUploading.value = true;
      uploadProgress.value = 0.0;
      uploadStatus.value = 'Preparing upload...';
      errorMessage.value = '';

      MultipartFile multipartFile;
      
      if (kIsWeb) {
        // On web, use bytes instead of path
        if (file.value!.bytes != null) {
          multipartFile = MultipartFile.fromBytes(
            file.value!.bytes!,
            filename: file.value!.name,
          );
        } else {
          errorMessage.value = 'File data is not available';
          return false;
        }
      } else {
        // On mobile/desktop, use file path
        if (file.value!.path != null) {
          multipartFile = await MultipartFile.fromFile(
            file.value!.path!,
            filename: file.value!.name,
          );
        } else {
          errorMessage.value = 'File path is not available';
          return false;
        }
      }
      
      uploadStatus.value = 'Creating upload data...';
      uploadProgress.value = 0.2;

      FormData formData = FormData.fromMap({
        'document_name': documentNameController.text.trim(),
        'document': multipartFile,
      });

      uploadStatus.value = 'Uploading to server...';
      uploadProgress.value = 0.5;

      // Send the file to the API with progress tracking
      Response response = await dio.post(
        '/',
        data: formData,
        onSendProgress: (sent, total) {
          if (total > 0) {
            double progress = 0.5 + (sent / total) * 0.4; // 50% to 90%
            uploadProgress.value = progress;
            uploadStatus.value = 'Uploading... ${(progress * 100).toInt()}%';
          }
        },
      );

      uploadProgress.value = 0.95;
      uploadStatus.value = 'Processing response...';

      if (response.statusCode == 200 || response.statusCode == 201) {
        uploadProgress.value = 1.0;
        uploadStatus.value = 'Upload completed successfully!';
        
        // Reset form on successful upload
        await Future.delayed(const Duration(milliseconds: 500));
        resetForm();
        
        return true;
      } else {
        errorMessage.value = 'Upload failed with status: ${response.statusCode}';
        uploadStatus.value = 'Upload failed';
        return false;
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        errorMessage.value = 'Connection timeout. Please check your internet connection.';
      } else if (e.type == DioExceptionType.receiveTimeout) {
        errorMessage.value = 'Server response timeout. Please try again.';
      } else if (e.type == DioExceptionType.badResponse) {
        errorMessage.value = 'Server error: ${e.response?.statusCode}';
      } else if (e.type == DioExceptionType.cancel) {
        errorMessage.value = 'Upload was cancelled';
      } else {
        errorMessage.value = 'Network error: ${e.message}';
      }
      uploadStatus.value = 'Upload failed';
      return false;
    } catch (e) {
      errorMessage.value = 'Unexpected error: ${e.toString()}';
      uploadStatus.value = 'Upload failed';
      return false;
    } finally {
      isUploading.value = false;
      if (errorMessage.value.isNotEmpty) {
        uploadProgress.value = 0.0;
      }
    }
  }

  // Validate form
  bool get isFormValid {
    return file.value != null && 
           documentNameController.text.trim().isNotEmpty &&
           !isUploading.value;
  }

  // Get file size in readable format
  String get fileSizeText {
    if (file.value == null) return '';
    
    int bytes = file.value!.size;
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  // Get file extension
  String get fileExtension {
    if (file.value == null) return '';
    String name = file.value!.name;
    if (name.contains('.')) {
      return name.split('.').last.toUpperCase();
    }
    return '';
  }

  @override
  void onClose() {
    documentNameController.dispose();
    super.onClose();
  }
}