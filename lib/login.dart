import 'package:flutter/material.dart';
import 'home.dart';
import 'package:scoped_model/scoped_model.dart';
import 'mainScopeModel.dart';

class Login extends StatelessWidget {
  GlobalKey<FormState> loginFormKey = new GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {
    'email': null,
    'password': null,
  };




  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (context, child, model){
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
                  new TextFormField(
                    validator: (String val){
                      if(val.isEmpty || !val.contains('@')){
                        return 'email should not be empty & Valid email must be typed';
                      }

                    },
                    onSaved: (val){
                      _formData['email'] = val;
                    },
                  ),
                  new Padding(padding: EdgeInsets.all(10.0)),
                  new TextFormField(
                    validator: (String val){
                      if(val.isEmpty){
                        return 'Password must never be empty';
                      }
                    },
                    onSaved: (val){
                      _formData['password'] = val;


                    },

                  ),
                  new Padding(
                    padding: EdgeInsets.all(30.0),
                    child: new RaisedButton(
                      onPressed: () {_loginPressed(model.login, context, model);},
                      child: new Text('Login'),
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

  void _loginPressed(Function login, BuildContext context, MainModel model) {
    FormState form = loginFormKey.currentState;

    if(form.validate()){

      form.save();
      login(_formData['email'], _formData['password']);

      Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (BuildContext context){

        return new Home(model);
      }));
    }


    
  }
}
