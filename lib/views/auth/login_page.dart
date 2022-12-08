import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:justus_couple/helpers/constants.dart';
import 'package:justus_couple/views/auth/otp_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  String _phoneNumber = "";

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(AppConstants.appName,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline2),
                  const SizedBox(height: 64),
                  Text(
                    "Enter your phone number to continue",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 32),
                  InternationalPhoneNumberInput(
                    selectorConfig: const SelectorConfig(
                      selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                      leadingPadding: 0,
                      setSelectorButtonAsPrefixIcon: true,
                      trailingSpace: false,
                      useEmoji: true,
                    ),
                    onInputChanged: (PhoneNumber number) {
                      _phoneNumber = number.phoneNumber ?? "";
                    },
                    textFieldController: _phoneController,
                    validator: (value) {
                      return value!.isEmpty ? "Phone number is required" : null;
                    },
                    autoValidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        EasyLoading.show(status: "Sending OTP");
                        await FirebaseAuth.instance.verifyPhoneNumber(
                          phoneNumber: _phoneNumber,
                          verificationCompleted:
                              (PhoneAuthCredential credential) {},
                          verificationFailed: (FirebaseAuthException e) {
                            EasyLoading.showError(e.message ?? "");
                          },
                          codeSent: (String verificationId, int? resendToken) {
                            EasyLoading.dismiss();
                            FocusScope.of(context).unfocus();
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => OtpPage(
                                    phoneNumber: _phoneNumber,
                                    verificationId: verificationId),
                              ),
                            );
                          },
                          codeAutoRetrievalTimeout: (String verificationId) {},
                        );
                      }
                    },
                    child: const Text("Send OTP"),
                  ),
                  const SizedBox(height: 16),
                  const AgreeTermsAndPrivacySection(),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AgreeTermsAndPrivacySection extends StatelessWidget {
  final String? text;
  const AgreeTermsAndPrivacySection({
    Key? key,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text.rich(
        TextSpan(
          text: text ?? "By signing in, you agree to our ",
          style: Theme.of(context).textTheme.caption,
          children: [
            TextSpan(
              text: "Terms of Service",
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  print("Terms of Service");
                  //TODO: Navigate to Terms of Service
                },
              style: Theme.of(context)
                  .textTheme
                  .caption!
                  .copyWith(color: Theme.of(context).colorScheme.primary),
            ),
            const TextSpan(text: " and "),
            TextSpan(
              text: "Privacy Policy",
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  print("Privacy Policy");
                  //TODO: Navigate to Privacy Policy
                },
              style: Theme.of(context).textTheme.caption!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
