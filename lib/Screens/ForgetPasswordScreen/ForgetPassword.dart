import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tuition_manage/Common/RoundedButton.dart';
import 'package:tuition_manage/Theme/Theme.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final emailController = TextEditingController();

  forgotPassword(String email) async {
    if (email == '') {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.info,
        animType: AnimType.rightSlide,
        title: 'Enter an email to reset password',
        btnOkColor: MyTheme.buttonColor,
        btnOkOnPress: () {},
      )..show();
    } else {
      FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.rightSlide,
        title: 'Email sent successFully',
        btnOkOnPress: () {},
      )..show();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Lottie.network(
                  "https://lottie.host/c2f90682-e881-44a2-8db3-3edb81ac2c4e/zmw5G9db1o.json",
                  height: 200),
              const SizedBox(
                height: 16,
              ),
              Text(
                "Forget Password?",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                "Don't worry sometimes people can forget too, enter your email we will send you password reset link",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color.fromARGB(255, 80, 78, 78)),
              ),
              const SizedBox(
                height: 32 * 2,
              ),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                    label: const Text("Email"),
                    hintText: "Enter Email",
                    hintStyle: const TextStyle(color: Colors.black26),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.black12),
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
                height: 32,
              ),
              Center(
                  child: RoundedButton(
                      title: "Reset Password",
                      onTap: () {
                        forgotPassword(emailController.text.toString());
                      },
                      width: 250))
            ],
          ),
        ),
      ),
    );
  }
}
