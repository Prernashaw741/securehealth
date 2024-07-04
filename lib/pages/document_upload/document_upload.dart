import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:securehealth/pages/document_upload/components/document_count_component.dart';

class DocumentUpload extends StatelessWidget {
  const DocumentUpload({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            const DocumentCountComponent(
              count: 90,
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
                itemCount: 10,
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
                          const PopupMenuItem(
                            child: Text("View"),
                          ),
                          const PopupMenuItem(
                            child: Text("Delete"),
                          ),
                          const PopupMenuItem(child: Text("Share"))
                        ];
                      },
                    ),
                    leading: const CircleAvatar(
                      child: Icon(Icons.article_sharp),
                    ),
                    title: const Text("Blood Report"),
                    subtitle: const Text("26 Feb 2024"),
                  );
                },
              ),
            ))
          ],
        ),
      ),
    );
  }
}
