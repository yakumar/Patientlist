import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:scoped_model/scoped_model.dart';

import 'connectedScopeModel.dart';
import 'user.dart';
import 'constants.dart';

class UserModel extends ConnectedScopeModel {
  bool isSignUpLoading = false;

  Future<Map<String, dynamic>> login(String email, String password) async{
    isSignUpLoading = true;
    notifyListeners();
    user = User(id: "", email: email, password: password);
    final Map<String, dynamic> authyData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

   http.Response signinResp =  await http.post(
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
    user = User(id: "", email: email, password: password);

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
    } else if (responseData['error']['message'] == 'EMAIL_EXISTS') {
      message = 'This email already exists';
    }
    isSignUpLoading = false;
    notifyListeners();

    return {'success': !hasError, 'message': message};
  }

  notifyListeners();


}