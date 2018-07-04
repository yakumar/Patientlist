import 'dart:async';

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'addPatient.dart';
import 'hospitalModel.dart';
import 'home.dart';
import 'login.dart';
import 'mainScopeModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  SharedPreferences sharepref = await SharedPreferences.getInstance();



  runApp(new MyApp(sharepref: sharepref,));
}

class MyApp extends StatefulWidget {
  SharedPreferences sharepref;
  MyApp({this.sharepref});

  @override
  _MyAppState createState() => new _MyAppState(sharepref: sharepref);
}

class _MyAppState extends State<MyApp>  {

  SharedPreferences sharepref;
  _MyAppState({this.sharepref});


  final MainModel mainModel = MainModel();

  @override
  void initState() {
    // TODO: implement initState

    mainModel.autoAuthenticate();
    print(' main Dart: ${sharepref.get('token')}');


    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
      model: mainModel,
      child: new MaterialApp(
        theme: ThemeData(primarySwatch: Colors.lime),
        //sharepref.get('token') != null ? new Home(mainModel):

        home: sharepref.get('token') != null ? new Home(mainModel, sharepref):new Login(),
      ),
    );
  }
}

