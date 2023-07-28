import 'package:flutter/material.dart';
import 'package:brew_crew/models/brew.dart';
import 'package:brew_crew/screens/home/settings_form.dart';
import 'package:brew_crew/screens/home/brews_list.dart';
import 'package:brew_crew/services/auth.dart';
import 'package:brew_crew/services/database.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  Home({super.key});

  // need the auth instance
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    // bottom sheet panel
    void showSettingsPanel() {
      // when called, will display bottom sheet with widget found in builder
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
            child: const SettingsForm(),
          );
        },
      );
    }

    // use stream for user data
    return StreamProvider<List<Brew>?>.value(
      initialData: null,
      value: DatabaseService().brews,
      child: Scaffold(
        // general scaffold
        backgroundColor: Colors.brown[50],
        // top bar of scaffold
        appBar: AppBar(
          title: const Text('Brew Crew'),
          backgroundColor: Colors.brown[400],
          elevation: 0.0,
          actions: <Widget>[
            // logout
            TextButton.icon(
              icon: Icon(Icons.person, color: Colors.brown[50]),
              label: Text('logout', style: TextStyle(color: Colors.brown[50])),
              onPressed: () async {
                // logout
                await _auth.signOut();
              },
            ),
            // edit brews
            TextButton.icon(
              icon: Icon(Icons.settings, color: Colors.brown[50]),
              label:
                  Text('settings', style: TextStyle(color: Colors.brown[50])),
              onPressed: () => showSettingsPanel(),
            ),
          ], // these appear in top right
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/coffee_bg.png'), fit: BoxFit.cover),
          ),
          child: const BrewsList(),
        ),
      ),
    );
  }
}
