import 'package:flutter/material.dart';
import 'package:brew_crew/models/brew.dart';

class BrewTile extends StatelessWidget {
  // the brew data
  final Brew brew;

  // constructor
  const BrewTile({super.key, required this.brew});

  @override
  Widget build(BuildContext context) {
    // padded cards which display based on the brew data
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Card(
        margin: const EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: ListTile(
          // strength display
          leading: CircleAvatar(
            radius: 25.0,
            backgroundColor: Colors.brown[brew.strength],
            backgroundImage: const AssetImage('assets/coffee_icon.png'),
          ),
          // name display
          title: Text(brew.name),
          // sugars display
          subtitle: Text('Takes ${brew.sugars} sugar(s)'),
        ),
      ),
    );
  }
}
