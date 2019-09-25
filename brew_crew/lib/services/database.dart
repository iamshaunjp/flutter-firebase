import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {

  // collection reference
  final CollectionReference brewCollection = Firestore.instance.collection('brews');

}