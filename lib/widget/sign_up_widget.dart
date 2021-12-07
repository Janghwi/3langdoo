//** 로고 변경 enkornese로....... */
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'background_painter.dart';
import 'google_signin_prov.dart';

class SignUpWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Stack(fit: StackFit.expand, children: [
        CustomPaint(painter: BackgroundPainter()),
        buildSignUp(context),
      ]);

  Widget buildSignUp(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Spacer(),
        SizedBox(
            height: 120,
            width: 120,
            child: Image.asset('assets/images/logo.png')),
        Spacer(),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Hey Friends!\nWelcome to ENKORNESE',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 15),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Login to your account to continue',
            style: TextStyle(fontSize: 18),
          ),
        ),
        Spacer(),
        ElevatedButton.icon(
          onPressed: () {},
          icon: Icon(Icons.email_outlined),
          label: Text(
            'Sign Up with Email',
            style: TextStyle(fontSize: 20),
          ),
          style: ElevatedButton.styleFrom(
            primary: Colors.blue,
            minimumSize: Size(double.infinity, 40),
          ),
        ),
        SizedBox(height: 20),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            primary: Colors.white,
            onPrimary: Colors.black,
            minimumSize: Size(double.infinity, 40),
          ),
          icon: FaIcon(FontAwesomeIcons.google, color: Colors.red),
          label: Text(
            'Sign Up with Google',
            style: TextStyle(fontSize: 20),
          ),
          onPressed: () {
            final provider =
                Provider.of<GoogleSignInProvider>(context, listen: false);
            provider.googleLogin();
          },
        ),
        SizedBox(height: 40),
        RichText(
          text: TextSpan(
            text: 'Already have an account? ',
            children: const [
              TextSpan(
                text: 'Log in',
                style: TextStyle(decoration: TextDecoration.underline),
              ),
            ],
          ),
        ),
        Spacer(),
      ],
    );
  }
}
