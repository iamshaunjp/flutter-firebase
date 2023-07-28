import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:brew_crew/models/brew.dart';
import 'package:brew_crew/models/user.dart';

class DatabaseService {
  // user id from firebase (taken on sign-in/register)
  final String? uid;

  // constructor
  DatabaseService({this.uid});

  // users collection reference
  // automatically creates if not found
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  // called when a new user signs up (register) to create user
  // also called when updating any user fields
  Future updateUserData(String sugars, String name, int strength) async {
    // set fields in this users document
    return await usersCollection.doc(uid).set({
      'sugars': sugars,
      'name': name,
      'strength': strength,
    });
  }

  // brews list from snapshot
  List<Brew> _brewsListFromSnapshot(QuerySnapshot snapshot) {
    // map to pass through each doc in docs and return processed versions in list
    return snapshot.docs.map((doc) {
      return Brew(
          sugars: doc.get('sugars') ??
              '0', // will return either sugars, or '0' if nothing found
          name: doc.get('name') ?? '',
          strength: doc.get('strength') ?? 0);
    }).toList();
  }

  // userdata from snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
        uid: uid!, // uid must have been passed in order to use
        name: snapshot.get('name'),
        sugars: snapshot.get('sugars'),
        strength: snapshot.get('strength'));
  }

  // get brews stream as a list
  Stream<List<Brew>> get brews {
    return usersCollection.snapshots().map(_brewsListFromSnapshot);
  }

  // get current users doc stream
  Stream<UserData> get userData {
    return usersCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }
}
