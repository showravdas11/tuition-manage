import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tuition_manage/Screens/CardDetails/CardDetails.dart';
import 'package:tuition_manage/Screens/EditTuition/EditTuition.dart';
import 'package:tuition_manage/Theme/Theme.dart';

class TuitionCard extends StatefulWidget {
  const TuitionCard({
    Key? key,
    required this.tuition,
    required this.documentId,
  }) : super(key: key);

  final Map<String, dynamic> tuition;
  final String documentId;

  @override
  State<TuitionCard> createState() => _TuitionCardState();
}

class _TuitionCardState extends State<TuitionCard> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _deleteTuition() {
    _firestore.collection('tuition').doc(widget.documentId).delete();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final cardWidth = screenWidth * 0.9;
    final cardHeight = screenHeight * 0.25;

    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Container(
        width: cardWidth,
        height: cardHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          // color: Color(0xFF1E1E1E),
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 84, 84, 84), Color(0xFF1E1E1E)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildTextWithIcon(
                    icon: Iconsax.user,
                    text: "Student Name: ${widget.tuition["studentName"]}",
                    screenWidth: screenWidth,
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  buildTextWithIcon(
                    icon: Iconsax.location,
                    text: "Location: ${widget.tuition["location"]}",
                    screenWidth: screenWidth,
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  buildTextWithIcon(
                    icon: Iconsax.mobile,
                    text: "Phone: ${widget.tuition["phone"]}",
                    screenWidth: screenWidth,
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  buildTextWithIcon(
                    icon: Iconsax.clock,
                    text:
                        "Start Date: ${widget.tuition["selectMonth"]} ${widget.tuition["_selectedYear"]}",
                    screenWidth: screenWidth,
                  ),
                ],
              ),
            ),
            Flexible(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildActionIcon(
                    icon: Icons.edit,
                    color: Colors.green,
                    tooltip: 'Edit',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditTuitionScreen(
                            tuition: widget.tuition,
                            tuitionId: widget.documentId,
                          ),
                        ),
                      );
                    },
                  ),
                  buildActionIcon(
                    icon: Icons.delete,
                    color: Colors.red,
                    tooltip: 'Delete',
                    onPressed: () {
                      _showDeleteConfirmationDialog(context);
                    },
                  ),
                  buildActionIcon(
                    icon: Icons.info,
                    color: Colors.blueAccent,
                    tooltip: 'Details',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CardDetailsScreen(
                            tuition: widget.tuition,
                            tuitionId: widget.documentId,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextWithIcon({
    required IconData icon,
    required String text,
    required double screenWidth,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 24,
          color: Colors.white,
        ),
        SizedBox(width: screenWidth * 0.03),
        Flexible(
          child: Text(
            text,
            style: TextStyle(
              fontSize: screenWidth * 0.045,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget buildActionIcon({
    required IconData icon,
    required Color color,
    required String tooltip,
    required VoidCallback onPressed,
  }) {
    return Tooltip(
      message: tooltip,
      child: CircleAvatar(
        backgroundColor: Colors.white,
        child: IconButton(
          icon: Icon(icon, color: color),
          onPressed: onPressed,
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Are you sure?"),
          content: Text("This action cannot be undone."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                _deleteTuition();
                Navigator.of(context).pop();
              },
              child: Text("Yes"),
            ),
          ],
        );
      },
    );
  }
}
