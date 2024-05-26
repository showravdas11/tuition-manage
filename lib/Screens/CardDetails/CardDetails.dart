import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CardDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> tuition;
  final String tuitionId;

  const CardDetailsScreen({
    Key? key,
    required this.tuition,
    required this.tuitionId,
  }) : super(key: key);

  @override
  State<CardDetailsScreen> createState() => _CardDetailsScreenState();
}

class _CardDetailsScreenState extends State<CardDetailsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  List<String> monthYearList = [];
  DateTime today = DateTime.now();
  Set<DateTime> selectedDates = Set<DateTime>();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final DateFormat _dateFormat = DateFormat('MMMM yyyy');
  final DateFormat _dayMonthYearFormat = DateFormat('d MMMM yyyy');

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      if (selectedDates.contains(day)) {
        selectedDates.remove(day);
        _removeDateFromFirestore(day);
      } else {
        selectedDates.add(day);
        _addDateToFirestore(day);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation =
        CurvedAnimation(parent: _animationController, curve: Curves.easeIn);
    _animationController.forward();

    generateMonthYearList();
  }

  void generateMonthYearList() {
    String startMonthYear =
        '${widget.tuition["selectMonth"]} ${widget.tuition["_selectedYear"]}';
    String currentMonthYear = _dateFormat.format(DateTime.now());

    DateTime startDate = _dateFormat.parse(startMonthYear);
    DateTime currentDate = _dateFormat.parse(currentMonthYear);
    while (startDate.isBefore(currentDate) ||
        startDate.isAtSameMomentAs(currentDate)) {
      monthYearList.add(_dateFormat.format(startDate));
      startDate = DateTime(startDate.year, startDate.month + 1);
    }
  }

  void showCalendar(String monthYear) {
    DateTime focusedDay = _dateFormat.parse(monthYear);
    DateTime firstDay = DateTime(focusedDay.year, focusedDay.month, 1);
    DateTime lastDay = DateTime(focusedDay.year, focusedDay.month + 1, 0);

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              height: 400,
              child: TableCalendar(
                focusedDay: focusedDay,
                firstDay: firstDay,
                lastDay: lastDay,
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    if (selectedDates.contains(selectedDay)) {
                      selectedDates.remove(selectedDay);
                      _removeDateFromFirestore(selectedDay);
                    } else {
                      selectedDates.add(selectedDay);
                      _addDateToFirestore(selectedDay);
                    }
                  });
                },
                calendarFormat: CalendarFormat.month,
                selectedDayPredicate: (day) => selectedDates.contains(day),
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                ),
                calendarStyle: const CalendarStyle(
                  isTodayHighlighted: true,
                  selectedDecoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  todayDecoration: BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // void _addDateToFirestore(DateTime date) {
  //   String formattedDate = _dayMonthYearFormat.format(date);
  //   _firestore
  //       .collection('tuition')
  //       .doc(widget.tuitionId)
  //       .collection('dates')
  //       .doc()
  //       .set({
  //     'date': formattedDate,
  //   });
  // }
  void _addDateToFirestore(DateTime date) {
    String formattedDate = _dayMonthYearFormat.format(date);
    _firestore
        .collection('tuition')
        .doc(widget.tuitionId)
        .collection('dates')
        .add({
      'date': formattedDate,
    });
  }

  // void _removeDateFromFirestore(DateTime date) {
  //   String formattedDate = _dayMonthYearFormat.format(date);
  //   _firestore
  //       .collection('tuition')
  //       .doc(widget.tuitionId)
  //       .collection('dates')
  //       .doc(formattedDate)
  //       .delete();
  // }

  void _removeDateFromFirestore(DateTime date) async {
    String formattedDate = _dayMonthYearFormat.format(date);
    QuerySnapshot querySnapshot = await _firestore
        .collection('tuition')
        .doc(widget.tuitionId)
        .collection('dates')
        .where('date', isEqualTo: formattedDate)
        .get();

    for (var doc in querySnapshot.docs) {
      await doc.reference.delete();
    }
  }

  void _fetchSelectedDate() async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('tuition')
        .doc(widget.tuitionId)
        .collection('dates')
        .get();

    setState(() {
      selectedDates = querySnapshot.docs.map((doc) {
        return _dayMonthYearFormat.parse(doc['date']);
      }).toSet();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Student Details"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: FadeTransition(
          opacity: _animation,
          child: Column(
            children: [
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF413F4A),
                        Color.fromARGB(255, 37, 37, 37)
                      ],
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailRow("Name:", widget.tuition["studentName"]),
                      const SizedBox(height: 10),
                      _buildDetailRow("Email:", widget.tuition["userEmail"]),
                      const SizedBox(height: 10),
                      _buildDetailRow("Location:", widget.tuition["location"]),
                      const SizedBox(height: 10),
                      _buildDetailRow("Phone:", widget.tuition["phone"]),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                height: 400,
                child: ListView.builder(
                  reverse: true,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: monthYearList.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Container(
                        width: double.infinity,
                        height: 60,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Color(0xFF0675C1), Color(0xFF014473)],
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                monthYearList[index],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              InkWell(
                                onTap: () => showCalendar(monthYearList[index]),
                                child: const Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.white,
                                  size: 27,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.arrow_right, color: Colors.white),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
