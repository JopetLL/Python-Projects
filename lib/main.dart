import 'package:flutter/material.dart';
import 'PlayerTab.dart';
import 'SetTab.dart';
import 'History.dart';
import 'PlayerList.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tabController = new DefaultTabController(
        length: 3,
        child: new Scaffold(
          appBar: new AppBar(
            backgroundColor: Colors.teal,
            title: new Text('Queue'),
            centerTitle: true,
            bottom: new TabBar(
                indicatorColor: Colors.green,
                indicatorWeight: 3.0,
                tabs:[
                  new Tab(text: "Players"),
                  new Tab(text: "Sets"),
                  new Tab(text: "History"),
            ]),
          ),
          body: new TabBarView(
            children: [
              new PlayerTab(),
              new SetTab(),
              new History(),
            ],
          )
        ),
    );
    return new MaterialApp(
      title: "Queue",
      home: tabController
    );
  }
}


