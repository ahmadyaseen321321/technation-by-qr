
 import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class squrebutton extends StatelessWidget {

  final String title;
  final VoidCallback onpress;
  final Color color;

  squrebutton({super.key, required this.title, required this.onpress, this.color = Colors.grey});

  @override
   Widget build(BuildContext context) {
     return ElevatedButton(onPressed: onpress, style: ElevatedButton.styleFrom(backgroundColor: color), child: Text(title));
   }
 }
