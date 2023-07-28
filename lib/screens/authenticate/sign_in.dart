import 'package:flutter/material.dart';
import 'package:brew_crew/services/auth.dart';
import 'package:brew_crew/shared/constants.dart';
import 'package:brew_crew/shared/loading.dart';

class SignIn extends StatefulWidget {
  // set toggle function
  final Function toggleView;
  // require this function in constructor
  const SignIn({super.key, required this.toggleView});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  // import the auth service
  final AuthService _auth = AuthService();

  // key to allow us to validate form
  final _formKey = GlobalKey<FormState>();

  // whether we are now loading a result
  bool loading = false;

  // track the entry fields
  String email = '';
  String password = '';
  // error to tell user
  String error = '';

  @override
  Widget build(BuildContext context) {
    // if loading display widget, otherwise display Scaffold
    return loading
        ? const Loading()
        : Scaffold(
            // general scaffold
            backgroundColor: Colors.brown[100],
            // top bar of scaffold
            appBar: AppBar(
              backgroundColor: Colors.brown[400],
              elevation: 0.0,
              title: const Text('Sign-in to Brew Crew'),
              actions: <Widget>[
                TextButton.icon(
                  icon: Icon(Icons.person, color: Colors.brown[50]),
                  label: Text('Register',
                      style: TextStyle(color: Colors.brown[50])),
                  onPressed: () {
                    // toggle view from widget
                    widget.toggleView();
                  },
                ),
              ], // these appear in top right
            ),
            // body of scaffold
            body: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
              // sign in button
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    // padding using box
                    const SizedBox(height: 20.0),
                    // for email
                    TextFormField(
                      decoration: textInputDecoration.copyWith(
                          hintText:
                              'Email'), // use copyWith to customise the hintText
                      validator: (val) => val!.isEmpty
                          ? 'Please enter a valid email'
                          : null, // use to check if valid input
                      onChanged: (val) {
                        setState(() => email = val);
                      },
                    ),
                    // padding using box
                    const SizedBox(height: 20.0),
                    // for password
                    TextFormField(
                      decoration:
                          textInputDecoration.copyWith(hintText: 'Password'),
                      validator: (val) => val!.length < 6
                          ? 'Password must be atleast 6 characters long'
                          : null, // use to check if valid input
                      onChanged: (val) {
                        setState(() => password = val);
                      },
                      obscureText: true,
                    ),
                    // padding using box
                    const SizedBox(height: 20.0),
                    // submit button
                    ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color?>(
                              Colors.pink[400])),
                      child: const Text(
                        'Sign-in',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        // if form is valid send request
                        if (_formKey.currentState!.validate()) {
                          // start loading
                          setState(() => loading = true);

                          // sign-in
                          dynamic result = await _auth
                              .signInWithEmailAndPassword(email, password);

                          // if type string or null, it is an error
                          // if string, it is a custom error
                          if (result is String) {
                            setState(() => {
                                  error = result,
                                  loading = false, // stop loading
                                });
                          } else if (result == null) {
                            setState(() => {
                                  error = 'Authentication error',
                                  loading = false, // stop loading
                                });
                          }
                        }
                      },
                    ),
                    // padding using box
                    const SizedBox(height: 20.0),
                    // text to show error
                    Text(error,
                        style:
                            const TextStyle(color: Colors.red, fontSize: 14.0)),
                  ],
                ),
              ),
            ),
          );
  }
}
