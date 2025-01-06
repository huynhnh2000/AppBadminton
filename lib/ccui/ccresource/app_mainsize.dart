import 'package:flutter/material.dart';

class AppMainsize {
  static double mainWidth(BuildContext context)=>MediaQuery.of(context).size.width;
  static double mainHeight(BuildContext context)=>MediaQuery.of(context).size.height;
}