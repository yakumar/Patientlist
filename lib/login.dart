import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';
import 'mainScopeModel.dart';

enum AuthState { Login, Signup }

class Login extends StatefulWidget {
  @override
  _LoginState createState() => new _LoginState();
}

class _LoginState extends State<Login> {
  GlobalKey<FormState> loginFormKey = new GlobalKey<FormState>();

  final Map<String, dynamic> _formData = {
    'email': null,
    'password': null,
  };

  TextEditingController _passController = new TextEditingController();

  AuthState _authState = AuthState.Login;

  @override
  Widget build(BuildContext context) {
    return new ScopedModelDescendant<MainModel>(
      builder: (context, child, model) {
        return new Scaffold(
          appBar: new AppBar(
            title: new Text('Login Form'),
          ),
          body: new Container(
            margin: EdgeInsets.all(18.0),
            padding: EdgeInsets.all(18.0),
            alignment: Alignment.center,
            child: new Form(
              key: loginFormKey,
              child: new Column(
                children: <Widget>[
                  _emailForm(),
                  new Padding(padding: EdgeInsets.all(10.0)),
                  _passForm(),
                  new Padding(padding: EdgeInsets.all(10.0)),
                  _authState == AuthState.Signup
                      ? _passConfirmForm()
                      : Container(),
                  Container(
                    height: 10.0,
                  ),
                  new Padding(
                    padding: EdgeInsets.all(10.0),
                    child: new FlatButton(
                        onPressed: () {
                          setState(() {
                            _authState = _authState == AuthState.Login
                                ? AuthState.Signup
                                : AuthState.Login;
                          });
                        },
                        child: Text(
                          'Switch to ${_authState == AuthState.Login
                              ? 'Signup'
                              : 'Login'}',
                          style: TextStyle(
                              color: Colors.deepOrange,
                              fontWeight: FontWeight.w800,
                              fontStyle: FontStyle.italic),
                        )),
                  ),
                  new Padding(
                    padding: EdgeInsets.all(30.0),
                    child: model.isSignUpLoading ? CircularProgressIndicator(): RaisedButton(
                      onPressed: () {
                        _loginPressed(model.login, context, model, model.signup);
                      },
                      child: new Text('${_authState == AuthState.Login
                          ? 'Login'
                          : 'Signup'}'),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _loginPressed(Function login, BuildContext context, MainModel model,
      Function signup) async {
    FormState form = loginFormKey.currentState;
    SharedPreferences sharepref = await SharedPreferences.getInstance();


    if (form.validate()) {
      form.save();
      if (_authState == AuthState.Login) {

         Map<String, dynamic> signinSuccess = await login(_formData['email'], _formData['password']);
         if (signinSuccess['success']){
           Navigator.of(context).pushReplacement(
               new MaterialPageRoute(builder: (BuildContext context) {
                 return new Home(model, sharepref);

               }));

         }else {
           showDialog(
               context: context,
             builder: (BuildContext context){
                 return AlertDialog(
                   title: new Text('error found'),
                   content: new Text(signinSuccess['message']),
                   actions: <Widget>[
                     FlatButton(
                         onPressed: () {
                           Navigator.pop(context);
                         },
                         child: new Text('close')),
                   ],


                 );
             }
           );
         }

      } else {
        Map<String, dynamic> signupSuccess =
            await signup(_formData['email'], _formData['password']);
        if (signupSuccess['success']) {
          Navigator.of(context).pushReplacement(
              new MaterialPageRoute(builder: (BuildContext context) {
            return new Home(model, sharepref);
          }));
        } else {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: new Text('Error Occurred'),
                  content: new Text(signupSuccess['message']),
                  actions: <Widget>[
                    FlatButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: new Text('close')),
                  ],
                );
              });
        }
      }
    }
  }

  Widget _emailForm() {
    return new TextFormField(
      decoration: new InputDecoration(labelText: 'Type email'),
      keyboardType: TextInputType.emailAddress,
      validator: (String val) {
        if (val.isEmpty || !val.contains('@')) {
          return 'email should not be empty & Valid email must be typed';
        }
      },
      onSaved: (val) {
        _formData['email'] = val;
      },
    );
  }

  Widget _passForm() {
    return new TextFormField(
      decoration: new InputDecoration(labelText: 'Type password'),
      obscureText: true,
      controller: _passController,
      validator: (String val) {
        if (val.isEmpty) {
          return 'Password must never be empty';
        }
      },
      onSaved: (val) {
        _formData['password'] = val;
      },
    );
  }

  Widget _passConfirmForm() {
    return new TextFormField(
      decoration: new InputDecoration(labelText: 'Retype password'),
      obscureText: true,
      validator: (String val) {
        if (val != _passController.text) {
          return 'Passwords must match';
        }
      },
    );
  }
}
