import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:securehealth/constants/colors.dart';
import 'package:securehealth/constants/routes.dart';
import 'package:securehealth/pages/signup/components/input.dart';
import 'package:securehealth/pages/signup/controller/login_controller.dart';
import 'package:securehealth/utils/animations.dart';
import 'package:securehealth/utils/ui_helpers.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: LoginController(),
      builder: (controller) => Scaffold(
        backgroundColor: SecureHealthColors.neutralGrey10,
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              // Background decoration
              Positioned(
                right: -50,
                top: -50,
                child: FadeInAnimation(
                  duration: const Duration(milliseconds: 800),
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          SecureHealthColors.coolOrange.withOpacity(0.1),
                          SecureHealthColors.coolOrange.withOpacity(0.05),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: -100,
                bottom: -100,
                child: FadeInAnimation(
                  duration: const Duration(milliseconds: 800),
                  delay: const Duration(milliseconds: 200),
                  child: Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          SecureHealthColors.darkPurple.withOpacity(0.05),
                          SecureHealthColors.darkPurple.withOpacity(0.02),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // Main content
              SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 40),
                        // Logo and brand
                        FadeInAnimation(
                          duration: const Duration(milliseconds: 600),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: UIHelpers.elevationShadow(2),
                                ),
                                child: SvgPicture.asset("assets/logo.svg", height: 32),
                              ),
                              const SizedBox(width: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "SecureHealth",
                                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: SecureHealthColors.neutralDark,
                                    ),
                                  ),
                                  Text(
                                    "Your health data, secured",
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: SecureHealthColors.neutralMedium,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 60),
                        // Welcome text
                        FadeInAnimation(
                          duration: const Duration(milliseconds: 600),
                          delay: const Duration(milliseconds: 200),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Welcome back!",
                                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: SecureHealthColors.neutralDark,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Sign in to continue managing your health documents",
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: SecureHealthColors.neutralMedium,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),
                        // Form fields
                        FadeInAnimation(
                          duration: const Duration(milliseconds: 600),
                          delay: const Duration(milliseconds: 400),
                          child: Container(
                            padding: const EdgeInsets.all(24),
                            decoration: UIHelpers.cardDecoration(
                              color: Colors.white,
                              boxShadow: UIHelpers.elevationShadow(1),
                            ),
                            child: Column(
                              children: [
                                SignUpInput(
                                  label: "Email",
                                  isPassword: false,
                                  controller: controller.email,
                                ),
                                const SizedBox(height: 20),
                                SignUpInput(
                                  label: "Password",
                                  isPassword: true,
                                  controller: controller.password,
                                ),
                                const SizedBox(height: 8),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: () {
                                      // TODO: Implement forgot password
                                    },
                                    child: Text(
                                      "Forgot password?",
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: SecureHealthColors.coolOrange,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        // Login button
                        FadeInAnimation(
                          duration: const Duration(milliseconds: 600),
                          delay: const Duration(milliseconds: 600),
                          child: Obx(() => ElevatedButton(
                            onPressed: controller.isLoading.value ? null : () async {
                              await controller.login().then((value) {
                                if (value) {
                                  Get.offNamed(Routes.dashboard);
                                } else {
                                  Get.snackbar(
                                    'Login Failed',
                                    'Invalid email or password',
                                    backgroundColor: Colors.red.shade50,
                                    colorText: Colors.red.shade900,
                                    margin: const EdgeInsets.all(16),
                                    borderRadius: 12,
                                    duration: const Duration(seconds: 3),
                                    icon: Icon(
                                      Icons.error_outline,
                                      color: Colors.red.shade900,
                                    ),
                                  );
                                }
                              });
                            },
                            child: controller.isLoading.value
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                : const Text("Sign In"),
                          )),
                        ),
                        const SizedBox(height: 16),
                        // Divider
                        FadeInAnimation(
                          duration: const Duration(milliseconds: 600),
                          delay: const Duration(milliseconds: 700),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 1,
                                  color: SecureHealthColors.neutralGrey4,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  "or",
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: SecureHealthColors.neutralGrey2,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  height: 1,
                                  color: SecureHealthColors.neutralGrey4,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Sign up button
                        FadeInAnimation(
                          duration: const Duration(milliseconds: 600),
                          delay: const Duration(milliseconds: 800),
                          child: OutlinedButton(
                            onPressed: () {
                              Get.toNamed(Routes.signup);
                            },
                            child: const Text("Create New Account"),
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}