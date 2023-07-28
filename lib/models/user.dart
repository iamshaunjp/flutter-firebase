class MyUser {
  // define
  final String uid;

  // set
  MyUser({required this.uid}); // use required to remove null problem
}

class UserData {
  // define
  final String uid;
  final String name;
  final String sugars;
  final int strength;

  // set
  UserData(
      {required this.uid,
      required this.name,
      required this.sugars,
      required this.strength});
}
