import 'package:flutter/material.dart';
import 'package:brew_crew/models/user.dart';
import 'package:brew_crew/services/database.dart';
import 'package:brew_crew/shared/constants.dart';
import 'package:brew_crew/shared/loading.dart';
import 'package:provider/provider.dart';

class SettingsForm extends StatefulWidget {
  const SettingsForm({super.key});

  @override
  State<SettingsForm> createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  // key used in the form
  final _formKey = GlobalKey<FormState>();

  // used in input
  final List<String> sugars = ['0', '1', '2', '3', '4'];

  // form values
  String? _currentName;
  String? _currentSugars;
  int? _currentStrength;

  @override
  Widget build(BuildContext context) {
    // get user currently signed in
    final user = Provider.of<MyUser>(context);

    // using StreamBuilder as we are only using this stream in this widget
    // for sharing across multiple widgets better to use provider method as before
    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          // check we have data for form
          if (snapshot.hasData) {
            // get user data for form
            // will be used to set initial values of each (see the ??)
            UserData userData = snapshot.data!;

            return Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  // title
                  const Text('Update your brew settings.',
                      style: TextStyle(fontSize: 18.0)),
                  // padding
                  const SizedBox(height: 20.0),
                  // form field for name
                  TextFormField(
                    initialValue: userData.name,
                    decoration: textInputDecoration,
                    validator: (val) =>
                        val!.isEmpty ? 'Please enter a name' : null,
                    onChanged: (val) => setState(() => _currentName = val),
                  ),
                  // padding
                  const SizedBox(height: 20.0),
                  // dropdown for sugars
                  DropdownButtonFormField(
                    decoration: textInputDecoration,
                    value: _currentSugars ?? userData.sugars,
                    items: sugars.map((sugar) {
                      return DropdownMenuItem(
                        value: sugar,
                        child: Text('$sugar sugars'),
                      );
                    }).toList(), // each item is a map from sugars to a menu item containing widget
                    onChanged: (val) =>
                        setState(() => _currentSugars = val ?? userData.sugars),
                  ),
                  // slider for strength
                  Slider(
                    activeColor:
                        Colors.brown[_currentStrength ?? userData.strength],
                    inactiveColor:
                        Colors.brown[_currentStrength ?? userData.strength],
                    min: 100.0,
                    max: 900.0,
                    divisions: 8,
                    value: (_currentStrength ?? userData.strength).toDouble(),
                    onChanged: (double val) =>
                        setState(() => _currentStrength = val.round()),
                  ),
                  // button to update changes
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color?>(
                            Colors.pink[400])),
                    child: const Text(
                      'Update',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      // ensure form is validated
                      if (_formKey.currentState!.validate()) {
                        // if user does not enter the field, _currentName will default to ''
                        // if this is the case, make it the users name instead (as intended)
                        if (_currentName == '') {
                          _currentName = userData.name;
                        }

                        // now update the users data to these
                        DatabaseService(uid: user.uid).updateUserData(
                            _currentSugars ?? userData.sugars,
                            _currentName ?? userData.name,
                            _currentStrength ?? userData.strength);

                        // now close bottom sheet
                        if (mounted) Navigator.pop(context);
                      }
                    },
                  ),
                ],
              ),
            );
          } else {
            // without user data just set as loading
            return const Loading();
          }
        });
  }
}
