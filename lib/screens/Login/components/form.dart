import 'package:flutter/material.dart';
import 'package:google_mao/components/button_widget.dart';
import 'package:google_mao/components/inputs.dart';

class FormWidget extends StatelessWidget {
  FormWidget({super.key, required this.onSubmit});
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final Function onSubmit;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(children: [
      InputsWidget(
        width: size.width,
        controller: _email,
        obscure: false,
        label: "Email",
      ),
      SizedBox(
        height: 10,
      ),
      InputsWidget(
        width: size.width,
        controller: _password,
        obscure: true,
        label: "Password",
      ),
      SizedBox(
        height: 10,
      ),
      ButtonWidget(
          width: 90,
          text: "Login",
          pressed: () => onSubmit(_email.text, _password.text)),
    ]);
  }
}
