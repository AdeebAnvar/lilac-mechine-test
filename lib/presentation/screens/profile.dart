import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lilac_test/constatnts/styles.dart';
import 'package:lilac_test/data/models/user_model.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, required this.userModel});
  final UserModel userModel;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: FileImage(userModel.image!),
            ),
            SizedBox(height: 20),
            buildText(userModel.name!, context),
            SizedBox(height: 20),
            buildText(userModel.phone!, context),
            SizedBox(height: 20),
            buildText(userModel.email!, context),
            SizedBox(height: 20),
            buildText(userModel.dob!, context),
          ],
        ),
      ),
    );
  }

  buildText(String s, BuildContext context) {
    return Text(
      s,
      style: AppStyles.getMediumStyle(fontSize: 17, context: context),
    );
  }
}
