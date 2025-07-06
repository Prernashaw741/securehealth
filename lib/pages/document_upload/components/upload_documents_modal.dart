import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:securehealth/constants/colors.dart';
import 'package:securehealth/pages/document_upload/controllers/document_controller.dart';
import 'package:securehealth/pages/document_upload/controllers/file_upload_controller.dart';
import 'package:securehealth/utils/animations.dart';
import 'package:securehealth/utils/ui_helpers.dart';

class UploadDocumentsModal extends StatelessWidget {
  const UploadDocumentsModal({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: FileUploadController(),
      builder: (controller) => Obx(
        () => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(24),
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 24,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Handle bar
                  FadeInAnimation(
                    duration: const Duration(milliseconds: 300),
                    child: Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: SecureHealthColors.neutralGrey4,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Header
                  FadeInAnimation(
                    duration: const Duration(milliseconds: 400),
                    delay: const Duration(milliseconds: 100),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: SecureHealthColors.coolOrange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.cloud_upload_outlined,
                            color: SecureHealthColors.coolOrange,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Upload Document",
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: SecureHealthColors.neutralDark,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Add a new health document to your secure vault",
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: SecureHealthColors.neutralMedium,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Error message display
                  Obx(() {
                    if (controller.errorMessage.value.isNotEmpty) {
                      return FadeInAnimation(
                        duration: const Duration(milliseconds: 300),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.red.shade200),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.error_outline,
                                color: Colors.red.shade600,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  controller.errorMessage.value,
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.red.shade700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  }),
                  
                  // File Upload Section
                  FadeInAnimation(
                    duration: const Duration(milliseconds: 500),
                    delay: const Duration(milliseconds: 200),
                    child: Container(
                      decoration: UIHelpers.cardDecoration(
                        color: controller.is_uploaded.value 
                            ? Colors.green.shade50 
                            : SecureHealthColors.neutralGrey10,
                        borderRadius: 16,
                        boxShadow: [],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: controller.isUploading.value 
                              ? null 
                              : () async {
                                  await controller.selectFile();
                                },
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              children: [
                                AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 400),
                                  child: controller.is_uploaded.value
                                      ? ScaleAnimation(
                                          key: const ValueKey('success'),
                                          duration: const Duration(milliseconds: 400),
                                          child: _buildSelectedFileDisplay(context, controller),
                                        )
                                      : _buildUploadPrompt(context),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Document Name Input
                  FadeInAnimation(
                    duration: const Duration(milliseconds: 500),
                    delay: const Duration(milliseconds: 300),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Document Name",
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: SecureHealthColors.neutralDark,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: controller.documentNameController,
                          enabled: !controller.isUploading.value,
                          decoration: InputDecoration(
                            hintText: "Enter a descriptive name for your document",
                            prefixIcon: const Icon(
                              Icons.edit_outlined,
                              color: SecureHealthColors.neutralMedium,
                            ),
                            filled: true,
                            fillColor: controller.isUploading.value 
                                ? SecureHealthColors.neutralGrey5 
                                : Colors.white,
                          ),
                          style: Theme.of(context).textTheme.bodyLarge,
                          onChanged: (value) {
                            // Clear error when user types
                            if (controller.errorMessage.value.isNotEmpty) {
                              controller.errorMessage.value = '';
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Upload Progress (when uploading)
                  Obx(() {
                    if (controller.isUploading.value) {
                      return FadeInAnimation(
                        duration: const Duration(milliseconds: 300),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 24),
                          padding: const EdgeInsets.all(16),
                          decoration: UIHelpers.cardDecoration(
                            color: SecureHealthColors.coolOrange.withOpacity(0.05),
                            boxShadow: [],
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        SecureHealthColors.coolOrange,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      controller.uploadStatus.value,
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.w500,
                                        color: SecureHealthColors.neutralDark,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "${(controller.uploadProgress.value * 100).toInt()}%",
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: SecureHealthColors.coolOrange,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              LinearProgressIndicator(
                                value: controller.uploadProgress.value,
                                backgroundColor: SecureHealthColors.neutralGrey4,
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  SecureHealthColors.coolOrange,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  }),
                  
                  // Action Buttons
                  FadeInAnimation(
                    duration: const Duration(milliseconds: 500),
                    delay: const Duration(milliseconds: 400),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: controller.isUploading.value 
                                ? null 
                                : () => Navigator.of(context).pop(),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              side: BorderSide(
                                color: SecureHealthColors.neutralGrey3,
                              ),
                            ),
                            child: Text(
                              controller.isUploading.value ? "Uploading..." : "Cancel",
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Obx(() => ElevatedButton(
                            onPressed: controller.isFormValid
                                ? () async {
                                    await _handleSubmit(context, controller);
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: controller.isUploading.value
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                : const Text("Upload Document"),
                          )),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUploadPrompt(BuildContext context) {
    return Column(
      key: const ValueKey('upload'),
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: SecureHealthColors.coolOrange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(
              color: SecureHealthColors.coolOrange.withOpacity(0.2),
              width: 2,
              style: BorderStyle.solid,
            ),
          ),
          child: const Icon(
            Icons.cloud_upload_outlined,
            color: SecureHealthColors.coolOrange,
            size: 32,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          "Choose File to Upload",
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: SecureHealthColors.neutralDark,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "PDF, DOC, DOCX, JPG, PNG files up to 10MB",
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: SecureHealthColors.neutralMedium,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildSelectedFileDisplay(BuildContext context, FileUploadController controller) {
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: Colors.green.shade100,
            borderRadius: BorderRadius.circular(32),
          ),
          child: Icon(
            Icons.check_circle,
            color: Colors.green.shade600,
            size: 32,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          controller.file.value?.name ?? 'File Selected',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.green.shade800,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (controller.fileExtension.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.green.shade200,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  controller.fileExtension,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.green.shade800,
                    fontWeight: FontWeight.w600,
                    fontSize: 10,
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
            Text(
              controller.fileSizeText,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.green.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          "File selected successfully • Tap to change",
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.green.shade600,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Future<void> _handleSubmit(BuildContext context, FileUploadController controller) async {
    try {
      final result = await controller.uploadFile();
      
      if (context.mounted) {
        Navigator.of(context).pop();
        
        Get.snackbar(
          result ? 'Success' : 'Upload Failed',
          result 
              ? 'Document uploaded successfully!' 
              : controller.errorMessage.value.isNotEmpty 
                  ? controller.errorMessage.value
                  : 'Failed to upload document. Please try again.',
          backgroundColor: result ? Colors.green.shade50 : Colors.red.shade50,
          colorText: result ? Colors.green.shade900 : Colors.red.shade900,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
          duration: const Duration(seconds: 3),
          icon: Icon(
            result ? Icons.check_circle_outline : Icons.error_outline,
            color: result ? Colors.green.shade900 : Colors.red.shade900,
          ),
        );

        if (result) {
          try {
            // Refresh the documents list
            final DocumentController pageController = Get.find<DocumentController>();
            pageController.documents.clear();
            pageController.get_documents();
            pageController.counts();
          } catch (e) {
            // If controller not found, just ignore
            // DocumentController not found - this is expected in some cases
          }
        }
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context).pop();
        Get.snackbar(
          'Error',
          'An unexpected error occurred. Please try again.',
          backgroundColor: Colors.red.shade50,
          colorText: Colors.red.shade900,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
          icon: Icon(Icons.error_outline, color: Colors.red.shade900),
        );
      }
    }
  }
}