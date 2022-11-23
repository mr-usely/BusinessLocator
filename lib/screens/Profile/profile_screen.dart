import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mao/screens/Profile/components/body.dart';
import 'package:google_mao/utils/constants.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Body(),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
            icon: Icon(
              CupertinoIcons.arrow_left,
              color: primaryColor,
            ),
            onPressed: () => Navigator.pop(context)));
  }
}
