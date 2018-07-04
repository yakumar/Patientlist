
import 'dart:async';

import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'hospitalModel.dart';
import 'user.dart';



class ConnectedScopeModel extends Model {

  User user;

  List<Patient> patientList = [];


  Future<SharedPreferences> sharedPrefs = SharedPreferences.getInstance();






  @override
  void notifyListeners() {
    // TODO: implement notifyListeners
    super.notifyListeners();
  }



}



