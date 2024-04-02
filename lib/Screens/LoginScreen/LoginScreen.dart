import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tuition_manage/Common/RoundedButton.dart';
import 'package:tuition_manage/Screens/ForgetPasswordScreen/ForgetPassword.dart';
import 'package:tuition_manage/Screens/HomeScreen/HomeScreen.dart';
import 'package:tuition_manage/Screens/MainScreen/MainScreen.dart';
import 'package:tuition_manage/Screens/SignUpScreen/SignUpScreen.dart';
import 'package:tuition_manage/Theme/Theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formSignInKey = GlobalKey<FormState>();
  bool remeberdPassword = true;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      // Show error dialog for empty fields
      AwesomeDialog(
        context: context,
        dialogType: DialogType.info,
        animType: AnimType.rightSlide,
        title: 'Enter Required Fields',
        btnOkColor: MyTheme.buttonColor,
        btnOkOnPress: () {},
      ).show();
    } else {
      UserCredential? userCredential;

      try {
        userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password)
            .then((value) => Navigator.push(context,
                MaterialPageRoute(builder: (context) => MainScreen())));
        // User? user = userCredential.user;
      } on FirebaseAuthException catch (ex) {
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
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                "assets/images/bg1.jpg", // Adjust path to your image
                fit: BoxFit.cover,
              ),
            ),
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
                      color: Color(0xFFFBE8B5),
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
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Checkbox(
                                      value: remeberdPassword,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          remeberdPassword = value!;
                                        });
                                      },
                                      activeColor: Colors.black,
                                    ),
                                    const Text(
                                      "Remember me",
                                      style: TextStyle(
                                        color: Colors.black45,
                                      ),
                                    ),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ForgetPasswordScreen()));
                                  },
                                  child: const Text(
                                    "Forget Password?",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            RoundedButton(
                              title: "Login",
                              onTap: () {
                                login(
                                  emailController.text.trim(),
                                  passwordController.text.trim(),
                                );
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
                                  "Don\'t have an account ? ",
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
                                            const SignUpScreen(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    "Sign up",
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
