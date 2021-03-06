import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'connectedScopeModel.dart';
import 'constants.dart';
import 'user.dart';

class UserModel extends ConnectedScopeModel  {

  SharedPreferences newShared;


  bool isSignUpLoading = false;


  Future<Map<String, dynamic>> login(String email, String password) async {


    isSignUpLoading = true;
    notifyListeners();
    user = User(id: "", email: email);
    final Map<String, dynamic> authyData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

    http.Response signinResp = await http.post(
      'https://www.googleapis.com/identitytoolkit/v3/relyingparty/verifyPassword?key=$FireBaseAPI',
      body: json.encode(authyData),
      headers: {'Content-Type': 'application/json'},
    );

    bool hasError = true;
    final Map<String, dynamic> responseData = json.decode(signinResp.body);
    var message = 'something went wrong';

    if (responseData.containsKey('idToken')) {
      hasError = false;
      message = 'Authentication Succeeded';

      user = User(
          id: responseData['localId'],
          email: email,
          token: responseData['idToken']);

      newShared = await SharedPreferences.getInstance();

      newShared.setString('token', responseData['idToken']);
      newShared.setString('id', responseData['localId']);
      newShared.setString('email', email);

//     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//
//      sharedPreferences.setString('token', 'idToken');
//
//      sharedPreferences.setString('id', responseData['localId']);
//      sharedPreferences.setString('email', email);

      print('login token : ${newShared.get('token')}');



    } else if (responseData['error']['message'] == 'EMAIL_NOT_FOUND') {
      message = 'This email doesnt exists';
    } else if (responseData['error']['message'] == 'INVALID_PASSWORD') {
      message = ' Invalid password';
    }
    isSignUpLoading = false;
    notifyListeners();

    return {'success': !hasError, 'message': message};
  }

  Future<Map<String, dynamic>> signup(String email, String password) async {
    isSignUpLoading = true;
    notifyListeners();
    user = User(id: "", email: email);

    final Map<String, dynamic> authyData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

    http.Response mySignup = await http.post(
      'https://www.googleapis.com/identitytoolkit/v3/relyingparty/signupNewUser?key=${FireBaseAPI}',
      body: json.encode(authyData),
      headers: {'Content-Type': 'application/json'},
    );
    bool hasError = true;
    final Map<String, dynamic> responseData = json.decode(mySignup.body);
    var message = 'something went wrong';

    if (responseData.containsKey('idToken')) {
      hasError = false;
      message = 'Authentication Succeeded';

      user = User(
          id: responseData['localId'],
          email: email,
          token: responseData['idToken']);

      newShared = await SharedPreferences.getInstance();

      newShared.setString('token', responseData['idToken']);
      newShared.setString('id', responseData['localId']);
      newShared.setString('email', email);

//      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//
//
//      sharedPreferences.setString('token', 'idToken');
//
//
//
//      sharedPreferences.setString('id', responseData['localId']);
//      sharedPreferences.setString('email', email);
    } else if (responseData['error']['message'] == 'EMAIL_EXISTS') {
      message = 'This email already exists';
    }
    isSignUpLoading = false;
    notifyListeners();

    return {'success': !hasError, 'message': message};
  }

  notifyListeners();

  void autoAuthenticate() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final String token = sharedPreferences.get('token');

    if(token != null){

      final String email = sharedPreferences.get('email');
      final String id = sharedPreferences.get('id');
      user = new User(id: id, email: email, token: token);
      notifyListeners();

    }



  }



}
