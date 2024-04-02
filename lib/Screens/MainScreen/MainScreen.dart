import 'package:flutter/material.dart';
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
    HomeScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFFBE8B5),
        body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Dialog Title'),
                  content: Text('This is the content of the dialog'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Close'),
                    ),
                  ],
                );
              },
            );
          },
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
}
