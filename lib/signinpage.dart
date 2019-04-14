import 'package:flutter/material.dart';
import 'main.dart';
import 'auth.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:shimmer/shimmer.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignInRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Sign In",
      theme: themeData,
      routes: <String, WidgetBuilder>{
        '/home': (context) => MyApp(),
      },
      home: new SignInScreen(),
    );
  }
}

class SignInScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Container(
        color: Colors.yellow[100],
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: Shimmer.fromColors(
                  period: Duration(milliseconds: 3000),
                  baseColor: Colors.brown[600],
                  highlightColor: Colors.brown[200],
                  child: Text(
                    "Welcome to Pudding",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GoogleSignInButton(
                  onPressed: () {
                    handleSignIn().then((FirebaseUser user) {
                      Navigator.of(context).pushReplacementNamed('/home');
                    }).catchError((e) {
                      Scaffold.of(context).showSnackBar(
                        SnackBar(content: Text('Unsuccessful login. Please try again.'))
                      );
                      print(e);
                    });
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
