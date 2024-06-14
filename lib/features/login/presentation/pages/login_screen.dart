import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(left: 24.0, right: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(
                image: AssetImage('lib/core/assets/images/app_logo.png'),
                width: 200.0),
            const Text(
              'LOGIN',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold),
            ),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Enter NT Username',
              ),
            ),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Enter NT Password',
              ),
            ),
            const SizedBox(height: 24.0),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(50.0),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/selection');
              },
              child: const Text('SIGN IN'),
            ),
          ],
        ),
      ),
    );
  }
}
