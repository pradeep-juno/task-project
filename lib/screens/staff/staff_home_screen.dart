import 'package:flutter/material.dart';
import 'package:jk_event_management/utils/functions.dart';
import 'package:jk_event_management/utils/project_constants.dart';

class StaffHomeScreen extends StatefulWidget {
  const StaffHomeScreen({super.key});

  @override
  State<StaffHomeScreen> createState() => _StaffHomeScreenState();
}

class _StaffHomeScreenState extends State<StaffHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildTextFun(context,
          title: ProjectConstants.staff,
          fontsize: 17,
          fontweight: FontWeight.bold,
          color: Colors.black),
    );
  }
}
