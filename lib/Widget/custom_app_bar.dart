// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:watchwiz/Screen/tablebasic.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.black,
      actions: [
        Image.asset('assets/images/Logo.png'),
        Text('WatchWiz',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18)),
        const SizedBox(width: 140),
        IconButton(
          color: Colors.white,
          icon: Icon(Icons.calendar_today),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TableBasicsExample()),
            );
          },
        ),
        IconButton(
          color: Colors.white,
          icon: Icon(Icons.notifications),
          onPressed: () {},
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
