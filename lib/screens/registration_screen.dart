import 'package:flutter/material.dart';
import 'package:flash_chat/components/rounded_button.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_screen.dart';
import 'package:flash_chat/components/spinner_widget.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;

  final TextEditingController _emailFieldController = TextEditingController();
  final TextEditingController _passwordFieldController =
      TextEditingController();

  @override
  void initState() {
    super.initState();

    _emailFieldController.text = "";
    _passwordFieldController.text = "";
  }

  @override
  void dispose() {
    _emailFieldController.dispose();
    _passwordFieldController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Flexible(
              child: Hero(
                tag: 'logo',
                child: SizedBox(
                  height: 200.0,
                  child: Image.asset('images/logo.png'),
                ),
              ),
            ),
            const SizedBox(
              height: 48.0,
            ),
            TextField(
              controller: _emailFieldController,
              keyboardType: TextInputType.emailAddress,
              textAlign: TextAlign.center,
              onChanged: (value) {
                _emailFieldController.text = value;
              },
              decoration: kTextFieldDecoration.copyWith(
                hintText: 'Enter your email',
              ),
            ),
            const SizedBox(
              height: 8.0,
            ),
            TextField(
              controller: _passwordFieldController,
              obscureText: true,
              textAlign: TextAlign.center,
              onChanged: (value) {
                _passwordFieldController.text = value;
              },
              decoration: kTextFieldDecoration.copyWith(
                hintText: 'Enter your password',
              ),
            ),
            const SizedBox(
              height: 24.0,
            ),
            RoundedButton(
              title: 'Register',
              colour: Colors.blueAccent,
              onPressed: () async {
                if ((_emailFieldController.text != "") &&
                    (_passwordFieldController.text != "")) {
                  try {
                    setState(() {
                      showSpinner = true;
                    });

                    await _auth.createUserWithEmailAndPassword(
                        email: _emailFieldController.text,
                        password: _passwordFieldController.text);

                    if (context.mounted) {
                      setState(() {
                        showSpinner = false;
                        _emailFieldController.text = "";
                        _passwordFieldController.text = "";
                      });
                      Navigator.pushNamed(context, ChatScreen.id);
                    }
                  } catch (e) {
                    print(e);
                  }
                }
              },
            ),
            if (showSpinner) const SpinnerWidget(),
          ],
        ),
      ),
    );
  }
}
