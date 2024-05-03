import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tuition_manage/Common/CustomTextField.dart';
import 'package:tuition_manage/Screens/HomeScreen/HomeScreen.dart';
import 'package:tuition_manage/Screens/ProfileScreen/ProfileScreen.dart';
import 'package:tuition_manage/Theme/Theme.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  static final List<Widget> _widgetOptions = <Widget>[
    const HomeScreen(),
    const ProfileScreen(),
  ];

  TextEditingController _textFieldController = TextEditingController();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFFBE8B5),
        body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: _showCustomDialog,
          child: const Icon(Icons.add),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0),
          ),
          backgroundColor: Colors.black,
          foregroundColor: MyTheme.buttonColor,
          elevation: 0,
          // mini: true,
        ),
        bottomNavigationBar: BottomAppBar(
          notchMargin: 5.0,
          shape: const CircularNotchedRectangle(),
          color: MyTheme.buttonColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: GestureDetector(
                  onTap: () => _onItemTapped(0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.home,
                        color: _selectedIndex == 0
                            ? const Color.fromARGB(255, 0, 0, 0)
                            : Colors.white,
                      ),
                      Text(
                        "Home",
                        style: TextStyle(
                          color: _selectedIndex == 0
                              ? const Color.fromARGB(255, 0, 0, 0)
                              : Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: GestureDetector(
                  onTap: () => _onItemTapped(1),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.person,
                        color: _selectedIndex == 1
                            ? const Color.fromARGB(255, 0, 0, 0)
                            : Colors.white,
                      ),
                      Text(
                        "Profile",
                        style: TextStyle(
                          color: _selectedIndex == 1
                              ? const Color.fromARGB(255, 0, 0, 0)
                              : Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

//----------------------------Show Custom Dilouge-----------------------------//

  void _showCustomDialog() {
    TextEditingController studentController = TextEditingController();
    TextEditingController locationController = TextEditingController();
    TextEditingController phoneController = TextEditingController();
    String? selectMonth;
    String showYear = 'Select Year';
    DateTime _selectedYear = DateTime.now();

    void addTuition(String studentName, String location, String phone,
        String selectMonth, String _selectedYear, String userEmail) async {
      await FirebaseFirestore.instance.collection("tuition").add({
        "studentName": studentName,
        "location": location,
        "phone": phone,
        "ongoing": true,
        "selectMonth": selectMonth,
        "_selectedYear": _selectedYear,
        "userEmail": userEmail,
      });
    }

//---------Select Year Function-----------//

    selectYear(context) async {
      print("Call Calender");
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Select Year"),
            content: SizedBox(
              width: 300,
              height: 300,
              child: YearPicker(
                firstDate: DateTime(DateTime.now().year - 10, 1),
                lastDate: DateTime.now(),
                // lastDate: DateTime(2025),
                currentDate: DateTime.now(),
                selectedDate: _selectedYear,
                onChanged: (DateTime dateTime) {
                  print(dateTime.year);
                  setState(() {
                    _selectedYear = dateTime;
                    showYear = "${dateTime.year}";
                  });
                  Navigator.pop(context);
                },
              ),
            ),
          );
        },
      );
    }

    //---------------Show Dialog---------------------//

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: [
                  const BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10.0,
                    offset: Offset(0.0, 10.0),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Text(
                    'Add Tuition',
                    style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  CustomTextField(
                    labelText: "Student Name",
                    hintText: "Enter Student Name",
                    controller: studentController,
                    suffixIcon: const Icon(Iconsax.user),
                  ),
                  const SizedBox(height: 20.0),
                  CustomTextField(
                    labelText: "Location",
                    hintText: "Enter Location",
                    controller: locationController,
                    suffixIcon: const Icon(Iconsax.location),
                  ),
                  const SizedBox(height: 20.0),
                  CustomTextField(
                    labelText: "Phone",
                    hintText: "Enter Phone Number",
                    controller: phoneController,
                    suffixIcon: const Icon(Iconsax.mobile),
                  ),
                  const SizedBox(height: 20.0),

                  //------select year field-------------//
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 15),
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(showYear),
                            GestureDetector(
                              onTap: () {
                                selectYear(context);
                              },
                              child: const Icon(Icons.calendar_month),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      //-------------Select month field----------------//
                      Container(
                        height: 50,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: DropdownButtonFormField<String>(
                          value: selectMonth,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectMonth = newValue;
                            });
                          },
                          items: [
                            'January',
                            'February',
                            'March',
                            'April',
                            'May',
                            'June',
                            'July',
                            'August',
                            'September',
                            'October',
                            'November',
                            'December',
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            );
                          }).toList(),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Select Month",
                            hintStyle: TextStyle(),
                            alignLabelWithHint: true,
                            iconColor: Color(0xFF7E59FD),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 10.0),
                      ElevatedButton(
                        onPressed: () {
                          if (showYear != "Select Year") {
                            print("Select Year");
                          } else {
                            print("Did Not Select Year");
                          }
                          if (phoneController.text.trim().isEmpty ||
                              studentController.text.trim().isEmpty ||
                              locationController.text.trim().isEmpty ||
                              selectMonth == null ||
                              _selectedYear == "") {
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.info,
                              animType: AnimType.rightSlide,
                              title: 'Enter Required Fields',
                              btnOkColor: MyTheme.buttonColor,
                              btnOkOnPress: () {},
                            ).show();
                          } else {
                            addTuition(
                              studentController.text.trim(),
                              locationController.text.trim(),
                              phoneController.text.trim(),
                              selectMonth ?? "",
                              _selectedYear.year.toString(),
                              FirebaseAuth.instance.currentUser!.email!,
                            );

                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.success,
                              animType: AnimType.rightSlide,
                              title: 'Lecture Added Successfully',
                              btnOkColor: MyTheme.buttonColor,
                              btnOkOnPress: () {
                                Navigator.pop(context);
                              },
                            ).show();
                          }
                        },
                        child: const Text('Add'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
