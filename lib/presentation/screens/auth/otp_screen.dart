import 'package:flutter/material.dart';
import 'package:lilac_test/constatnts/styles.dart';
import 'package:lilac_test/presentation/screens/home.dart';
import 'package:lilac_test/widgets/otp_field.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key, required this.phoneNumber});
  final String phoneNumber;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Enter your OTP Sent to $phoneNumber',
              style: AppStyles.getMediumStyle(fontSize: 20, context: context),
            ),
            SizedBox(height: 20),
            OtpFieldSection(),
            SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                style: AppStyles.filledButton.copyWith(
                    fixedSize: WidgetStatePropertyAll(
                  Size(MediaQuery.sizeOf(context).width, 60),
                )),
                onPressed: () => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (c) => HomeScreen(),
                    ),
                    (route) => false),
                child: Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
