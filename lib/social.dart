import 'package:flutter/material.dart';
import 'package:pudding_flutter/auth.dart';

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
              delegate: CustomSearchDelegate(),
            );
            print("Searching friend!");
          }
      ),
      PopupMenuButton(
        onSelected: (value) {
          switch (value) {
            case 0: switchAccounts();
            break;
            default: throw(Exception("invalid value!"));
          }
        },
        itemBuilder: (context) => <PopupMenuEntry>[
          const PopupMenuItem(
            value: 0,
            child: Text('Switch accounts'),
          )
        ]
      ),
    ],
  );
}

class CustomSearchDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    // TODO: implement buildActions
    return null;
  }

  @override
  Widget buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return null;
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    return null;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    return null;
  }
}


class Social extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: <Widget>[
        Expanded(
          child: Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.yellow[100],
                    ),
                    child: StreamBuilder(
                      stream: auth.onAuthStateChanged,
                      builder: (context, snapshot) {
                        return (snapshot.hasData)
                          ? Image(image: NetworkImage(snapshot.data.photoUrl),)
                          : Image(image: AssetImage("icons/default_pudding.png"),);
                      }
                    ),
                    height: double.infinity,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 260,
                        child: Text("Placeholder Name",
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Divider(),
                      Container(
                        width: 260,
                        child: Text("Placeholder Bio: Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14.0,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          flex: 1,
        ),
        Divider(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: double.infinity,
            child: Text("Meetups",
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
          flex: 4,
        ),
      ],
    ));
  }
}