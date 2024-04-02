import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tuition_manage/Screens/HomeScreen/HomeScreen.dart';
import 'package:tuition_manage/Screens/LoginScreen/LoginScreen.dart';
import 'package:tuition_manage/Screens/MainScreen/MainScreen.dart';

class CheckUser extends StatefulWidget {
  const CheckUser({super.key});

  @override
  State<CheckUser> createState() => _CheckUserState();
}

class _CheckUserState extends State<CheckUser> {
  @override
  Widget build(BuildContext context) {
    return checkUser();
  }
}

checkUser() {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    return MainScreen();
  } else {
    return LoginScreen();
  }
}
