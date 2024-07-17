import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lilac_test/constatnts/styles.dart';
import 'package:lilac_test/data/local/provider/auth_provider.dart';
import 'package:lilac_test/data/local/provider/video_provider.dart';
import 'package:lilac_test/data/models/user_model.dart';
import 'package:lilac_test/presentation/screens/auth/otp_screen.dart';
import 'package:lilac_test/presentation/screens/auth/signup_screen.dart';
import 'package:lilac_test/widgets/custom_textfield.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController mobileNumberController = TextEditingController();
    GlobalKey<FormState> formKey = GlobalKey<FormState>();

    AuthProvider authProvider = AuthProvider();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'LOG IN',
              style: AppStyles.getSemioBoldStyle(fontSize: 20, context: context),
            ),
            SizedBox(height: 60),
            Form(
              key: formKey,
              child: CustomTextField(
                hint: 'Mobile Number',
                validator: (v) {
                  if (v!.length <= 6 || v.length >= 12) {
                    return 'Enter a valid number';
                  }
                },
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                controller: mobileNumberController,
              ),
            ),
            SizedBox(height: 15),
            TextButton(
              onPressed: () async {
                if (!formKey.currentState!.validate()) {
                  return;
                }
                UserModel? userModel = await authProvider.fetchFromLocal();
                if (userModel == null || userModel.phone != mobileNumberController.text) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.green.shade800,
                      content: Text(
                        'User not found. Please sign up',
                        style: AppStyles.getMediumStyle(fontSize: 15, context: context, fontColor: Colors.white),
                      ),
                    ),
                  );
                  return;
                }

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (c) => OtpScreen(phoneNumber: mobileNumberController.text),
                  ),
                );
              },
              style: AppStyles.filledButton.copyWith(
                fixedSize: WidgetStateProperty.all(
                  Size(MediaQuery.sizeOf(context).width, 60),
                ),
              ),
              child: Text('Login'),
            ),
            TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (c) => SignupScreen(),
                ),
              ),
              child: Text(
                'Dont have an account? Sign up!.',
                style: AppStyles.getMediumStyle(
                  fontSize: 12,
                  context: context,
                  fontColor: Colors.green.shade500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
