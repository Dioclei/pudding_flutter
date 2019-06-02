import 'package:flutter/material.dart';
import 'package:pudding_flutter/auth.dart';
import 'package:pudding_flutter/social/profilepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pudding_flutter/social/social.dart';
import 'package:pudding_flutter/themecolors.dart';

class PersonalProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: StreamBuilder(
        stream: Firestore.instance
            .collection('users')
            .document(user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final photoUrl = snapshot.data['photoUrl'];
            final nickname = snapshot.data['nickname'];
            final uid = snapshot.data.documentID;
            final email = snapshot.data['email'];
            final bio = (snapshot.data['bio'] != null)
                ? snapshot.data['bio']
                : 'No bio set';
            return PersonalProfilePageBody(
                photoUrl: photoUrl,
                nickname: nickname,
                uid: uid,
                email: email,
                bio: bio);
          } else
            return CircularProgressIndicator();
        },
      ),
    );
  }
}

class PersonalProfilePageBody extends StatefulWidget {
  final photoUrl;
  final nickname;
  final uid;
  final email;
  final bio;
  PersonalProfilePageBody(
      {@required this.photoUrl,
      @required this.nickname,
      @required this.uid,
      @required this.email,
      @required this.bio});

  @override
  _PersonalProfilePageBodyState createState() => _PersonalProfilePageBodyState();
}

class _PersonalProfilePageBodyState extends State<PersonalProfilePageBody> {

  TextEditingController nameController = TextEditingController();
  TextEditingController bioController = TextEditingController();

  @override
  void initState() {
    nameController.text = widget.nickname;
    bioController.text = widget.bio;
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column( //TODO: change to ListView to accommodate smaller screens and overflow.
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(32.0),
          child: Container(
            width: 120,
            height: 120,
            decoration: ShapeDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                  image: NetworkImage(widget.photoUrl)),
                shape: CircleBorder()
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  print('Implement changing of image'); //TODO: Implement changing of image
                },
                borderRadius: BorderRadius.circular(50.0),
              ),
            ),
          ),
        ),
        Material(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              InkWell(
                onTap: () {
                  return showModalBottomSheet(context: context, builder: (context) { //TODO STRANGE BUG: modalbottomsheet doesn't resize to the keyboard so it overflows.
                    return Container(
                      height: 120,
                      color: backgroundColor,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
                            child: Text('Set a new nickname'),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
                            child: TextField(
                              controller: nameController,
                              onSubmitted: (String string) {
                                setState(() => nameController.text = string);
                                Firestore.instance.collection('users').document(user.uid).updateData({'nickname': string});
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  });
                },
                child: Column(
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
                                color: Colors.brown,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                widget.nickname,
                                style: TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                              Icon(Icons.edit, color: Colors.brown,)
                            ],
                          ),
                        ],
                      ),
                    ),
                    Divider(),
                  ],
                ),
              ),
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
                          color: Colors.brown,
                        ),
                      ),
                    ),
                    Text(
                      widget.email,
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(),
              InkWell(
                onTap: () {
                  return showModalBottomSheet(context: context, builder: (context) {
                    return Container(
                      height: 120,
                      color: backgroundColor,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
                            child: Text('Set a new bio'),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
                            child: TextField(
                              controller: bioController,
                              onSubmitted: (String string) {
                                setState(() => bioController.text = string);
                                Firestore.instance.collection('users').document(user.uid).updateData({'bio': string});
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  });
                },
                child: Padding(
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
                            color: Colors.brown,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            widget.bio,
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                            maxLines: 5,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Icon(Icons.edit),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
