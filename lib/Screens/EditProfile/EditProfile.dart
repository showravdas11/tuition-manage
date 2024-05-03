import 'dart:async';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tuition_manage/Common/RoundedButton.dart';
import 'package:tuition_manage/Theme/Theme.dart';

class UpdateProfileScreen extends StatefulWidget {
  final Map<String, dynamic> userData;
  const UpdateProfileScreen({Key? key, required this.userData})
      : super(key: key);

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  File? _selectedImage;
  BuildContext? dialogContext;
  String? selectGender;
  final auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();

    nameController.text = widget.userData['name'] ?? 'N/A';
    addressController.text = widget.userData['address'] ?? 'N/A';
    ageController.text = widget.userData['age']?.toString() ?? 'N/A';
    setState(() {
      selectGender = widget.userData['gender'] ?? 'N/A';
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  //-----------------update user profile function--------------------//
  Future<void> _updateUserData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Upload image to Firebase Storage
        String imagePath = 'profile_images/${user.uid}_profile.jpg';
        Reference storageReference =
            FirebaseStorage.instance.ref().child(imagePath);
        String imageUrl = widget.userData['img'];
        if (_selectedImage != null) {
          await storageReference.putFile(_selectedImage!);
          imageUrl = await storageReference.getDownloadURL();
        }

        // Update user data in Firebase Realtime Database
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({
          'name': nameController.text,
          'gender': selectGender,
          'address': addressController.text,
          'age': ageController.text,
          'img': imageUrl,
        });

        Navigator.pop(dialogContext!);
        AwesomeDialog(
          context: context,
          dialogType: DialogType.success,
          animType: AnimType.rightSlide,
          title: 'Data Updated Successfully',
          btnOkColor: MyTheme.buttonColor,
          btnOkOnPress: () {
            Navigator.pop(context);
          },
        ).show();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not logged in')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating user data: $error')),
      );
    }
  }

  //------------------image select form gallery----------------------//

  Future<void> _picImageFormGallery() async {
    final picker = ImagePicker();
    final pickedImage = await showDialog<File?>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Image'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: const Row(
                    children: [
                      Icon(
                        Iconsax.gallery_add,
                        size: 30,
                        color: Color.fromARGB(255, 142, 36, 171),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Gallery",
                        style: TextStyle(fontSize: 20),
                      )
                    ],
                  ),
                  onTap: () async {
                    final pickedFile = await picker.pickImage(
                      source: ImageSource.gallery,
                    );
                    Navigator.of(context).pop(File(pickedFile!.path));
                  },
                ),
                const Padding(padding: EdgeInsets.all(8.0)),
                GestureDetector(
                  child: const Row(
                    children: [
                      Icon(
                        Icons.camera,
                        size: 30,
                        color: Color.fromARGB(255, 48, 96, 78),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Camera",
                        style: TextStyle(fontSize: 20),
                      )
                    ],
                  ),
                  onTap: () async {
                    final pickedFile = await picker.pickImage(
                      source: ImageSource.camera,
                    );
                    Navigator.of(context).pop(File(pickedFile!.path));
                  },
                ),
              ],
            ),
          ),
        );
      },
    );

    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 220,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [MyTheme.canvousColor, MyTheme.buttonColor],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      alignment: Alignment.center,
                    ),
                  ),
                  Positioned(
                    top: 30,
                    left: 10,
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "Edit Profile".tr,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 0,
                    right: 0,
                    child: Container(
                      alignment: Alignment.center,
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(60),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 10,
                                  spreadRadius: 3,
                                ),
                              ],
                            ),
                            child: _selectedImage != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(60),
                                    child: Image.file(
                                      _selectedImage!,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(60),
                                    child: widget.userData["img"] != ""
                                        ? Image.network(
                                            widget.userData["img"]!,
                                            fit: BoxFit.cover,
                                          )
                                        : Image.asset(
                                            "assets/images/user.png",
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 0, right: 0),
                            child: GestureDetector(
                              onTap: _picImageFormGallery,
                              child: const CircleAvatar(
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.camera_alt_outlined,
                                  size: 25,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(top: 5, left: 20, right: 20),
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Column(
                    children: [
                      // CommonTextField(
                      //   controller: nameController,
                      //   text: "Name",
                      //   textInputType: TextInputType.text,
                      //   obscure: false,
                      //   suffixIcon: const Icon(
                      //     Iconsax.user,
                      //     color: Color(0xFF7E59FD),
                      //   ),
                      // ),

                      TextFormField(
                        controller: nameController,
                        obscuringCharacter: "*",
                        decoration: InputDecoration(
                          label: const Text("Name"),
                          hintStyle: const TextStyle(color: Colors.black26),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.black12,
                              ),
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                      const SizedBox(
                        height: 6,
                      ),

                      // CommonTextField(
                      //   controller: addressController,
                      //   text: "Address",
                      //   textInputType: TextInputType.text,
                      //   obscure: false,
                      //   suffixIcon: const Icon(Iconsax.location,
                      //       color: Color(0xFF7E59FD)),
                      // ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  RoundedButton(
                    title: "Update".tr,
                    onTap: () {
                      if (nameController.text.trim().isEmpty ||
                          addressController.text.trim().isEmpty ||
                          ageController.text.trim().isEmpty ||
                          selectGender == null) {
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.info,
                          animType: AnimType.rightSlide,
                          title: 'Enter Required Fields',
                          btnOkColor: MyTheme.buttonColor,
                          btnOkOnPress: () {},
                        ).show();
                      } else {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            dialogContext = context;
                            return const AlertDialog(
                              backgroundColor: Colors.transparent,
                              content: SpinKitCircle(
                                  color: Colors.white, size: 50.0),
                            );
                          },
                        );

                        _updateUserData();
                      }
                    },
                    width: 200,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
