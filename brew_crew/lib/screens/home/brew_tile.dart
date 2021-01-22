import 'package:brew_crew/models/brew.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';

class BrewTile extends StatelessWidget {

  final Brew brew;
  BrewTile({ this.brew });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: ListTile(
          leading: CircleAvatar(
            radius: 25.0,
            backgroundColor: Colors.brown[brew.strength],
            backgroundImage: AssetImage('assets/coffee_icon.png'),
          ),
          title: Text(brew.name),
          subtitle: Text('Takes ${brew.sugars} sugar(s)'),
          trailing: StreamBuilder(
            stream: DataConnectionChecker().onStatusChange,
            builder: (context, snapshot) {
              if (snapshot.data == DataConnectionStatus.connected){
              return Icon(Icons.lens,
              color: Colors.green,);
              }else if (snapshot.data == DataConnectionStatus.disconnected){
                return Icon(Icons.lens,
              color: Colors.red,);
              }else
              return Icon(Icons.lens,
              color: Colors.grey,);
            }
          ),
        ),
      ),
    );
  }
}