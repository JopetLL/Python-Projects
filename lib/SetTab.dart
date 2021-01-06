import 'package:flutter/material.dart';
import 'dart:async';
import 'DB_helper.dart';
import 'package:time/time.dart';
import 'package:intl/intl.dart';
import 'SetList.dart';
import 'PlayerList.dart';
import 'PlayerTab.dart';

String timestring;

class SetTab extends StatefulWidget {
  final String title;

  SetTab({Key key, this.title}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SetTabState();
  }
}
class SetTabState extends State<SetTab> {
  final formKey = new GlobalKey<FormState>();
  var dbHelper;
  bool isUpdating;

  TextEditingController controller = TextEditingController();
  Future<List<Group>> groups;
  String participants;
  String tstart = "3:00PM";
  String tend = "10:00 PM";
  int curSetId;


  void timenow() {
    final String formattedDateTime = DateFormat('kk:mm:ss').format(
        DateTime.now()).toString();
    setState(() {
      timestring = formattedDateTime;
    });
  }

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    isUpdating = false;
    refreshList();
  }

  refreshList() {
    setState(() {
      groups = dbHelper.getSets();
    });
  }

  clearSets() {
    controller.text = '';
  }

  validate() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      if (isUpdating) {
        Group f = Group(curSetId, participants);
        dbHelper.updateSets(f);
        setState(() {
          isUpdating = false;
        });
      } else {
        Group f= Group(null, participants);
        dbHelper.saveSets(f);
      }
      clearSets();
      refreshList();
    }
  }

  form() {
    Future<List<Player>> players;

    players = dbHelper.getPlayers();
    return Form(
      key: formKey,
      child: Padding(
        padding: EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          verticalDirection: VerticalDirection.down,
          children: <Widget>[
            TextFormField(
              controller: controller,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(labelText: 'Who will be playing?'),
              validator: (val) => val.length == 0 ? 'Enter 4 Players' : null,
              onSaved: (val) => participants = val,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FlatButton(
                  onPressed: validate,
                  child: Text(isUpdating ? 'UPDATE' : 'CREATE SET'),
                ),
                FlatButton(
                  onPressed: () {
                    setState(() {
                      isUpdating = false;
                    });
                    clearSets();
                  },
                  child: Text('CANCEL'),
                ),
                FlatButton(
                  child: Text('CLEAR'),
                  onPressed: () {
                    dbHelper.clear();
                    refreshList();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  SingleChildScrollView dataTable(List<Group> groups) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: DataTable(
        columns: [
          DataColumn(
            label: Text('SET PLAYERS'),
          ),
          DataColumn(
            label: Text('TIME START'),
          ),
          DataColumn(
            label: Text('TIME END'),
          )
        ],
        rows: groups
            .map(
              (Group group) => DataRow(cells: [
            DataCell(
              Text(group.participants),
              onTap: () {
                setState(() {
                  isUpdating = true;
                  curSetId = group.setid;
                });
                controller.text = group.participants;
              },
            ),
            DataCell(
              Text("Time Started"),
              onTap: () {
                setState(() {
                  isUpdating = true;
                  curSetId = group.setid;
                });
                controller.text = "This is the start time";
              },
            ),
            DataCell(IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                dbHelper.delete(group.setid);
                refreshList();
              },
            )),
          ]),
        )
            .toList(),
      ),
    );
  }

  list() {
    return Expanded(
      child: FutureBuilder(
        future: groups,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return dataTable(snapshot.data);
          }

          if (null == snapshot.data || snapshot.data.length == 0) {
            return Text("No Data Found");
          }

          return CircularProgressIndicator();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: new Container(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          verticalDirection: VerticalDirection.down,
          children: <Widget>[
            form(),
            list(),
          ],
        ),
      ),

    );
  }


/*
@override
Widget build(BuildContext context) {

    // TODO: implement build
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
        timenow();
        },
        backgroundColor: Colors.teal,
        child: Icon(Icons.add),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 12),
        color: Colors.tealAccent,
        child: ListView(
          children: <Widget>[
            ListTile(
              title: Text(
                timestring.toString(),
              ),
            ),
          ],
        )
      ),
    );
  }
}
}*/
}