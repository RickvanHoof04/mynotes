import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:practice_app/constants/routes.dart';

import '../utilities/show_error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
      appBar: AppBar(title: Text('Login')),
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
                await FirebaseAuth.instance.signInWithEmailAndPassword(
                  email: email,
                  password: password,
                );

                final user = FirebaseAuth.instance.currentUser;

                if(user?.emailVerified ?? false) {
                  Navigator.of(
                    context,
                  ).pushNamedAndRemoveUntil(notesRoute, (route) => false);
                } else {
                  Navigator.of(context).pushNamedAndRemoveUntil(verifyEmailRoute,(route) => false);
                }

              } on FirebaseAuthException catch (e) {
                if (e.code == 'invalid-credential') {
                  await showErrorDialog(context, 'Wrong Email or password');
                } else {
                  await showErrorDialog(
                    context,
                    'an error occurred: ${e.code}',
                  );
                }
              } catch (e) {
                await showErrorDialog(context, 'Error ${e.toString()}');
              }
            },

            child: Text('login'),
          ),

          TextButton(
            onPressed: () {
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil(registerRoute, (route) => false);
            },
            child: Text('Not registered yet? Register here!'),
          ),
        ],
      ),
    );
  }
}
