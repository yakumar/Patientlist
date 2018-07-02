import 'package:scoped_model/scoped_model.dart';
import 'user.dart';
import 'connectedScopeModel.dart';


class UserModel extends ConnectedScopeModel{


  void login(String email, String password){

    user = User(id: "", email: email, password: password);
    notifyListeners();

  }


}

