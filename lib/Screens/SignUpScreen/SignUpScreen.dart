import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tuition_manage/Common/RoundedButton.dart';
import 'package:tuition_manage/Screens/HomeScreen/HomeScreen.dart';
import 'package:tuition_manage/Screens/LoginScreen/LoginScreen.dart';
import 'package:tuition_manage/Screens/MainScreen/MainScreen.dart';
import 'package:tuition_manage/Theme/Theme.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final formSignInKey = GlobalKey<FormState>();
  bool remeberdPassword = true;
  BuildContext? dialogContext;

  Future addUserDetails(
      String name, String email, UserCredential? userCredential) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential?.user?.uid)
          .set({
        'name': name,
        'email': email,
        'timestamp': FieldValue.serverTimestamp(),
        'img': ""
      });
    } catch (e) {
      print('Adding user data error: $e');
    }
  }

  signUp(String name, String email, String password,
      String confirmPassword) async {
    if (password != confirmPassword) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.rightSlide,
        title: "The password and confirm password do not match.",
        btnOkColor: MyTheme.buttonColor,
        btnOkOnPress: () {},
      )..show();
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        dialogContext = context;
        return const AlertDialog(
          backgroundColor: Colors.transparent,
          content: SpinKitCircle(color: Colors.white, size: 50.0),
        );
      },
    );

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      await addUserDetails(name, email, userCredential);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MainScreen()),
      );
    } on FirebaseAuthException catch (ex) {
      Navigator.pop(dialogContext!);
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.rightSlide,
        title: ex.message.toString(),
        btnOkColor: MyTheme.buttonColor,
        btnOkOnPress: () {},
      )..show();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFF3F3F5),
        body: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Expanded(
                  flex: 1,
                  child: SizedBox(
                    height: 10,
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: Container(
                    padding: const EdgeInsets.all(25),
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFFFFF),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Form(
                        key: formSignInKey,
                        child: Column(
                          children: [
                            const Text(
                              "Welcome Back",
                              style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF575757)),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              controller: nameController,
                              decoration: InputDecoration(
                                  label: const Text("Name"),
                                  hintText: "Enter Name",
                                  hintStyle:
                                      const TextStyle(color: Colors.black26),
                                  border: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.black12),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Colors.black12,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  suffixIcon: Icon(Icons.person)),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              controller: emailController,
                              decoration: InputDecoration(
                                  label: const Text("Email"),
                                  hintText: "Enter Email",
                                  hintStyle:
                                      const TextStyle(color: Colors.black26),
                                  border: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.black12),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Colors.black12,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  suffixIcon: Icon(Icons.email)),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              controller: passwordController,
                              obscureText: true,
                              obscuringCharacter: "*",
                              decoration: InputDecoration(
                                  label: const Text("Password"),
                                  hintText: "Enter Password",
                                  hintStyle:
                                      const TextStyle(color: Colors.black26),
                                  border: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.black12),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: Colors.black12,
                                      ),
                                      borderRadius: BorderRadius.circular(10)),
                                  suffixIcon: Icon(Icons.remove_red_eye)),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              controller: confirmPasswordController,
                              obscureText: true,
                              obscuringCharacter: "*",
                              decoration: InputDecoration(
                                  label: const Text("Confirm Password"),
                                  hintText: "Enter confirm Password",
                                  hintStyle:
                                      const TextStyle(color: Colors.black26),
                                  border: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.black12),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: Colors.black12,
                                      ),
                                      borderRadius: BorderRadius.circular(10)),
                                  suffixIcon: Icon(Icons.remove_red_eye)),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            RoundedButton(
                              title: "Sign Up",
                              onTap: () {
                                if (nameController.text.trim().isEmpty ||
                                    emailController.text.trim().isEmpty ||
                                    passwordController.text.trim().isEmpty) {
                                  AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.info,
                                    animType: AnimType.rightSlide,
                                    title: 'Enter Required Fields',
                                    btnOkColor: MyTheme.buttonColor,
                                    btnOkOnPress: () {},
                                  ).show();
                                } else {
                                  signUp(
                                    nameController.text.trim(),
                                    emailController.text.trim(),
                                    passwordController.text.trim(),
                                    confirmPasswordController.text.trim(),
                                  );
                                }
                              },
                              width: double.infinity,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Already have an account? ",
                                  style: TextStyle(
                                    color: Colors.black45,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginScreen(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    "Sign in",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
