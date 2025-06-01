import 'package:flutter/material.dart';

class UserDataAccessScreen extends StatefulWidget {
  const UserDataAccessScreen({super.key});

  @override
  State<UserDataAccessScreen> createState() => _UserDataAccessScreenState();
}

class _UserDataAccessScreenState extends State<UserDataAccessScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Acesso a dados"),
      ),
    );
  }
}