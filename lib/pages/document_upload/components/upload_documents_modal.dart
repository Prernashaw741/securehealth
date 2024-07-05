import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:securehealth/pages/document_upload/controllers/file_upload_controller.dart';

class UploadDocumentsModal extends StatelessWidget {
  const UploadDocumentsModal({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: FileUploadController(),
        builder: (controller) => Obx(
              () => Container(
                // width: MediaQuery.of(context).size.width,

                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Form(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          "Upload Documents",
                          style: GoogleFonts.inter(
                            fontSize: 16,
                          ),
                        ),
                        Gap(10),
                        ElevatedButton(
                            onPressed: () async {
                              FilePickerResult? result = await FilePicker
                                  .platform
                                  .pickFiles(withData: true);
                              if (result != null) {
                                PlatformFile file = result.files.first;

                                controller.is_uploaded.value = true;
                              } else {
                                // User canceled the picker
                              }
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  const Color(0xFF240046)),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ),
                            child: Text(
                              "Upload",
                              style: GoogleFonts.inter(
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400),
                            )),
                        Gap(2),
                        controller.is_uploaded.value
                            ? Wrap(
                                spacing: 5,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                    size: 18,
                                  ),
                                  Text(
                                    "File Uploaded Successfully",
                                    style: GoogleFonts.inter(
                                        fontSize: 15,
                                        color: Colors.green,
                                        fontWeight: FontWeight.w400),
                                  )
                                ],
                              )
                            : Container(),
                        Gap(20),
                        TextFormField(
                          decoration: InputDecoration(
                              hintText: "Document Name",
                              labelText: "Document Name",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              hintStyle: GoogleFonts.inter(
                                  fontSize: 15,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w400),
                              labelStyle: GoogleFonts.inter(
                                  fontSize: 15,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w400)),
                        ),
                        Gap(10),
                        ElevatedButton(onPressed: () {}, child: Text("Submit"))
                      ],
                    ),
                  ),
                ),
              ),
            ));
  }
}
