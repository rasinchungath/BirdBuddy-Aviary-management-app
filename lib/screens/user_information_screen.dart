import 'dart:io';
import 'package:bird_buddy_app/constants/constants.dart';
import 'package:bird_buddy_app/model/user_model.dart';
import 'package:bird_buddy_app/provider/auth_provider.dart';
import 'package:bird_buddy_app/screens/home_screen.dart';
import 'package:bird_buddy_app/utils/utils.dart';
import 'package:bird_buddy_app/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserInformationScreen extends StatefulWidget {
  const UserInformationScreen({super.key});

  @override
  State<UserInformationScreen> createState() => _UserInformationScreenState();
}

class _UserInformationScreenState extends State<UserInformationScreen> {
  File? image;
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final bioController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    bioController.dispose();
  }

  void selectedImage() async {
    image = await pickImage(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isLoading =
        Provider.of<AuthProvider>(context, listen: true).isLoading;

    return Scaffold(
      body: SafeArea(
        child: isLoading == true
            ? Center(
                child: CircularProgressIndicator(
                  color: buttonColor,
                ),
              )
            : SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(vertical: 25, horizontal: 5),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          selectedImage();
                        },
                        child: image == null
                            ? CircleAvatar(
                                backgroundColor: buttonColor,
                                radius: 50,
                                child: const Icon(
                                  Icons.account_circle,
                                  size: 50,
                                  color: Colors.white,
                                ),
                              )
                            : CircleAvatar(
                                backgroundImage: FileImage(image!),
                                radius: 50,
                              ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 15),
                        margin: const EdgeInsets.only(top: 20),
                        child: Column(
                          children: [
                            textfield(
                              hintText: 'John Smith',
                              maxLines: 1,
                              icon: Icons.account_circle,
                              inputType: TextInputType.name,
                              controller: nameController,
                            ),
                            textfield(
                              hintText: 'abc@example.com',
                              maxLines: 1,
                              icon: Icons.email,
                              inputType: TextInputType.emailAddress,
                              controller: emailController,
                            ),
                            textfield(
                              hintText: 'Enter your bio here',
                              maxLines: 2,
                              icon: Icons.edit,
                              inputType: TextInputType.name,
                              controller: bioController,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: CustomButton(
                                text: 'Continue',
                                onpressed: () {
                                  storeData();
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget textfield({
    required String hintText,
    required int maxLines,
    required IconData icon,
    required TextInputType inputType,
    required TextEditingController controller,
  }) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 20,
      ),
      child: TextFormField(
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
        cursorColor: buttonColor,
        controller: controller,
        keyboardType: inputType,
        maxLines: maxLines,
        decoration: InputDecoration(
          prefixIcon: Container(
            margin: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: buttonColor,
            ),
            child: Icon(
              icon,
              size: 20,
              color: Colors.white,
            ),
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none),
          hintText: hintText,
          alignLabelWithHint: true,
          border: InputBorder.none,
          fillColor: Colors.blue.shade50,
          filled: true,
        ),
      ),
    );
  }

  void storeData() async {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    UserModel userModel = UserModel(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      bio: bioController.text.trim(),
      profilePic: '',
      phoneNumber: '',
      createdAt: '',
      uid: '',
    );

    if (image != null) {
      ap.saveDataToFirebase(
        context: context,
        userModel: userModel,
        profilePic: image!,
        onSuccess: () {
          ap.saveUserDataToSP().then(
                (value) => ap.setSignIn().then(
                      (value) => Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomeScreen()),
                          (route) => false),
                    ),
              );
        },
      );
    } else {
      showSnackBar(context, 'Please upload a profile photo');
    }
  }
}
