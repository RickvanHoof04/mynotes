import 'package:flutter/material.dart';
import 'package:practice_app/services/auth/auth_service.dart';

import '../constants/routes.dart';
import '../enums/menu_action.lib.dart';
import '../main.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: ,
        title: const Text('Main UI '),
        actions: [
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch(value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogOutDialog(context);
                  if(shouldLogout) {
                    await AuthService.firebase().logOut();
                    Navigator.of(context).pushNamedAndRemoveUntil(loginRoute, (route) => false);
                  }
                  break;
              }
            },
            itemBuilder: (context) {
              return [
                PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text('logout'),
                ),
              ];
            },
          ),
        ],
      ),
      body: Text('Hello'),
    );
  }
}