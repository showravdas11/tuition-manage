import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Function()? leadingOnPressed;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.leadingOnPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return AppBar(
      centerTitle: true,
      title: Text(
        title,
        style: TextStyle(
          fontSize:
              screenWidth * 0.05, // Adjust font size based on screen width
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF7E59FD),
              Color(0xFF5B37B7),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      ),
      leading: leadingOnPressed != null
          ? IconButton(
              onPressed: leadingOnPressed,
              icon: const Icon(
                Iconsax.arrow_left,
                color: Colors.white,
              ),
            )
          : null,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
