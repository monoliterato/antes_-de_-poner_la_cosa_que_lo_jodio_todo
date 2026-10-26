import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(width: 10, decoration: BoxDecoration(color: Colors.amber)),
        Container(width: 20, decoration: BoxDecoration(color: Colors.red)),
      ],
    );
  }
}
