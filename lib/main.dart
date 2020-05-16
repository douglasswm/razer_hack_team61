import 'package:flutter/material.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'services/services.dart';
import 'screens/screens.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// void main() => runApp(MyApp());
Future main() async {
  await DotEnv().load('.env');
  //...runapp
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<User>.value(value: Global.userRef.documentStream),
        StreamProvider<FirebaseUser>.value(value: AuthService().user),
      ],
      child: MaterialApp(
        // Firebase Analytics
        navigatorObservers: [
          FirebaseAnalyticsObserver(analytics: FirebaseAnalytics()),
        ],

        // Named Routes
        routes: {
          '/': (context) => LoginScreen(),
          '/profile': (context) => ProfileScreen(),
          '/loggedin': (context) => LoggedInWrapperScreen()
        },

        // Theme
        theme: ThemeData(
          primarySwatch: Colors.purple,
          textTheme: GoogleFonts.latoTextTheme(
            Theme.of(context).textTheme,
          ),
          buttonTheme: ButtonThemeData(),
        ),
      ),
    );
  }
}