import 'package:flutter/material.dart';
import 'package:pudding_flutter/social.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pudding_flutter/auth.dart';

class ProfilePage extends StatelessWidget {
  final String email;
  final String photoUrl;
  final String nickname;
  ProfilePage(this.photoUrl, this.nickname, this.email);
  @override
  Widget build(BuildContext context) {
    final Query users =
        Firestore.instance.collection('users').where('email', isEqualTo: email);
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Stack(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: CircleImage(
                  photoUrl,
                  length: 100,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 1.0),
                          child: Text(
                            'Name',
                            style: TextStyle(
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                        Text(
                          nickname,
                          style: TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                            bottom: 1.0,
                          ),
                          child: Text(
                            'Email',
                            style: TextStyle(
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                        Text(
                          email,
                          style: TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  StreamBuilder(
                      stream: users.snapshots(),
                      builder: (context, snapshot) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                  bottom: 1.0,
                                ),
                                child: Text(
                                  'Bio',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ),
                              (snapshot.hasData)
                                  ? Text(
                                snapshot.data.documents[0]['bio'],
                                style: TextStyle(
                                  fontSize: 18.0,
                                ),
                                maxLines: 5,
                                overflow: TextOverflow.ellipsis,
                              )
                                  : CircularProgressIndicator(),
                            ],
                          ),
                        );
                      }),
                ],
              ),
            ],
          ),
          Positioned(
            bottom: 20,
            right: 50,
            left: 50,
            child: ActionButton()
          )
        ]
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return (true) //TODO: check if this person is not a friend
        ? Material(
          color: Colors.deepOrangeAccent[200],
          elevation: 2,
          child: InkWell(
            onTap: () => print('Hello'),
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Icon(Icons.person_add),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text('Add Friend'),
                    ),
                  ],
                ),
              ),
          ),
        )
        : Container();
  }
}
