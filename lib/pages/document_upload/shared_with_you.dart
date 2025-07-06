import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:securehealth/constants/colors.dart';
import 'package:securehealth/pages/document_upload/controllers/document_controller.dart';
import 'package:securehealth/utils/animations.dart';
import 'package:securehealth/utils/ui_helpers.dart';
import 'package:url_launcher/url_launcher.dart';

class SharedWithYouList extends StatelessWidget {
  const SharedWithYouList({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: DocumentController(),
      builder: (controller) => Obx(() => Scaffold(
        backgroundColor: SecureHealthColors.neutralGrey10,
        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: FadeInAnimation(
            duration: const Duration(milliseconds: 600),
            child: Text(
              "Shared with You",
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: SecureHealthColors.neutralDark,
              ),
            ),
          ),
          leading: FadeInAnimation(
            duration: const Duration(milliseconds: 600),
            delay: const Duration(milliseconds: 100),
            child: IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(
                Icons.arrow_back_ios,
                color: SecureHealthColors.neutralDark,
              ),
            ),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            controller.sharedWithYou.clear();
            controller.get_shared_documents();
          },
          color: SecureHealthColors.coolOrange,
          child: controller.sharedWithYou.isEmpty
              ? _buildEmptyState(context)
              : _buildDocumentsList(context, controller),
        ),
      )),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return FadeInAnimation(
      duration: const Duration(milliseconds: 600),
      delay: const Duration(milliseconds: 200),
      child: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(40),
            padding: const EdgeInsets.all(32),
            decoration: UIHelpers.cardDecoration(
              color: Colors.white,
              boxShadow: UIHelpers.elevationShadow(1),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: SecureHealthColors.darkPurple.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: const Icon(
                    Icons.folder_shared_outlined,
                    size: 40,
                    color: SecureHealthColors.darkPurple,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  "No shared documents",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: SecureHealthColors.neutralDark,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Documents that others share with you will appear here",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: SecureHealthColors.neutralMedium,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                OutlinedButton.icon(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text("Back to Documents"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDocumentsList(BuildContext context, DocumentController controller) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Container(
        margin: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FadeInAnimation(
              duration: const Duration(milliseconds: 600),
              delay: const Duration(milliseconds: 100),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: UIHelpers.cardDecoration(
                  color: SecureHealthColors.darkPurple.withOpacity(0.05),
                  boxShadow: [],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: SecureHealthColors.darkPurple.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.folder_shared,
                        color: SecureHealthColors.darkPurple,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${controller.sharedWithYou.length} Document${controller.sharedWithYou.length != 1 ? 's' : ''} Received",
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: SecureHealthColors.neutralDark,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Documents shared with you by others",
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
            ),
            const SizedBox(height: 20),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.sharedWithYou.length,
              itemBuilder: (context, index) {
                return StaggeredItemAnimation(
                  index: index,
                  baseDelay: const Duration(milliseconds: 300),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: UIHelpers.cardDecoration(
                      color: Colors.white,
                      boxShadow: UIHelpers.elevationShadow(1),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () async {
                          await _launchUrl(controller.sharedWithYou[index].document!);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: _getDocumentTypeColor(controller.sharedWithYou[index].documentName).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: _getDocumentTypeColor(controller.sharedWithYou[index].documentName).withOpacity(0.2),
                                    width: 1,
                                  ),
                                ),
                                child: Icon(
                                  _getDocumentTypeIcon(controller.sharedWithYou[index].documentName),
                                  color: _getDocumentTypeColor(controller.sharedWithYou[index].documentName),
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      controller.sharedWithYou[index].documentName ?? 'Untitled Document',
                                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: SecureHealthColors.neutralDark,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.calendar_today_outlined,
                                          size: 14,
                                          color: SecureHealthColors.neutralMedium,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          "Shared on ${DateFormat('MMM dd, yyyy').format(
                                            DateTime.parse(controller.sharedWithYou[index].createdAt!),
                                          )}",
                                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                            color: SecureHealthColors.neutralMedium,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: SecureHealthColors.darkPurple.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Icon(
                                                Icons.folder_shared,
                                                size: 10,
                                                color: SecureHealthColors.darkPurple,
                                              ),
                                              const SizedBox(width: 2),
                                              Text(
                                                "Received",
                                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                  color: SecureHealthColors.darkPurple,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: SecureHealthColors.neutralGrey5,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: GestureDetector(
                                  onTap: () async {
                                    await _launchUrl(controller.sharedWithYou[index].document!);
                                  },
                                  child: const Icon(
                                    Icons.open_in_new,
                                    size: 16,
                                    color: SecureHealthColors.neutralMedium,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  IconData _getDocumentTypeIcon(String? fileName) {
    if (fileName == null) return Icons.description_outlined;
    
    final extension = fileName.split('.').last.toLowerCase();
    switch (extension) {
      case 'pdf':
        return Icons.picture_as_pdf_outlined;
      case 'doc':
      case 'docx':
        return Icons.description_outlined;
      case 'jpg':
      case 'jpeg':
      case 'png':
        return Icons.image_outlined;
      default:
        return Icons.insert_drive_file_outlined;
    }
  }

  Color _getDocumentTypeColor(String? fileName) {
    if (fileName == null) return SecureHealthColors.coolOrange;
    
    final extension = fileName.split('.').last.toLowerCase();
    switch (extension) {
      case 'pdf':
        return Colors.red;
      case 'doc':
      case 'docx':
        return Colors.blue;
      case 'jpg':
      case 'jpeg':
      case 'png':
        return Colors.green;
      default:
        return SecureHealthColors.coolOrange;
    }
  }

  Future<void> _launchUrl(String uri) async {
    final url = Uri.parse(uri);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}