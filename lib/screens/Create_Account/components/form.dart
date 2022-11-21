import 'package:flutter/material.dart';
import 'package:google_mao/components/button_widget.dart';
import 'package:google_mao/components/inputs.dart';

class FormWidget extends StatelessWidget {
  FormWidget({super.key, required this.onSubmit});
  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();
  final TextEditingController _birthDay = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final Function onSubmit;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(children: [
      Row(mainAxisSize: MainAxisSize.max, children: [
        InputsWidget(
          width: size.width * 0.298,
          controller: _firstName,
          obscure: false,
          label: "First Name",
        ),
        InputsWidget(
          width: size.width * 0.298,
          controller: _lastName,
          obscure: false,
          label: "Last Name",
        ),
      ]),
      const SizedBox(
        height: 10,
      ),
      InputsWidget(
        width: size.width,
        controller: _birthDay,
        obscure: false,
        label: "Birthday",
      ),
      const SizedBox(
        height: 10,
      ),
      InputsWidget(
        width: size.width,
        controller: _email,
        obscure: false,
        label: "Email",
      ),
      const SizedBox(
        height: 10,
      ),
      InputsWidget(
        width: size.width,
        controller: _password,
        obscure: true,
        label: "Password",
      ),
      const SizedBox(
        height: 10,
      ),
      ButtonWidget(
          width: 70,
          text: "Create Account",
          pressed: () => onSubmit(_firstName.text, _lastName.text,
              _birthDay.text, _email.text, _password.text)),
    ]);
  }
}
