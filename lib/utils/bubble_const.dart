import 'package:flutter/material.dart';

const kfriendBuble = BorderRadius.only(
  topLeft: Radius.circular(20),
  bottomLeft: Radius.circular(20),
  bottomRight: Radius.circular(20),
);
const kuserBuble = BorderRadius.only(
  topRight: Radius.circular(20),
  bottomLeft: Radius.circular(20),
  bottomRight: Radius.circular(20),
);
final ktextfield = InputDecoration(
  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
  filled: true,
  fillColor: Colors.white,
  hintText: 'Enter your message here...',
);
