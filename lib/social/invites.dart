import 'package:flutter/material.dart';
import 'package:pudding_flutter/auth/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pudding_flutter/goals/dateparser.dart';

/// Invites Data Structure:
/// Located within collection('users').document('user.uid').collection('invites')
/// Each document contains:
/// - startTime (DateTime.toIso8601String)
/// - endTime (DateTime.toIso8601String)
/// - inviter (String, the uid of the inviter)
/// - invited (List<String>, the uids of the invited)
/// - message (String)

class InvitesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance.collection('users').document(user.uid).collection('invites').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List invitesList = snapshot.data.documents
              .map((doc) {
            return Invite(
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
    );
  }
}

class Invite {
  final DateTime startTime;
  final DateTime endTime;
  final String inviterUid;
  final List invitedUid;
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
  double height;
  bool selected;
  Widget child;
  List<Widget> children = [];
  CrossFadeState _crossFadeState;

  @override
  void initState() {
    _crossFadeState = CrossFadeState.showFirst;

    selected = widget.selected;
    if (selected)
      height = 170.0;
    else
      height = 100.0;

    children = [
      Row(
        children: <Widget>[
          StreamBuilder(
              stream: Firestore.instance.collection('users').document(widget.invite.inviterUid).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return CircleAvatar(
                    backgroundImage: NetworkImage(snapshot.data['photoUrl']),
                  );
                } else return CircularProgressIndicator();
              }
          ),
          Text('${widget.invite.startTime.hour}:${widget.invite.startTime.minute} - ${widget.invite.endTime.hour}:${widget.invite.endTime.minute}\n ${getMonthDay(widget.invite.startTime)}',
            style: TextStyle(color: Colors.white),
          ),
          InkWell(
            onTap: () => setState(() {
              if (_crossFadeState == CrossFadeState.showFirst)
                _crossFadeState = CrossFadeState.showSecond;
              else _crossFadeState = CrossFadeState.showFirst;
            }),
            child: AnimatedCrossFade(
              crossFadeState: _crossFadeState,
              firstChild: Icon(Icons.arrow_drop_down),
              secondChild: Icon(Icons.arrow_drop_up),
              duration: Duration(seconds: 1),
            ),
          ),
        ],
      ),
      Column(

      ),
    ];
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      height: height,
      duration: Duration(milliseconds: 200),
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
                selected = false;
                print(height);
                height = 100.0;
                child = children[0];
              });
            else
              setState(() {
                selected = true;
                print(height);
                height = 170.0;
                child = children[1];
              });
          },
          child: child,
        ),
      ),
    );
  }
}


