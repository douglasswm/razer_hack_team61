import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/services.dart';
import '../shared/shared.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService auth = AuthService();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    FirebaseUser user = Provider.of<FirebaseUser>(context);

    if (user != null) {
      String profilePicture = user.photoUrl.replaceAll('s96-c', 's400-c');
      return Scaffold(
          body: Column(
        children: <Widget>[
          SizedBox(
            height: 150.0,
          ),
          Center(
              child: CircleAvatar(
                  radius: 40.0, backgroundImage: NetworkImage(profilePicture))),
          SizedBox(
            height: 5.0,
          ),
          Text(user.displayName,
              style: TextStyle(color: Colors.black, fontSize: 32.0)),
          SizedBox(
            height: 5.0,
          ),
          Text(user.email,
              style: TextStyle(color: Colors.black, fontSize: 18.0)),
          SizedBox(
            height: 5.0,
          ),
          OutlineButton(
            child: new Text("SIGN OUT"),
            onPressed: () async {
              await auth.signOut();
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/', (route) => false);
            },
          )
        ],
      ));
    } else {
      return LoadingScreen();
    }
  }
}
