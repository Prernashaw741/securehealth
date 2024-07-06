import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:securehealth/pages/document_upload/components/document_count_component.dart';
import 'package:securehealth/pages/document_upload/controllers/document_controller.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class DocumentUpload extends StatelessWidget {
  const DocumentUpload({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: DocumentController(),
        builder: (controller) => Obx(
              () => SafeArea(
                child: Scaffold(
                  body: Column(
                    children: [
                      DocumentCountComponent(
                        count: controller.documents.length,
                      ),
                      const Gap(20),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        color: Colors.transparent,
                        margin: const EdgeInsets.symmetric(
                          horizontal: 10,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                // height: 10,
                                color: Colors.white,
                                child: Divider(
                                  color: Colors.grey[200],
                                ),
                              ),
                            ),
                            Container(
                              // height: 10,
                              margin: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              alignment: Alignment.center,
                              color: Colors.white,
                              child: Text(
                                "Recent Transactions",
                                style: GoogleFonts.inter(
                                    fontSize: 13,
                                    color: Colors.black.withOpacity(0.5),
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                // height: 10,
                                color: Colors.white,
                                child: Divider(
                                  color: Colors.grey[200],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                          child: Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 10,
                        ),
                        color: Colors.white,
                        child: ListView.builder(
                          itemCount: controller.documents.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              onTap: () {
                                print("CLIECKED");
                              },
                              trailing: PopupMenuButton(
                                icon: const Icon(Icons.more_horiz),
                                position: PopupMenuPosition.under,
                                itemBuilder: (context) {
                                  return [
                                    PopupMenuItem(
                                      onTap: () async {
                                        await _launchUrl(controller
                                            .documents[index].document!);
                                      },
                                      child: Text("View"),
                                    ),
                                    PopupMenuItem(
                                      onTap: () async {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title:
                                                  const Text("Delete Document"),
                                              content: const Text(
                                                  "Are you sure you want to delete this document?"),
                                              actions: [
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child:
                                                        const Text("Cancel")),
                                                TextButton(
                                                    onPressed: () async {
                                                      await controller
                                                          .delete_document(
                                                              controller
                                                                  .documents[
                                                                      index]
                                                                  .id)
                                                          .then((value) => value
                                                              ? ScaffoldMessenger
                                                                      .of(
                                                                          context)
                                                                  .showSnackBar(
                                                                      const SnackBar(
                                                                          content: Text(
                                                                              "Document Deleted")))
                                                              : ScaffoldMessenger
                                                                      .of(
                                                                          context)
                                                                  .showSnackBar(
                                                                      const SnackBar(
                                                                          content:
                                                                              Text("Document Deletion Failed"))));
                                                      controller.documents
                                                          .clear();
                                                      controller
                                                          .get_documents();
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text("Delete"))
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      child: Text("Delete"),
                                    ),
                                    PopupMenuItem(
                                        onTap: () async {
                                          await Share.share(
                                              'check out my document from SecureHealth ${controller.documents[index].document}');
                                        },
                                        child: Text("Share"))
                                  ];
                                },
                              ),
                              leading: const CircleAvatar(
                                child: Icon(Icons.article_sharp),
                              ),
                              title: Text(
                                  "${controller.documents[index].documentName}"),
                              subtitle: Text(DateFormat('dd MMMM yyyy').format(
                                  DateTime.parse(
                                      controller.documents[index].createdAt!))),
                            );
                          },
                        ),
                      ))
                    ],
                  ),
                ),
              ),
            ));
  }

  Future<void> _launchUrl(uri) async {
    var _url = Uri.parse(uri);
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }
}
