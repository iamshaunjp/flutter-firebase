import 'package:flutter/material.dart';
import 'package:brew_crew/models/brew.dart';
import 'package:brew_crew/screens/home/brew_tile.dart';
import 'package:provider/provider.dart';

class BrewsList extends StatefulWidget {
  const BrewsList({super.key});

  @override
  State<BrewsList> createState() => _BrewsListState();
}

class _BrewsListState extends State<BrewsList> {
  @override
  Widget build(BuildContext context) {
    // get brews from stream
    final brews = Provider.of<List<Brew>?>(context);
    // make sure not null
    // otherwise, return text saying there are no brews
    if (brews != null) {
      // cycles through each item in list to create multiple widgets
      return ListView.builder(
        itemCount: brews.length,
        itemBuilder: (context, index) {
          // create brew tile widget based off of this brew
          return BrewTile(brew: brews[index]);
        },
      );
    } else {
      // not possible to reach normally anyways (may be seen before initial stream call)
      return const Text('No brew data found.');
    }
  }
}
