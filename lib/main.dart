import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'addPatient.dart';
import 'hospitalModel.dart';
import 'home.dart';
import 'login.dart';
import 'mainScopeModel.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
      model: new MainModel(),
      child: new MaterialApp(
        theme: ThemeData(primarySwatch: Colors.lime),
        home: new Login(),
      ),
    );
  }
}

