import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tuition_manage/Common/RoundedButton.dart';
import 'package:tuition_manage/Theme/Theme.dart';

class EditTuitionScreen extends StatefulWidget {
  final Map<String, dynamic> tuition;
  final String tuitionId;
  const EditTuitionScreen(
      {super.key, required this.tuition, required this.tuitionId});

  @override
  State<EditTuitionScreen> createState() => _EditTuitionScreenState();
}

class _EditTuitionScreenState extends State<EditTuitionScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController yearController = TextEditingController();
  TextEditingController monthController = TextEditingController();
  BuildContext? dialogContext;

  String showYear = 'Select Year';
  DateTime _selectedYear = DateTime.now();

  @override
  void initState() {
    super.initState();

    nameController.text = widget.tuition['studentName'] ?? 'N/A';
    locationController.text = widget.tuition['location'] ?? 'N/A';
    phoneController.text = widget.tuition['phone']?.toString() ?? 'N/A';
    yearController.text = widget.tuition['_selectedYear']?.toString() ?? 'N/A';
    monthController.text = widget.tuition['selectMonth'] ?? '';
  }

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
                  yearController.text =
                      yearController.text = dateTime.year.toString();
                  ;
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

  void updateTuitionData() async {
    if (nameController.text.trim().isEmpty ||
        locationController.text.trim().isEmpty ||
        phoneController.text.trim().isEmpty ||
        yearController.text.trim().isEmpty ||
        monthController.text.trim().isEmpty) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.info,
        animType: AnimType.rightSlide,
        title: 'Enter Required Fields',
        btnOkColor: MyTheme.buttonColor,
        btnOkOnPress: () {},
      ).show();
      return;
    }

    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      DocumentReference lectureRef =
          firestore.collection('tuition').doc(widget.tuitionId);

      await lectureRef.update({
        'studentName': nameController.text,
        'location': locationController.text,
        'phone': phoneController.text,
        'selectMonth': monthController.text,
        '_selectedYear': yearController.text,
      });

      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.rightSlide,
        title: 'Lecture Updated Successfully',
        btnOkColor: MyTheme.buttonColor,
        btnOkOnPress: () {
          Navigator.pop(context);
        },
      ).show();
    } catch (error) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.rightSlide,
        title: 'Failed to Update Lecture',
        desc: 'An error occurred while updating the lecture: $error',
        btnOkColor: MyTheme.buttonColor,
        btnOkOnPress: () {},
      ).show();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Tuition"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
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
              TextFormField(
                controller: locationController,
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
              TextFormField(
                controller: phoneController,
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
              TextFormField(
                controller: yearController,
                obscuringCharacter: "*",
                decoration: InputDecoration(
                    label: const Text("Year"),
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
                    suffixIcon: IconButton(
                        onPressed: () {
                          selectYear(context);
                        },
                        icon: Icon(Icons.calendar_month))),
              ),
              const SizedBox(
                height: 6,
              ),
              Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButtonFormField<String>(
                  value: monthController.text,
                  onChanged: (String? newValue) {
                    setState(() {
                      monthController.text = newValue.toString();
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
              const SizedBox(
                height: 20,
              ),
              RoundedButton(
                  title: "Update Tuition",
                  onTap: () {
                    updateTuitionData();
                  },
                  width: double.infinity)
            ],
          ),
        ),
      ),
    );
  }
}
