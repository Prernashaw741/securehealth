import 'package:flutter/material.dart';

class SignUpInput extends StatefulWidget {
  final String label;
  bool isPassword;
  SignUpInput({super.key, required this.label, required this.isPassword});

  @override
  State<SignUpInput> createState() => _SignUpInputState();
}

class _SignUpInputState extends State<SignUpInput> {
  @override
  Widget build(BuildContext context) {
    return TextField(
        obscureText: widget.isPassword,
        decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(),
            label: Text(widget.label),
            contentPadding: EdgeInsets.all(15),
            suffix: widget.label.toLowerCase() == "password"
                ? InkWell(
                    child: Container(
                      margin: EdgeInsets.only(
                        right: 5,
                      ),
                      child: widget.isPassword? Icon(Icons.visibility_outlined) : Icon(
                        Icons.visibility_off_outlined,
                      
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        widget.isPassword = !widget.isPassword;
                      });
                    },
                  )
                : null));
  }
}
