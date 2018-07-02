
import 'package:scoped_model/scoped_model.dart';
import 'hospitalModel.dart';
import 'user.dart';



class ConnectedScopeModel extends Model {

  User user;

  List<Patient> patientList = [];



  @override
  void notifyListeners() {
    // TODO: implement notifyListeners
    super.notifyListeners();
  }



}



