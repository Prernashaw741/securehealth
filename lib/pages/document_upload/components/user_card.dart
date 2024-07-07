import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:securehealth/pages/document_upload/components/upload_documents_modal.dart';
import 'package:securehealth/pages/document_upload/shared.dart';
import 'package:securehealth/pages/document_upload/shared_with_you.dart';
import 'package:shimmer/shimmer.dart';

class UserCardComponent extends StatefulWidget {
  final Future<int> count;
  final Future<int> sharedWithYou;
  final Future<int> sharedByYou;
  final Future<String> nameFuture; // Change to Future<String>

  const UserCardComponent({
    Key? key,
    required this.count,
    required this.nameFuture,
    required this.sharedByYou,
    required this.sharedWithYou,
  }) : super(key: key);

  @override
  _UserCardComponentState createState() => _UserCardComponentState();
}

class _UserCardComponentState extends State<UserCardComponent>
    with AutomaticKeepAliveClientMixin {
  late Future<String> _nameFuture;
  late Future<int> _countFuture;
  late Future<int> _sharedWithYouFuture;
  late Future<int> _sharedByYouFuture;

  @override
  void initState() {
    super.initState();
    _nameFuture = widget.nameFuture;
    _countFuture = widget.count;
    _sharedWithYouFuture = widget.sharedWithYou;
    _sharedByYouFuture = widget.sharedByYou;
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context); // Ensure that the mixin is initialized

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[200],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FutureBuilder<String>(
            future: _nameFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            width: 100,
                            height: 20,
                          ),
                          Gap(10),
                          Container(
                            width: 200,
                            height: 30,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          )
                        ],
                      ),
                      Icon(
                        Icons.circle,
                        color: Color(0xFF240046),
                        size: 80,
                      )
                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.hasData) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Welcome!",
                          style: GoogleFonts.inter(
                              fontSize: 16,
                              color: Color(0xFF240046),
                              fontWeight: FontWeight.w400),
                        ),
                        Text(
                          snapshot.data!, // Use fetched name
                          style: GoogleFonts.inter(
                              fontSize: 25,
                              color: Color(0xFF240046),
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    Icon(
                      Icons.person_3_sharp,
                      color: Color(0xFF240046),
                      size: 80,
                    )
                  ],
                );
              } else {
                return Text('No data');
              }
            },
          ),
          const Gap(10),
          Wrap(
            spacing: 10,
            crossAxisAlignment: WrapCrossAlignment.center,
            alignment: WrapAlignment.spaceEvenly,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Your\nDocuments",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                        fontSize: 11,
                        color: Color(0xFF240046),
                        fontWeight: FontWeight.w400),
                  ),
                  FutureBuilder<int>(
                    future: _countFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                              width: 25,
                              height: 25,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                              )),
                        );
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (snapshot.hasData) {
                        return Text(
                          snapshot.data.toString(),
                          style: GoogleFonts.inter(
                            fontSize: 25,
                            color: Color(0xFF240046),
                            fontWeight: FontWeight.w700,
                          ),
                        );
                      } else {
                        return Text('No data');
                      }
                    },
                  ),
                ],
              ),
              Container(
                width: 1,
                height: 50,
                color: Color(0xFF240046).withOpacity(0.5),
              ),
              GestureDetector(
                onTap: () {
                  Get.to(SharedWithYouList());
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Shared\n With You",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                          fontSize: 11,
                          color: Color(0xFF240046),
                          fontWeight: FontWeight.w400),
                    ),
                    FutureBuilder<int>(
                      future: _sharedWithYouFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                                width: 25,
                                height: 25,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                )),
                          );
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (snapshot.hasData) {
                          return Text(
                            snapshot.data.toString(),
                            style: GoogleFonts.inter(
                              fontSize: 25,
                              color: Color(0xFF240046),
                              fontWeight: FontWeight.w700,
                            ),
                          );
                        } else {
                          return Text('No data');
                        }
                      },
                    ),
                  ],
                ),
              ),
              Container(
                width: 1,
                height: 50,
                color: Color(0xFF240046).withOpacity(0.5),
              ),
              GestureDetector(
                onTap: () {
                  Get.to(SharedList());
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Shared\n By You",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                          fontSize: 11,
                          color: Color(0xFF240046),
                          fontWeight: FontWeight.w400),
                    ),
                    FutureBuilder<int>(
                      future: _sharedByYouFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                                width: 25,
                                height: 25,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                )),
                          );
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (snapshot.hasData) {
                          return Text(
                            snapshot.data.toString(),
                            style: GoogleFonts.inter(
                              fontSize: 25,
                              color: Color(0xFF240046),
                              fontWeight: FontWeight.w700,
                            ),
                          );
                        } else {
                          return Text('No data');
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
