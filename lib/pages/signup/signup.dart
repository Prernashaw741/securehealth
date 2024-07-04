import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:securehealth/constants/colors.dart';
import 'package:securehealth/pages/signup/components/input.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Positioned(
              child: Image.asset("assets/bg.png"),
              right: 0,
              top: 0,
            ),
            Container(
              margin: const EdgeInsets.only(
                top: kToolbarHeight,
                left: 15,
                right: 15,
              ),
              color: Colors.transparent,
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset("assets/logo.svg", height: 30),
                      const SizedBox(width: 10),
                      Text(
                        "SecureHealth",
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Text(
                    "Create a new account",
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Please put your information below to create a new account",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  
                   SignUpInput(
                    label: "Full Name",
                    isPassword: false,
                  ),
                  const SizedBox(
                    height: 20,
                  
                  ),
                   SignUpInput(
                    label: "Email",
                    isPassword: false,
                  ),
                  const SizedBox(
                    height: 20,
                  
                  ),
                   SignUpInput(
                    label: "Password",
                    isPassword: true,
                  
                  ),
                  const SizedBox(
                    height: 30,
                  ),

                  ElevatedButton(
                    
                    onPressed: () {
                    
                  }, child: Text(
                    "Sign Up",
                   
                    
                  ))


                ],
              ),
            ),
            
          ],
        ),
      ),
    );
  }
}
