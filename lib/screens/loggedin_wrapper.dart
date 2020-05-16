import 'package:flutter/material.dart';
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:razerhack_flutter/screens/screens.dart';
import 'package:razerhack_flutter/services/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoggedInWrapperScreen extends StatefulWidget {
  LoggedInWrapperScreen({Key key}) : super(key: key);

  @override
  _LoggedInWrapperScreenState createState() => _LoggedInWrapperScreenState();
}

class _LoggedInWrapperScreenState extends State<LoggedInWrapperScreen> with WidgetsBindingObserver{
  int _currentIndex;
  final List<Widget> _children = [HomeScreen(), GoalScreen(), ProfileScreen()];
  AuthService _auth = AuthService();
  SharedPreferences prefs;
  String uid;

  readLocal() async {
    prefs = await SharedPreferences.getInstance();
    // get currentUser unique id
    uid = prefs.getString('id') ?? '';
  }

  @override
  void initState() {
    super.initState();
    readLocal();
    _auth.updateUserStatusOnline(uid);
    WidgetsBinding.instance.addObserver(this);
    _currentIndex = 0;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("APP_STATE: $state");
    readLocal();
    if(state == AppLifecycleState.resumed){
      // user returned to our app
     _auth.updateUserStatusOnline(uid);
    }else if(state == AppLifecycleState.inactive){
      // app is inactive
      _auth.updateUserStatusOffline(uid);
    }else if(state == AppLifecycleState.paused){
      // user quit our app temporally
      _auth.updateUserStatusOffline(uid);
    }else if(state == AppLifecycleState.detached){
      // app suspended
      _auth.updateUserStatusOffline(uid);
    }
  }

  void changePage(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      floatingActionButton: _currentIndex == 1 ? FloatingActionButton(
        onPressed: () {
          Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                CreateGoalScreen()));
        },
        child: Icon(FontAwesomeIcons.piggyBank),
        backgroundColor: Colors.purple[800],
      ) : FloatingActionButton(
        onPressed: () {},
        child: Icon(FontAwesomeIcons.qrcode),
        backgroundColor: Colors.purple[800],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: BubbleBottomBar(
        hasNotch: true,
        hasInk: true,
        fabLocation: BubbleBottomBarFabLocation.end,
        opacity: .2,
        currentIndex: _currentIndex,
        onTap: changePage,
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(
                16)), //border radius doesn't work when the notch is enabled.
        elevation: 8,
        items: <BubbleBottomBarItem>[
          BubbleBottomBarItem(
              backgroundColor: Colors.purple[600],
              icon: Icon(                
                Icons.home,
                // size: 30,
                color: Colors.grey,
              ),
              activeIcon: Icon(
                Icons.home,
                // size: 30,
                color: Colors.purple[600],
              ),
              title: Text("Home")),
          BubbleBottomBarItem(
              backgroundColor: Colors.purple[600],
              icon: Icon(
                Icons.flag,
                // size: 30,
                color: Colors.grey,
              ),
              activeIcon: Icon(
                Icons.flag,
                color: Colors.purple[600],
              ),
              title: Text("Goals")),
          BubbleBottomBarItem(
              backgroundColor: Colors.purple[600],
              icon: Icon(
                Icons.account_circle,
                // size: 30,
                color: Colors.grey,
              ),
              activeIcon: Icon(
                Icons.account_circle,
                color: Colors.purple[600],
              ),
              title: Text("Profile"))
        ],
      ),
    );
  }
}