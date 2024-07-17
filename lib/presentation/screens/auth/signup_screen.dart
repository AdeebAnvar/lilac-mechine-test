import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lilac_test/constatnts/date_utils.dart';
import 'package:lilac_test/constatnts/styles.dart';
import 'package:lilac_test/data/local/provider/auth_provider.dart';
import 'package:lilac_test/data/models/user_model.dart';
import 'package:lilac_test/presentation/screens/auth/login.dart';
import 'package:lilac_test/widgets/custom_textfield.dart';

File? image;

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController phoneNumberController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController dobController = TextEditingController();
    AuthProvider authProvider = AuthProvider();
    final ImagePicker picker = ImagePicker();
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: ListView(
        padding: const EdgeInsets.all(18.0),
        children: [
          SizedBox(
            height: MediaQuery.sizeOf(context).height / 8,
          ),
          Align(
            child: Text(
              'SIGN UP',
              style: AppStyles.getSemioBoldStyle(fontSize: 20, context: context),
            ),
          ),
          const SizedBox(height: 60),
          Container(
            height: 100,
            margin: const EdgeInsets.symmetric(horizontal: 120),
            child: Stack(
              children: [
                Align(
                  child: CircleAvatar(
                    backgroundImage: image != null ? FileImage(image!) : null,
                    radius: 50,
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: InkWell(
                    onTap: () => showPickOptions(context, picker),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10.0, bottom: 5),
                      child: Icon(
                        Icons.camera_alt,
                        color: Colors.green.shade500,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 20),
          Form(
            key: formKey,
            child: Column(
              children: [
                CustomTextField(
                  hint: 'Name',
                  keyboardType: TextInputType.name,
                  controller: nameController,
                  validator: (v) {
                    if (v!.length <= 3) {
                      return 'Enter a valid name';
                    }
                  },
                ),
                const SizedBox(height: 15),
                CustomTextField(
                  validator: (v) {
                    if (v!.length <= 6 || v.length >= 12) {
                      return 'Enter a valid number';
                    }
                  },
                  hint: 'Phone number',
                  keyboardType: TextInputType.phone,
                  controller: phoneNumberController,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
                const SizedBox(height: 15),
                CustomTextField(
                  validator: (v) {
                    if (v!.length <= 10) {
                      return 'Enter a valid mail';
                    }
                  },
                  hint: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                ),
                const SizedBox(height: 15),
                CustomTextField(
                  hint: 'DOB',
                  controller: dobController,
                  onTap: () async {
                    DateTime pickedDate;
                    pickedDate = await onClickDatePicker(context);
                    dobController.text = pickedDate.toDocumentDateFormat();
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          TextButton(
            onPressed: () {
              if (!formKey.currentState!.validate()) {
                return;
              }
              if (image == null || dobController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.green.shade700,
                    content: Text(
                      'Some fields are missing',
                      style: AppStyles.getMediumStyle(fontSize: 14, context: context, fontColor: Colors.white),
                    ),
                  ),
                );
                return;
              }
              UserModel userModel = UserModel()
                ..name = nameController.text
                ..phone = phoneNumberController.text
                ..email = emailController.text
                ..dob = dobController.text
                ..image = image;
              authProvider.saveToLocal(userModel).whenComplete(() {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.green.shade700,
                    content: Text(
                      'User Signed Up',
                      style: AppStyles.getMediumStyle(fontSize: 14, context: context, fontColor: Colors.white),
                    ),
                  ),
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (c) => const LoginScreen(),
                  ),
                );
              });
            },
            style: AppStyles.filledButton.copyWith(
              fixedSize: WidgetStateProperty.all(
                Size(MediaQuery.sizeOf(context).width, 60),
              ),
            ),
            child: const Text('Signup'),
          ),
          TextButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (c) => LoginScreen())),
            child: Text(
              'Already have an account? Log in!.',
              style: AppStyles.getMediumStyle(
                fontSize: 12,
                context: context,
                fontColor: Colors.green.shade500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<DateTime> onClickDatePicker(BuildContext context) async {
    DateTime? pickedDate;
    pickedDate = await showDatePicker(context: context, firstDate: DateTime(1900), lastDate: DateTime(2050));
    return pickedDate ?? DateTime.now();
  }

  showPickOptions(BuildContext context, ImagePicker picker) {
    showModalBottomSheet(
      context: context,
      builder: (c) {
        return Material(
          child: Container(
            height: 170,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              color: Colors.white,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ListTile(
                  onTap: () {
                    pickImage(ImageSource.camera, picker, context);
                  },
                  title: const Text('Camera'),
                ),
                const Divider(),
                ListTile(
                  onTap: () async {
                    await pickImage(ImageSource.gallery, picker, context);
                  },
                  title: const Text('Gallery'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  pickImage(ImageSource source, ImagePicker picker, BuildContext context) async {
    final XFile? img = await picker.pickImage(source: source);
    if (img != null) {
      image = File(img!.path);
    }
    setState(() {});
    Navigator.pop(context);
  }
}
