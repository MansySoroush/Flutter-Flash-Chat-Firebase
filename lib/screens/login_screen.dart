import 'package:flutter/material.dart';
import 'package:flash_chat/components/rounded_button.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_screen.dart';
import 'package:flash_chat/components/spinner_widget.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;

  final TextEditingController _emailFieldController = TextEditingController();
  final TextEditingController _passwordFieldController =
      TextEditingController();

  final FocusNode _emailTextFieldFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _emailFieldController.clear();
    _passwordFieldController.clear();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setFocusToEmailTextField();
    });
  }

  @override
  void dispose() {
    _emailFieldController.dispose();
    _passwordFieldController.dispose();
    _emailTextFieldFocusNode.dispose();

    super.dispose();
  }

  void _setFocusToEmailTextField() {
    FocusScope.of(context).requestFocus(_emailTextFieldFocusNode);
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
              focusNode: _emailTextFieldFocusNode,
              controller: _emailFieldController,
              keyboardType: TextInputType.emailAddress,
              textAlign: TextAlign.center,
              onChanged: (value) {
                _emailFieldController.text = value;
              },
              decoration:
                  kTextFieldDecoration.copyWith(hintText: 'Enter your email'),
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
                  hintText: 'Enter your password'),
            ),
            const SizedBox(
              height: 24.0,
            ),
            RoundedButton(
              title: 'Log In',
              colour: Colors.lightBlueAccent,
              onPressed: () async {
                if ((_emailFieldController.text != "") &&
                    (_passwordFieldController.text != "")) {
                  try {
                    setState(() {
                      showSpinner = true;
                    });
                    await _auth.signInWithEmailAndPassword(
                        email: _emailFieldController.text,
                        password: _passwordFieldController.text);

                    if (context.mounted) {
                      setState(() {
                        showSpinner = false;
                        _emailFieldController.clear();
                        _passwordFieldController.clear();
                        _setFocusToEmailTextField();
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
