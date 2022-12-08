import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinput/pinput.dart';

class OtpPage extends ConsumerStatefulWidget {
  final String verificationId;
  final String phoneNumber;
  const OtpPage({
    super.key,
    required this.verificationId,
    required this.phoneNumber,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _OtpPageState();
}

class _OtpPageState extends ConsumerState<OtpPage> {
  final pinController = TextEditingController();
  final focusNode = FocusNode();

  @override
  void dispose() {
    pinController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  void onVerify() async {
    EasyLoading.show(status: 'Verifying...');
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: pinController.text,
      );
      await FirebaseAuth.instance
          .signInWithCredential(credential)
          .then((value) {
        EasyLoading.showSuccess('Login Successful');
        Navigator.of(context).pop();
      });
    } on FirebaseAuthException catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError(e.message!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OTP Verification'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 32),
            Text(
              "Code has been sent to ${widget.phoneNumber}",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Pinput(
              controller: pinController,
              focusNode: focusNode,
              listenForMultipleSmsOnAndroid: true,
              hapticFeedbackType: HapticFeedbackType.lightImpact,
              length: 6,
              pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
              showCursor: true,
              onCompleted: (value) {
                print(value);
              },
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: onVerify,
              child: const Text("Verify"),
            )
          ],
        ),
      ),
    );
  }
}
