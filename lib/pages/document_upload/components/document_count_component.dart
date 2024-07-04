import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class DocumentCountComponent extends StatelessWidget {
  final int count;
  const DocumentCountComponent({super.key,required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Color(0xFF240046), borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Your Documents",
                    style: GoogleFonts.inter(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w400),
                  ),
                  Text(
                    count.toString(),
                    style: GoogleFonts.inter(
                        fontSize: 46,
                        color: Colors.white,
                        fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              Icon(
                Icons.article_sharp,
                color: Colors.white.withOpacity(
                  0.2,
                ),
                size: 100,
              )
            ],
          ),
          Gap(10),
          ElevatedButton(
              onPressed: () {},
              child: Text(
                "Upload Documents",
                style: GoogleFonts.inter(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.w400),
              ))
        ],
      ),
    );
  }
}
