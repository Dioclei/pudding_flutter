import 'package:flutter/material.dart';
import 'package:pudding_flutter/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Invites Data Structure:
/// Located within collection('users').document('user.uid').collection('invites')
/// Each document contains:
/// - startTime (DateTime.toIso8601String)
/// - endTime (DateTime.toIso8601String)
/// - inviter (String, the uid of the inviter)
/// - invited (List<String>, the uids of the invited)
/// - message (String)

AppBar invitesAppBar() {
  return AppBar(
    title: Text('Invites'),
  );
}

class InvitesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: invitesAppBar(),
      body: StreamBuilder(
        stream: Firestore.instance.collection('users').document(user.uid).collection('invites').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Invite> invitesList = snapshot.data.documents
                .map((doc) {
              return new Invite(
                startTime: DateTime.parse(doc['startTime']),
                endTime: DateTime.parse(doc['endTime']),
                inviterUid: doc['inviter'],
                invitedUid: doc['invited'],
                message: doc['message'],
              );
            }).toList();
            return ListView.builder(
              itemCount: invitesList.length,
              itemBuilder: (context, i) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: InvitesCard(invite: invitesList[i], selected: (invitesList.length == 1),
                ),
              ),
            );
          } else return CircularProgressIndicator();
        }
      ),
    );
  }
}

class Invite {
  final DateTime startTime;
  final DateTime endTime;
  final String inviterUid;
  final List<String> invitedUid;
  final String message;
  Invite({this.startTime, this.endTime, this.inviterUid, this.invitedUid, this.message});
}

class InvitesCard extends StatefulWidget {
  final Invite invite;
  final bool selected;
  InvitesCard({@required this.invite, this.selected: false});
  @override
  _InvitesCardState createState() => _InvitesCardState();
}

class _InvitesCardState extends State<InvitesCard> {
  double height = 170.0;
  bool selected;
  @override
  void initState() {
    selected = widget.selected;
    if (selected)
      height = 170.0;
    else
      height = 100.0;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      height: height,
      duration: Duration(seconds: 1),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0)
      ),
      child: Material(
        borderRadius: BorderRadius.circular(15.0),
        color: Colors.brown,
        child: InkWell(
          borderRadius: BorderRadius.circular(15.0),
          onTap: () {
            if (selected)
              setState(() {
                height = 170.0;
              });
            else
              setState(() {
                height = 100.0;
              });
          },
          child: ,
        ),
      ),
    );
  }
}


