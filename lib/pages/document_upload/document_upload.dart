import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:securehealth/pages/document_upload/components/document_count_component.dart';
import 'package:securehealth/pages/document_upload/components/user_card.dart';
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
              () => Scaffold(
                extendBody: true,
                // extendBodyBehindAppBar: true,
                appBar: AppBar(
                  backgroundColor: Colors.grey[200],
                  surfaceTintColor: Colors.transparent,
                  centerTitle: true,
                  title: Text(
                    "SecureHealth",
                    style: GoogleFonts.inter(
                        fontSize: 15,
                        color: const Color(0xFF240046),
                        fontWeight: FontWeight.w500),
                  ),
                  actions: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.settings_outlined,
                        color: Color(0xFF240046),
                      ),
                    )
                  ],
                  // toolbarHeight: kToolbarHeight * 2,
                ),
                body: Column(
                  children: [
                    UserCardComponent(
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
                              "Recent Uploads",
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
                          final TextEditingController textController =
                              new TextEditingController();
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
                                                  child: const Text("Cancel")),
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
                                                                    .of(context)
                                                                .showSnackBar(
                                                                    const SnackBar(
                                                                        content:
                                                                            Text(
                                                                                "Document Deleted")))
                                                            : ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                                    const SnackBar(
                                                                        content:
                                                                            Text("Document Deletion Failed"))));
                                                    controller.documents
                                                        .clear();
                                                    controller.get_documents();
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
                                      onTap: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: const Text(
                                                    "Share Document"),
                                                content: Container(
                                                  padding: EdgeInsets.all(5),
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors.grey),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
                                                  child: TextFormField(
                                                    controller: textController,
                                                    decoration: InputDecoration
                                                        .collapsed(
                                                            hintText: "Email",
                                                            hintStyle: GoogleFonts.inter(
                                                                fontSize: 15,
                                                                color:
                                                                    Colors.grey,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400)),
                                                  ),
                                                ),
                                                actions: [
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child:
                                                          const Text("Cancel")),
                                                  TextButton(
                                                      onPressed: () async {
                                                        final email =
                                                            textController.text;
                                                        await controller
                                                            .share_document(
                                                                email,
                                                                controller
                                                                    .documents[
                                                                        index]
                                                                    .id!)
                                                            .then((value) => value
                                                                ? ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(const SnackBar(
                                                                        content:
                                                                            Text(
                                                                                "Document Shared")))
                                                                : ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(const SnackBar(
                                                                        content:
                                                                            Text("Document Sharing Failed"))));
                                                        // await Share.share(
                                                        //     'check out my document from SecureHealth ${controller.documents[index].document}');
                                                        Navigator.pop(context);
                                                        controller
                                                            .get_documents();
                                                        controller.counts();
                                                      },
                                                      child:
                                                          const Text("Share"))
                                                ],
                                              );
                                            });

                                        // await Share.share(
                                        //     'check out my document from SecureHealth ${controller.documents[index].document}');
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
            ));
  }

  Future<void> _launchUrl(uri) async {
    var _url = Uri.parse(uri);
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }
}
