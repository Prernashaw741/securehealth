import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:securehealth/constants/colors.dart';
import 'package:securehealth/constants/routes.dart';
import 'package:securehealth/pages/document_upload/components/document_count_component.dart';
import 'package:securehealth/pages/document_upload/components/upload_documents_modal.dart';
import 'package:securehealth/pages/document_upload/components/user_card.dart';
import 'package:securehealth/pages/document_upload/controllers/document_controller.dart';
import 'package:securehealth/utils/animations.dart';
import 'package:securehealth/utils/ui_helpers.dart';
import 'package:url_launcher/url_launcher.dart';

class DocumentUpload extends StatelessWidget {
  const DocumentUpload({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: DocumentController(),
        builder: (controller) => Obx(
              () => Scaffold(
                backgroundColor: SecureHealthColors.neutralGrey10,
                body: NestedScrollView(
                  headerSliverBuilder: (context, innerBoxIsScrolled) {
                    return [
                      _buildAppBar(context, innerBoxIsScrolled),
                    ];
                  },
                  body: RefreshIndicator(
                    onRefresh: () async {
                      controller.documents.clear();
                      controller.get_documents();
                      controller.counts();
                    },
                    color: SecureHealthColors.coolOrange,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          
                          // User Stats Section
                          FadeInAnimation(
                            duration: const Duration(milliseconds: 600),
                            delay: const Duration(milliseconds: 100),
                            child: UserCardComponent(
                              count: controller
                                  .counts()
                                  .then((value) => value.yourDocuments!),
                              nameFuture: controller
                                  .current_user()
                                  .then((value) => value.data!.name!),
                              sharedByYou: controller
                                  .counts()
                                  .then((value) => value.sharedByYou!),
                              sharedWithYou: controller
                                  .counts()
                                  .then((value) => value.sharedWithYou!),
                            ),
                          ),
                          
                          // Quick Actions Section
                          FadeInAnimation(
                            duration: const Duration(milliseconds: 600),
                            delay: const Duration(milliseconds: 200),
                            child: _buildQuickActions(context, controller),
                          ),
                          
                          const SizedBox(height: 24),
                          
                          // Documents Overview Section
                          FadeInAnimation(
                            duration: const Duration(milliseconds: 600),
                            delay: const Duration(milliseconds: 300),
                            child: DocumentCountComponent(
                              count: controller.documents.length,
                            ),
                          ),
                          
                          const SizedBox(height: 32),
                          
                          // Recent Documents Section
                          _buildRecentDocumentsSection(context, controller),
                          
                          const SizedBox(height: 100), // Space for FAB
                        ],
                      ),
                    ),
                  ),
                ),
                floatingActionButton: _buildFloatingActionButton(context),
              ),
            ));
  }

  Widget _buildAppBar(BuildContext context, bool innerBoxIsScrolled) {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      elevation: innerBoxIsScrolled ? 1 : 0,
      shadowColor: SecureHealthColors.neutralGrey4,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
        title: FadeInAnimation(
          duration: const Duration(milliseconds: 600),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: SecureHealthColors.coolOrange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.security,
                  color: SecureHealthColors.coolOrange,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "SecureHealth",
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: SecureHealthColors.neutralDark,
                    ),
                  ),
                  Text(
                    "Dashboard",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: SecureHealthColors.neutralMedium,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white,
                SecureHealthColors.neutralGrey10,
              ],
            ),
          ),
        ),
      ),
      actions: [
        FadeInAnimation(
          duration: const Duration(milliseconds: 600),
          delay: const Duration(milliseconds: 200),
          child: Container(
            margin: const EdgeInsets.only(right: 16),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: SecureHealthColors.neutralGrey5,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    onPressed: () {
                      // TODO: Implement notifications
                    },
                    icon: Stack(
                      children: [
                        const Icon(
                          Icons.notifications_outlined,
                          color: SecureHealthColors.neutralDark,
                        ),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: SecureHealthColors.coolOrange,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color: SecureHealthColors.neutralGrey5,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    onPressed: () {
                      // TODO: Implement settings
                    },
                    icon: const Icon(
                      Icons.settings_outlined,
                      color: SecureHealthColors.neutralDark,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context, DocumentController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Quick Actions",
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: SecureHealthColors.neutralDark,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildActionCard(
                  context,
                  icon: Icons.cloud_upload_outlined,
                  title: "Upload",
                  subtitle: "Add new document",
                  color: SecureHealthColors.coolOrange,
                  onTap: () => _showUploadModal(context),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionCard(
                  context,
                  icon: Icons.share_outlined,
                  title: "Shared",
                  subtitle: "View shared docs",
                  color: SecureHealthColors.coolBlue,
                  onTap: () => Get.toNamed(Routes.shared),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionCard(
                  context,
                  icon: Icons.folder_shared_outlined,
                  title: "Received",
                  subtitle: "Docs shared with you",
                  color: SecureHealthColors.darkPurple,
                  onTap: () => Get.toNamed(Routes.sharedWithYou),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: UIHelpers.cardDecoration(
            color: Colors.white,
            boxShadow: UIHelpers.elevationShadow(1),
          ),
          child: Column(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: SecureHealthColors.neutralDark,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: SecureHealthColors.neutralMedium,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentDocumentsSection(BuildContext context, DocumentController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FadeInAnimation(
            duration: const Duration(milliseconds: 600),
            delay: const Duration(milliseconds: 400),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Recent Documents",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: SecureHealthColors.neutralDark,
                  ),
                ),
                if (controller.documents.isNotEmpty)
                  TextButton(
                    onPressed: () {
                      // TODO: Navigate to all documents
                    },
                    child: Text(
                      "View All",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: SecureHealthColors.coolOrange,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          controller.documents.isEmpty
              ? _buildEmptyDocumentsState(context)
              : _buildDocumentsList(context, controller),
        ],
      ),
    );
  }

  Widget _buildEmptyDocumentsState(BuildContext context) {
    return FadeInAnimation(
      duration: const Duration(milliseconds: 600),
      delay: const Duration(milliseconds: 500),
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: UIHelpers.cardDecoration(
          color: Colors.white,
          boxShadow: UIHelpers.elevationShadow(1),
        ),
        child: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: SecureHealthColors.coolOrange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Icon(
                Icons.description_outlined,
                size: 40,
                color: SecureHealthColors.coolOrange,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              "No documents yet",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: SecureHealthColors.neutralDark,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Upload your first health document to get started with SecureHealth",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: SecureHealthColors.neutralMedium,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => _showUploadModal(context),
              icon: const Icon(Icons.cloud_upload_outlined),
              label: const Text("Upload First Document"),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentsList(BuildContext context, DocumentController controller) {
    final recentDocs = controller.documents.toList();
    
    return Column(
      children: recentDocs.asMap().entries.map((entry) {
        final index = entry.key;
        final document = entry.value;
        
        return StaggeredItemAnimation(
          index: index,
          baseDelay: const Duration(milliseconds: 500),
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
                  await _launchUrl(document.document!);
                },
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: _getDocumentTypeColor(document.documentName).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: _getDocumentTypeColor(document.documentName).withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Icon(
                          _getDocumentTypeIcon(document.documentName),
                          color: _getDocumentTypeColor(document.documentName),
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              document.documentName ?? 'Untitled Document',
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
                                Icon(
                                  Icons.calendar_today_outlined,
                                  size: 14,
                                  color: SecureHealthColors.neutralMedium,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  DateFormat('MMM dd, yyyy').format(
                                    DateTime.parse(document.createdAt!),
                                  ),
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: SecureHealthColors.neutralMedium,
                                  ),
                                ),
                                if (document.isShared == true) ...[
                                  const SizedBox(width: 12),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: SecureHealthColors.coolBlue.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.share,
                                          size: 10,
                                          color: SecureHealthColors.coolBlue,
                                        ),
                                        const SizedBox(width: 2),
                                        Text(
                                          "Shared",
                                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                            color: SecureHealthColors.coolBlue,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                      _buildDocumentMenu(context, controller, recentDocs.indexOf(document)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
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

  Widget _buildDocumentMenu(BuildContext context, DocumentController controller, int index) {
    return PopupMenuButton<String>(
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: SecureHealthColors.neutralGrey5,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(
          Icons.more_vert,
          size: 16,
          color: SecureHealthColors.neutralMedium,
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      position: PopupMenuPosition.under,
      itemBuilder: (context) => [
        _buildPopupMenuItem(
          'view',
          'View Document',
          Icons.open_in_new_outlined,
          () async {
            await _launchUrl(controller.documents[index].document!);
          },
        ),
        _buildPopupMenuItem(
          'share',
          'Share Document',
          Icons.share_outlined,
          () => _showShareDialog(context, controller, index),
        ),
        _buildPopupMenuItem(
          'delete',
          'Delete Document',
          Icons.delete_outline,
          () => _showDeleteDialog(context, controller, index),
          isDestructive: true,
        ),
      ],
    );
  }

  PopupMenuItem<String> _buildPopupMenuItem(
    String value,
    String text,
    IconData icon,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    return PopupMenuItem<String>(
      value: value,
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: isDestructive ? Colors.red : SecureHealthColors.neutralMedium,
          ),
          const SizedBox(width: 12),
          Text(
            text,
            style: TextStyle(
              color: isDestructive ? Colors.red : SecureHealthColors.neutralDark,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return FadeInAnimation(
      duration: const Duration(milliseconds: 600),
      delay: const Duration(milliseconds: 800),
      child: ScaleAnimation(
        duration: const Duration(milliseconds: 400),
        delay: const Duration(milliseconds: 800),
        child: FloatingActionButton.extended(
          onPressed: () => _showUploadModal(context),
          backgroundColor: SecureHealthColors.coolOrange,
          foregroundColor: Colors.white,
          elevation: 4,
          icon: const Icon(Icons.add),
          label: const Text(
            "Upload",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

  void _showUploadModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const UploadDocumentsModal(),
    );
  }

  void _showShareDialog(BuildContext context, DocumentController controller, int index) {
    final TextEditingController emailController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          "Share Document",
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Enter the email address of the person you want to share this document with:",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: SecureHealthColors.neutralMedium,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: "Enter email address",
                prefixIcon: Icon(Icons.email_outlined),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              final email = emailController.text.trim();
              if (email.isNotEmpty) {
                await controller.share_document(email, controller.documents[index].id!).then((value) {
                  if (context.mounted) Navigator.pop(context);
                  Get.snackbar(
                    value ? 'Success' : 'Failed',
                    value ? 'Document shared successfully' : 'Failed to share document',
                    backgroundColor: value ? Colors.green.shade50 : Colors.red.shade50,
                    colorText: value ? Colors.green.shade900 : Colors.red.shade900,
                    margin: const EdgeInsets.all(16),
                    borderRadius: 12,
                    icon: Icon(
                      value ? Icons.check_circle_outline : Icons.error_outline,
                      color: value ? Colors.green.shade900 : Colors.red.shade900,
                    ),
                  );
                  if (value) {
                    controller.get_documents();
                    controller.counts();
                  }
                });
              }
            },
            child: const Text("Share"),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, DocumentController controller, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          "Delete Document",
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.red.shade700,
          ),
        ),
        content: Text(
          "Are you sure you want to delete this document? This action cannot be undone.",
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: SecureHealthColors.neutralMedium,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              await controller.delete_document(controller.documents[index].id).then((value) {
                if (context.mounted) Navigator.pop(context);
                Get.snackbar(
                  value ? 'Deleted' : 'Failed',
                  value ? 'Document deleted successfully' : 'Failed to delete document',
                  backgroundColor: value ? Colors.green.shade50 : Colors.red.shade50,
                  colorText: value ? Colors.green.shade900 : Colors.red.shade900,
                  margin: const EdgeInsets.all(16),
                  borderRadius: 12,
                  icon: Icon(
                    value ? Icons.check_circle_outline : Icons.error_outline,
                    color: value ? Colors.green.shade900 : Colors.red.shade900,
                  ),
                );
                if (value) {
                  controller.documents.clear();
                  controller.get_documents();
                }
              });
            },
            child: const Text("Delete"),
          ),
        ],
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