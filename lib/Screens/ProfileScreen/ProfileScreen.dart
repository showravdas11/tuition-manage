import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:tuition_manage/Screens/EditProfile/EditProfile.dart';
import 'package:tuition_manage/Theme/Theme.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Stream<QuerySnapshot> _usersStream;
  final auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    User? user = auth.currentUser;
    if (user != null) {
      _usersStream = FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: user.email)
          .snapshots();
    } else {
      _usersStream = Stream.empty();
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Color(0xFFF3F3F5)));
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await auth.signOut();
              // Redirect to login screen or handle the logout state
            },
            icon: const Icon(Icons.sunny),
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 6,
                child: StreamBuilder<QuerySnapshot>(
                  stream: _usersStream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (snapshot.hasData &&
                        snapshot.data!.docs.isNotEmpty) {
                      var userData = snapshot.data!.docs.first.data()
                          as Map<String, dynamic>;
                      return Column(
                        children: [
                          Container(
                            height: 130,
                            width: 130,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(userData["img"]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            userData['name'] ?? 'No Name',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Color.fromARGB(255, 65, 65, 65),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            userData['email'] ?? 'No Email',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF575757),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => UpdateProfileScreen(
                                          userData: userData),
                                    ));
                              },
                              child: Text(
                                "Edit Profile",
                                style: TextStyle(color: Colors.black),
                              ))
                        ],
                      );
                    } else {
                      return Text('No user data found');
                    }
                  },
                ),
              ),
              Expanded(
                flex: 8,
                child: Container(
                  padding: const EdgeInsets.all(25),
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  child: Column(
                    children: [
                      _profileInfoTile("Language", Icons.language, "English"),
                      SizedBox(
                        height: 10,
                      ),
                      _profileInfoTile(
                          "Invite a Friend", Icons.share, "Invite"),
                      SizedBox(
                        height: 10,
                      ),
                      _profileInfoTile("Logout", Icons.logout, "Logout"),
                      SizedBox(
                        height: 10,
                      ),
                      _profileInfoTile("About App", Icons.details, ">"),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Widget _profileInfoTile(String title, IconData icon, String ClickText) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Row(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Color(0xFFF3F3F5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon),
          ),
          SizedBox(
            width: 15,
          ),
          Text(
            title,
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
          ),
        ],
      ),
      TextButton(
          onPressed: () {},
          child: Text(
            ClickText,
            style: TextStyle(
                color: Colors.black, fontSize: 17, fontWeight: FontWeight.w700),
          ))
    ],
  );
}
