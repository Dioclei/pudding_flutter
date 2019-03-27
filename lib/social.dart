import 'package:flutter/material.dart';
import 'package:pudding_flutter/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pudding_flutter/auth.dart';
import 'package:pudding_flutter/profilepage.dart';

// AppBar for our Social screen
AppBar socialAppBar(BuildContext context) {
  return AppBar(
    title: Text("Social"),
    actions: <Widget>[
      IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            showSearch(
              context: context,
              delegate: SocialSearchDelegate(),
            );
            print("Searching friend!");
          }),
      PopupMenuButton(
          onSelected: (value) {
            switch (value) {
              case 0:
                switchAccounts();
                break;
              default:
                throw (Exception("invalid value!"));
            }
          },
          itemBuilder: (context) => <PopupMenuEntry>[
                const PopupMenuItem(
                  value: 0,
                  child: Text('Switch accounts'),
                )
              ]),
    ],
  );
}

class SocialSearchDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      query.isNotEmpty
          ? IconButton(
              tooltip: 'Clear',
              icon: Icon(Icons.clear),
              onPressed: () {
                query = '';
                showSuggestions(context);
              },
            )
          : Container(),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'back',
      icon: BackButtonIcon(),
      color: Colors.grey[700],
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    /* TODO: this returns a string [query]. Show results of the query here.
     * Perhaps search the person's email / name.
     * Name can do a keyword index if possible.
     * Implement email search first.
     */
    return Container(
        child: (query.contains('@') &&
                query.contains('.')) //check whether it's an email
            ? StreamBuilder(
                stream: Firestore.instance
                    .collection('users')
                    .where('email', isEqualTo: query.trim())
                    .snapshots(),
                builder: (context, snapshot) {
                  return (snapshot.hasData)
                      ? ListView.builder(
                          itemCount: snapshot.data.documents.length,
                          itemBuilder: (context, n) {
                            return (user.email !=
                                    snapshot.data.documents[n]['email'])
                                ? SocialCard(
                                    snapshot.data.documents[n]['photoUrl'],
                                    snapshot.data.documents[n]['nickname'],
                                    snapshot.data.documents[n]['email'])
                                : Container();
                          },
                        )
                      : CircularProgressIndicator();
                },
              )
            : StreamBuilder(
                stream: Firestore.instance
                    .collection('users')
                    .where('nickname', isEqualTo: query.trim())
                    .snapshots(),
                builder: (context, snapshot) {
                  return (snapshot.hasData)
                      ? ListView.builder(
                          itemCount: snapshot.data.documents.length,
                          itemBuilder: (context, n) {
                            return (user.email !=
                                    snapshot.data.documents[n]['email'])
                                ? SocialCard(
                                    snapshot.data.documents[n]['photoUrl'],
                                    snapshot.data.documents[n]['nickname'],
                                    snapshot.data.documents[n]['email'])
                                : Container();
                          },
                        )
                      : CircularProgressIndicator();
                },
              ));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Column(
      children: <Widget>[
        Text('Search for a person using his name or email!'),
        Text('Search for an email for greater accuracy..'),
      ],
    );
  }
}

class Social extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: <Widget>[
        Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: StreamBuilder(
                      stream: auth.onAuthStateChanged,
                      builder: (context, snapshot) {
                        return (snapshot.hasData)
                            ? CircleImage(
                                snapshot.data.photoUrl,
                                length: 70,
                              )
                            : Container(
                                height: 70,
                                width: 70,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image:
                                            AssetImage('default_pudding.png'))),
                              );
                      }
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Placeholder Name",
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "Placeholder Bio: Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod",
                        overflow: TextOverflow.ellipsis,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Divider(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: double.infinity,
            child: Text(
              "Meetups",
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 24.0,
              ),
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: GestureDetector(
              child: Text("No meetups yet. Schedule one?"),
              onTap: () {
                print("Scheduling meetup!");
              }, //TODO: Meetup scheduler
            ),
          ),
        ),
      ],
    ));
  }
}

class SocialCard extends StatelessWidget {
  final String photoUrl;
  final String nickname;
  final String email;

  SocialCard(
    this.photoUrl,
    this.nickname,
    this.email,
  );

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ProfilePage(photoUrl, nickname, email),
        ));
      },
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: CircleImage(photoUrl),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(0.5),
                  child: Text(
                    nickname,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    overflow: TextOverflow.clip,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(0.5),
                  child: Text(
                    email,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Colors.grey[700],
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CircleImage extends StatelessWidget {
  final String photoUrl;
  final double length;

  CircleImage(this.photoUrl, {this.length: 60});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: length,
      width: length,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: NetworkImage(photoUrl),
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
