import 'package:flutter/material.dart';
import 'PlayerList.dart';
import 'dart:async';
import 'DB_helper.dart';

class PlayerTab extends StatefulWidget {
  final String title;

  PlayerTab({Key key, this.title}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return PlayerTabState();
  }
}

class PlayerTabState extends State<PlayerTab> {
  //
  Future<List<Player>> players;
  TextEditingController controller = TextEditingController();
  String name;
  int sets = 0;
  int curUserId;

  final formKey = new GlobalKey<FormState>();
  var dbHelper;
  bool isUpdating;

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    isUpdating = false;
    refreshList();
  }

  refreshList() {
    setState(() {
      players = dbHelper.getPlayers();
    });
  }

  clearName() {
    controller.text = '';
  }

  validate() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      if (isUpdating) {
        Player e = Player(curUserId, name, sets);
        dbHelper.update(e);
        setState(() {
          isUpdating = false;
        });
      } else {
        Player e = Player(null, name, sets);
        dbHelper.save(e);
      }
      clearName();
      refreshList();
    }
  }

  form() {
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
              decoration: InputDecoration(labelText: 'Name'),
              validator: (val) => val.length == 0 ? 'Enter Names' : null,
              onSaved: (val) => name = val,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FlatButton(
                  onPressed: validate,
                  child: Text(isUpdating ? 'UPDATE' : 'ADD'),
                ),
                FlatButton(
                  onPressed: () {
                    setState(() {
                      isUpdating = false;
                    });
                    clearName();
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

  SingleChildScrollView dataTable(List<Player> players) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: DataTable(
        columns: [
          DataColumn(
            label: Text('NAME'),
          ),
          DataColumn(
            label: Text('SETS'),
          ),
          DataColumn(
            label: Text('DELETE'),
          )
        ],
        rows: players
            .map(
              (Player players) => DataRow(cells: [
            DataCell(
              Text(players.name),
              onTap: () {
                setState(() {
                  isUpdating = true;
                  curUserId = players.id;
                });
                controller.text = players.name;
              },
            ),
                DataCell(
                  Text(players.sets.toString()),
                  onTap: () {
                    setState(() {
                      isUpdating = true;
                      curUserId = players.id;
                    });
                    controller.text = players.sets.toString();
                  },
                ),
            DataCell(IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                dbHelper.delete(players.id);
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
        future: players,
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
    return new Scaffold(
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
}