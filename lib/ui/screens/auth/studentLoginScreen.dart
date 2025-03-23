import 'package:flutter/material.dart';

class StudentLoginScreen extends StatefulWidget {
  const StudentLoginScreen({super.key});

  @override
  State<StudentLoginScreen> createState() => _StudentLoginScreenState();

  static Widget routeInstance() {
    return StudentLoginScreen();
  }
}

class _StudentLoginScreenState extends State<StudentLoginScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}