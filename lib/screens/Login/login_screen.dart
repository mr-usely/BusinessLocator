import 'package:flutter/material.dart';
import 'package:google_mao/screens/Login/components/body.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Body(),
      ),
    );
  }
}
