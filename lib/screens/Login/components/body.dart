import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mao/function/function.dart';
import 'package:google_mao/models/User.dart';
import 'package:google_mao/screens/Create_Account/create_account_screen.dart';
import 'package:google_mao/screens/Home/home_screen.dart';
import 'package:google_mao/components/custom_card.dart';
import 'package:google_mao/screens/Login/components/form.dart';
import 'package:google_mao/utils/constants.dart';
import 'package:location/location.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  void getCurrentLocation() {
    Location location = Location();
    location.getLocation().then((location) {
      setState(() {
        Fun.currentLoc = location;
      });
    });
  }

  submit(email, password) async {
    if (email.isNotEmpty && password.isNotEmpty) {
      var request = await Fun.isUserLogin(email, password);

      if (request != "existing") {
        Fun.loggedUser = User(
            id: request.id,
            firstName: request.firstName,
            lastName: request.lastName,
            birthDay: request.birthDay,
            email: request.email);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: ((context) => const HomeScreen())));
      } else {
        Fun.openDialog(context, CupertinoIcons.check_mark,
            "Incorrect Email or Password!", primaryColor);
      }
    } else {
      Fun.openDialog(context, CupertinoIcons.check_mark,
          "Email or Password is empty", primaryColor);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: CustomCard(
          height: 0.37,
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            Text('Login',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
            SizedBox(
              height: 20,
            ),
            FormWidget(onSubmit: (email, password) => submit(email, password)),
            SizedBox(
              height: 15,
            ),
            GestureDetector(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => CreateAccountScreen()))),
              child: Text(
                'Create Account',
                textAlign: TextAlign.center,
                style:
                    TextStyle(color: primaryColor, fontWeight: FontWeight.w700),
              ),
            )
          ])),
    );
  }
}
