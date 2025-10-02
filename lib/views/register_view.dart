import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:practice_app/constants/routes.dart';
import 'package:practice_app/utilities/show_error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    super.initState();
    _email = TextEditingController();
    _password = TextEditingController();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Column(
        children: [
          TextField(
            controller: _email,
            decoration: InputDecoration(hint: Text('enter your email')),
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
          ),
          TextField(
            controller: _password,
            decoration: InputDecoration(hint: Text('enter your password')),
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              try {
                await FirebaseAuth.instance.createUserWithEmailAndPassword(
                  email: email,
                  password: password,
                );

                final user = FirebaseAuth.instance.currentUser;
                await user?.sendEmailVerification();
                Navigator.of(context).pushNamed(verifyEmailRoute);
              } on FirebaseAuthException catch (e) {}
            },
            child: Text('Register'),
          ),

          TextButton(
            onPressed: () {
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil(loginRoute, (route) => false);
            },
            child: Text('Already registered? Login here!'),
          ),
        ],
      ),
    );
  }
}
