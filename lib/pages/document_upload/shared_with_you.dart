import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:securehealth/pages/document_upload/controllers/document_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class SharedWithYouList extends StatelessWidget {
  // final List<DocumentModel> documents;
  
  const SharedWithYouList({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: DocumentController(),
      builder: (controller) =>  Obx(() => Scaffold(
        appBar: AppBar(
          title:  Text("Shared With You",style: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF240046),
          ),),
          centerTitle: true,
        ),
        body: Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          color: Colors.white,
          child: ListView.builder(
            itemCount: controller.sharedWithYou.length,
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
                          await _launchUrl(controller.sharedWithYou[index].document!);
                        },
                        child: Text("View"),
                      ),
                      // PopupMenuItem(
                      //   onTap: () async {
                      //     showDialog(
                      //       context: context,
                      //       builder: (context) {
                      //         return AlertDialog(
                      //           title: const Text("Delete Document"),
                      //           content: const Text(
                      //               "Are you sure you want to delete this document?"),
                      //           actions: [
                      //             TextButton(
                      //                 onPressed: () {
                      //                   Navigator.pop(context);
                      //                 },
                      //                 child: const Text("Cancel")),
                      //             TextButton(
                      //                 onPressed: () async {
                      //                   await controller
                      //                       .delete_document(
                      //                           controller.sharedWithYou[index].id)
                      //                       .then((value) => value
                      //                           ? ScaffoldMessenger.of(context)
                      //                               .showSnackBar(const SnackBar(
                      //                                   content: Text(
                      //                                       "Document Deleted")))
                      //                           : ScaffoldMessenger.of(context)
                      //                               .showSnackBar(const SnackBar(
                      //                                   content: Text(
                      //                                       "Document Deletion Failed"))));
                      //                   controller.sharedWithYou.clear();
                      //                   controller.get_documents();
                      //                   Navigator.pop(context);
                      //                 },
                      //                 child: const Text("Delete"))
                      //           ],
                      //         );
                      //       },
                      //     );
                      //   },
                      //   child: Text("Delete"),
                      // ),
                      // PopupMenuItem(
                      //     onTap: () {
                      //       showDialog(
                      //           context: context,
                      //           builder: (context) {
                      //             return AlertDialog(
                      //               title: const Text("Share Document"),
                      //               content: Container(
                      //                 padding: EdgeInsets.all(5),
                      //                 decoration: BoxDecoration(
                      //                     border: Border.all(color: Colors.grey),
                      //                     borderRadius: BorderRadius.circular(5)),
                      //                 child: TextFormField(
                      //                   controller: textController,
                      //                   decoration: InputDecoration.collapsed(
                      //                       hintText: "Email",
                      //                       hintStyle: GoogleFonts.inter(
                      //                           fontSize: 15,
                      //                           color: Colors.grey,
                      //                           fontWeight: FontWeight.w400)),
                      //                 ),
                      //               ),
                      //               actions: [
                      //                 TextButton(
                      //                     onPressed: () {
                      //                       Navigator.pop(context);
                      //                     },
                      //                     child: const Text("Cancel")),
                      //                 TextButton(
                      //                     onPressed: () async {
                      //                       final email = textController.text;
                      //                       await controller
                      //                           .share_document(email,
                      //                               controller.sharedWithYou[index].id!)
                      //                           .then((value) => value
                      //                               ? ScaffoldMessenger.of(context)
                      //                                   .showSnackBar(const SnackBar(
                      //                                       content: Text(
                      //                                           "Document Shared")))
                      //                               : ScaffoldMessenger.of(context)
                      //                                   .showSnackBar(const SnackBar(
                      //                                       content: Text(
                      //                                           "Document Sharing Failed"))));
                      //                       // await Share.share(
                      //                       //     'check out my document from SecureHealth ${controller.sharedWithYou[index].document}');
                      //                       Navigator.pop(context);
                      //                       controller.get_documents();
                      //                       controller.counts();
                      //                     },
                      //                     child: const Text("Share"))
                      //               ],
                      //             );
                      //           });
        
                      //       // await Share.share(
                      //       //     'check out my document from SecureHealth ${controller.sharedWithYou[index].document}');
                      //     },
                      //     child: Text("Share"))
                    
                    ];
                  },
                ),
                leading: const CircleAvatar(
                  child: Icon(Icons.article_sharp),
                ),
                title: Text("${controller.sharedWithYou[index].documentName}"),
                subtitle: Text(DateFormat('dd MMMM yyyy').format(
                    DateTime.parse(controller.sharedWithYou[index].createdAt!))),
              );
            },
          ),
        ),
      ),)
    );
  }
  Future<void> _launchUrl(uri) async {
    var _url = Uri.parse(uri);
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }
}
