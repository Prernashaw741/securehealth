import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:securehealth/constants/colors.dart';
import 'package:securehealth/constants/routes.dart';
import 'package:securehealth/pages/signup/components/input.dart';
import 'package:securehealth/pages/signup/controller/signup_controller.dart';
import 'package:securehealth/utils/animations.dart';
import 'package:securehealth/utils/ui_helpers.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: SignUpController(),
      builder: (controller) => Obx(() => Scaffold(
        backgroundColor: SecureHealthColors.neutralGrey10,
        body: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                // Background decoration
                Positioned(
                  right: -80,
                  top: -80,
                  child: FadeInAnimation(
                    duration: const Duration(milliseconds: 800),
                    child: Container(
                      width: 250,
                      height: 250,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            SecureHealthColors.darkPurple.withOpacity(0.08),
                            SecureHealthColors.darkPurple.withOpacity(0.03),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: -120,
                  bottom: -120,
                  child: FadeInAnimation(
                    duration: const Duration(milliseconds: 800),
                    delay: const Duration(milliseconds: 200),
                    child: Container(
                      width: 320,
                      height: 320,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            SecureHealthColors.coolBlue.withOpacity(0.06),
                            SecureHealthColors.coolBlue.withOpacity(0.02),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                // Main content
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 30),
                        // Logo and brand
                        FadeInAnimation(
                          duration: const Duration(milliseconds: 600),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () => Get.back(),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: UIHelpers.elevationShadow(1),
                                  ),
                                  child: const Icon(
                                    Icons.arrow_back_ios,
                                    size: 20,
                                    color: SecureHealthColors.neutralDark,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: UIHelpers.elevationShadow(1),
                                ),
                                child: SvgPicture.asset("assets/logo.svg", height: 24),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "SecureHealth",
                                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: SecureHealthColors.neutralDark,
                                    ),
                                  ),
                                  Text(
                                    "Create your account",
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: SecureHealthColors.neutralMedium,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),
                        // Welcome text
                        FadeInAnimation(
                          duration: const Duration(milliseconds: 600),
                          delay: const Duration(milliseconds: 200),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Join SecureHealth",
                                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: SecureHealthColors.neutralDark,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Create your account to start managing your health documents securely",
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: SecureHealthColors.neutralMedium,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
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
                                  label: "Full Name",
                                  isPassword: false,
                                  controller: controller.nameController.value,
                                ),
                                const SizedBox(height: 20),
                                SignUpInput(
                                  label: "Email",
                                  isPassword: false,
                                  controller: controller.emailController.value,
                                ),
                                const SizedBox(height: 20),
                                SignUpInput(
                                  label: "Password",
                                  isPassword: true,
                                  controller: controller.passwordController.value,
                                ),
                                const SizedBox(height: 20),
                                // Terms and conditions
                                Row(
                                  children: [
                                    Obx(() => Checkbox(
                                      value: controller.agreeToTerms.value,
                                      onChanged: (value) {
                                        controller.agreeToTerms.value = value ?? false;
                                      },
                                      activeColor: SecureHealthColors.coolOrange,
                                    )),
                                    Expanded(
                                      child: Text.rich(
                                        TextSpan(
                                          text: "I agree to the ",
                                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                            color: SecureHealthColors.neutralMedium,
                                          ),
                                          children: [
                                            TextSpan(
                                              text: "Terms of Service",
                                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                color: SecureHealthColors.coolOrange,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const TextSpan(text: " and "),
                                            TextSpan(
                                              text: "Privacy Policy",
                                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                color: SecureHealthColors.coolOrange,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        // Sign up button
                        FadeInAnimation(
                          duration: const Duration(milliseconds: 600),
                          delay: const Duration(milliseconds: 600),
                          child: Obx(() => ElevatedButton(
                            onPressed: (controller.isLoading.value || !controller.agreeToTerms.value) 
                                ? null 
                                : () async {
                              await controller.signup().then((value) {
                                if (value) {
                                  Get.snackbar(
                                    'Success',
                                    'Account created successfully! Please login.',
                                    backgroundColor: Colors.green.shade50,
                                    colorText: Colors.green.shade900,
                                    margin: const EdgeInsets.all(16),
                                    borderRadius: 12,
                                    duration: const Duration(seconds: 3),
                                    icon: Icon(
                                      Icons.check_circle_outline,
                                      color: Colors.green.shade900,
                                    ),
                                  );
                                  Get.offNamed(Routes.login);
                                } else {
                                  Get.snackbar(
                                    'Sign Up Failed',
                                    'Please check your information and try again',
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
                                : const Text("Create Account"),
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
                        // Login button
                        FadeInAnimation(
                          duration: const Duration(milliseconds: 600),
                          delay: const Duration(milliseconds: 800),
                          child: OutlinedButton(
                            onPressed: () {
                              Get.offNamed(Routes.login);
                            },
                            child: const Text("Already have an account? Sign In"),
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }
}