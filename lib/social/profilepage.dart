import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pudding_flutter/social/social.dart';
import 'package:pudding_flutter/auth.dart';
import 'package:pudding_flutter/themecolors.dart';

class ProfilePage extends StatelessWidget {
  final String uid;
  final String photoUrl;
  final String nickname;
  final String email;
  ProfilePage(
      {@required this.photoUrl,
      @required this.nickname,
      @required this.uid,
      @required this.email});
  @override
  Widget build(BuildContext context) {
    final DocumentReference users =
        Firestore.instance.collection('users').document(uid);
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Stack(children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CircleImage(
                photoUrl: photoUrl,
                size: 100,
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
                                    snapshot.data['bio'],
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
            child: ActionButton(
              targetuid: uid,
            ))
      ]),
    );
  }
}

/* 4 Cases
     * Not friend, Not requested.
     * Not friend, He requested.
     * Not friend, You requested.
     * Friend
     */

enum Status {
  not_friend,
  awaiting_accept,
  requested,
  friend,
}

List<String> _textOptions = [
  "SEND FRIEND REQUEST",
  "ACCEPT FRIEND REQUEST",
  "FRIEND REQUEST SENT",
  "SCHEDULE MEETUP",
];

List<Color> _colorOptions = [
  Colors.deepOrangeAccent[200],
  Colors.green[700],
  Colors.green[700],
  Colors.blue,
];

Status status;

class ActionButton extends StatelessWidget {
  final String targetuid;
  ActionButton({@required this.targetuid});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Firestore.instance
            .collection('users')
            .document(user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final List requested = snapshot.data['requested'];
            final List friends = snapshot.data['friends'];
            final List sentRequests = snapshot.data['sentRequests'];
            if (![null, []].contains(friends) && friends.contains(targetuid))
              status = Status.friend;
            else if (![null, []].contains(requested) &&
                requested.contains(targetuid))
              status = Status.awaiting_accept;
            else if (![null, []].contains(sentRequests) &&
                sentRequests.contains(targetuid))
              status = Status.requested;
            else
              status = Status.not_friend;

            return Material(
              color: _colorOptions.elementAt(status.index),
              elevation: 2,
              child:
                  (status != Status.requested) //no inkwell if its a requested.
                      ? InkWell(
                          onTap: () {
                            switch (status) {
                              case Status.friend:
                                showFriendList(context);
                                break;
                              case Status.awaiting_accept:
                                acceptFriendRequest(
                                    context, targetuid); //TODO: add a decline
                                break;
                              case Status.requested:
                                // this doesn't actually happen.
                                break;
                              case Status.not_friend:
                                initiateFriendRequest(context, targetuid);
                                break;
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Icon(
                                    Icons.person_add,
                                    color: Colors.white,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Text(
                                    _textOptions.elementAt(status.index),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Icon(
                                  Icons.person_add,
                                  color: Colors.white,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Text(
                                  _textOptions.elementAt(status.index),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }
}

void acceptFriendRequest(BuildContext context, String targetuid) {
  Firestore.instance.collection('users').document(user.uid).updateData({
    'friends': FieldValue.arrayUnion([targetuid])
  });
  Firestore.instance.collection('users').document(targetuid).updateData({
    'friends': FieldValue.arrayUnion([user.uid])
  });
  Firestore.instance.collection('users').document(user.uid).updateData({
    'requested': FieldValue.arrayRemove([targetuid])
  });
  Firestore.instance.collection('users').document(targetuid).updateData({
    'sentRequests': FieldValue.arrayRemove([user.uid])
  });
  Scaffold.of(context).showSnackBar(SnackBar(
    content: Text("Friend request accepted!"),
  ));
}

void declineFriendRequest(BuildContext context, String targetuid) {
  Firestore.instance.collection('users').document(user.uid).updateData({
    'requested': FieldValue.arrayRemove([targetuid])
  });
  Firestore.instance.collection('users').document(targetuid).updateData({
    'sentRequests': FieldValue.arrayRemove([user.uid])
  });
  Scaffold.of(context).showSnackBar(SnackBar(
    content: Text("Friend request declined!"),
  ));
}

void initiateFriendRequest(BuildContext context, String targetuid) {
  Firestore.instance.collection('users').document(targetuid).updateData({
    'requested': FieldValue.arrayUnion([user.uid])
  });
  Firestore.instance.collection('users').document(user.uid).updateData({
    'sentRequests': FieldValue.arrayUnion([targetuid])
  });
  Scaffold.of(context).showSnackBar(SnackBar(
    content: Text("Friend request sent!"),
  ));
}
