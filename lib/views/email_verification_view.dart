import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools;

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify email'),),
      body: Column(
        children: [
          const Text('please verify your email address.'),
          TextButton(
            onPressed: () async {
              final user = FirebaseAuth.instance.currentUser;
              devtools.log('email send to $user');
              await user?.sendEmailVerification();
            },
            child: Text('Send email verification'),
          ),
        ],
      ),
    );
  }
}
