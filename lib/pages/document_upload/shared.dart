import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:securehealth/constants/colors.dart';
import 'package:securehealth/pages/document_upload/controllers/document_controller.dart';
import 'package:securehealth/utils/animations.dart';
import 'package:securehealth/utils/ui_helpers.dart';
import 'package:url_launcher/url_launcher.dart';

class SharedList extends StatelessWidget {
  const SharedList({super.key});

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
              "Shared by You",
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
            controller.sharedByYou.clear();
            controller.get_documents();
          },
          color: SecureHealthColors.coolOrange,
          child: controller.sharedByYou.isEmpty
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
                    color: SecureHealthColors.coolBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Icon(
                    Icons.share_outlined,
                    size: 40,
                    color: SecureHealthColors.coolBlue,
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
                  "Documents you share with others will appear here",
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
                  color: SecureHealthColors.coolBlue.withOpacity(0.05),
                  boxShadow: [],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: SecureHealthColors.coolBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.share,
                        color: SecureHealthColors.coolBlue,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${controller.sharedByYou.length} Document${controller.sharedByYou.length != 1 ? 's' : ''} Shared",
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: SecureHealthColors.neutralDark,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Documents you've shared with others",
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
              itemCount: controller.sharedByYou.length,
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
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      onTap: () async {
                        await _launchUrl(controller.sharedByYou[index].document!);
                      },
                      leading: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: SecureHealthColors.coolBlue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.description_outlined,
                          color: SecureHealthColors.coolBlue,
                          size: 24,
                        ),
                      ),
                      title: Text(
                        controller.sharedByYou[index].documentName ?? 'Untitled Document',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: SecureHealthColors.neutralDark,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text(
                            "Shared on ${DateFormat('dd MMM yyyy').format(
                              DateTime.parse(controller.sharedByYou[index].createdAt!),
                            )}",
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: SecureHealthColors.neutralMedium,
                            ),
                          ),
                        ],
                      ),
                      trailing: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: SecureHealthColors.neutralGrey5,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: GestureDetector(
                          onTap: () async {
                            await _launchUrl(controller.sharedByYou[index].document!);
                          },
                          child: const Icon(
                            Icons.open_in_new,
                            size: 16,
                            color: SecureHealthColors.neutralMedium,
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

  Future<void> _launchUrl(String uri) async {
    final url = Uri.parse(uri);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}