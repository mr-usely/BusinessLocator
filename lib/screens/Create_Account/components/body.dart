import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mao/components/custom_card.dart';
import 'package:google_mao/function/function.dart';
import 'package:google_mao/models/User.dart';
import 'package:google_mao/screens/Create_Account/components/form.dart';
import 'package:google_mao/screens/Home/home_screen.dart';
import 'package:google_mao/utils/constants.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool isLoading = false;
  void submit(firstName, lastName, birthDay, email, password) async {
    isLoading = true;
    if (firstName.isNotEmpty &&
        lastName.isNotEmpty &&
        birthDay.isNotEmpty &&
        email.isNotEmpty &&
        password.isNotEmpty) {
      var request = await Fun.isCreateAccount(
          firstName, lastName, birthDay, email, password);

      if (request == "existing") {
        isLoading = false;
        Fun.openDialog(context, CupertinoIcons.exclamationmark_circle_fill,
            "Account Already Exist", Colors.red.shade500);
      } else {
        firstName = "";
        lastName = "";
        birthDay = "";
        email = "";
        password = "";

        isLoading = false;

        Fun.loggedUser = User(
            id: request.id,
            firstName: request.firstName,
            lastName: request.lastName,
            birthDay: request.birthDay,
            email: request.email);

        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: ((context) => const HomeScreen())));
      }
    } else {
      isLoading = false;
      Fun.openDialog(context, CupertinoIcons.check_mark,
          "Kindly fill all input fields", primaryColor);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: isLoading
          ? Center(
              child: Container(
                  margin: EdgeInsets.all(13),
                  padding: EdgeInsets.all(13),
                  decoration: BoxDecoration(
                      color: Color(0xFFE8E9EB),
                      borderRadius: BorderRadius.circular(15)),
                  child: CircularProgressIndicator(color: primaryColor)),
            )
          : CustomCard(
              height: 0.47,
              content: Column(children: [
                const Text('Create Account',
                    style:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
                const SizedBox(
                  height: 20,
                ),
                FormWidget(
                    onSubmit: (firstName, lastName, birthDay, email,
                            password) =>
                        submit(firstName, lastName, birthDay, email, password))
              ])),
    );
  }
}
