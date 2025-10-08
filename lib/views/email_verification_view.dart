// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

import 'package:practice_app/constants/routes.dart';
import 'package:practice_app/services/auth/auth_service.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify email')),
      body: Column(
        children: [
          const Text("We've send an email for verification!"),
          const Text("If you haven't received an verification email, please press here:"),
          TextButton(
            onPressed: () async {
              AuthService.firebase().sendEmailVerification();
            },
            child: Text('Send email verification'),
          ),

          TextButton(
            onPressed: () async {
              await AuthService.firebase().logOut();
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil(registerRoute, (route) => false);
            },
            child: Text('Restart'),
          ),
        ],
      ),
    );
  }
}