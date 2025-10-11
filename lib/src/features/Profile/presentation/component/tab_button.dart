import 'package:flutter/material.dart';

Widget tabButton(String label, {required bool isActive, required VoidCallback onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? Color(0xFFFF675C) : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFFF675C)),
        boxShadow: isActive ? [const BoxShadow(color: Colors.black12, blurRadius: 4)] : [],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: TextStyle(color: isActive ? Colors.white : Colors.black, fontWeight: FontWeight.bold)),
        ],
      ),
    ),
  );
}
