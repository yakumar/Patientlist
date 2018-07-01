import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'addPatient.dart';
import 'hospScoped.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<Hospital>(
      model: new Hospital(),
      child: new MaterialApp(
        theme: ThemeData(primarySwatch: Colors.lime),
        home: new Home(),
      ),
    );
  }
}

class Home extends StatelessWidget {
  GlobalKey<FormState> editPatientKey = new GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Simple Hospital'),
        backgroundColor: Theme.of(context).primaryColor,
        actions: <Widget>[
          new IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).push(
                    new MaterialPageRoute(builder: (BuildContext context) {
                  return new AddPatient();
                }));
              }),
          new IconButton(icon: Icon(Icons.add_box), onPressed: () {}),
        ],
      ),
      body: new ScopedModelDescendant<Hospital>(
        builder: (context, _, model) {
          return new Container(
            margin: EdgeInsets.all(10.0),
            padding: EdgeInsets.all(10.0),
            child: new ListView.builder(
                itemCount: model.patientsList.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading: new CircleAvatar(
                      backgroundColor: Colors.redAccent,
                      child: new IconButton(
                          icon: new Icon(Icons.edit),
                          onPressed: () {
                            _showDialog(context, index, model);
                          }),
                    ),
                    trailing: new IconButton(
                        icon: new Icon(Icons.delete),
                        onPressed: () {
                          model.removeProduct(index);

                          print('${model.patientsList}');
                        }),
                    title: new Text(model.patientsList[index].patientName),
                    subtitle: new Text(model.patientsList[index].diagnosis),
                  );
                }),
          );
        },
      ),
    );
  }

  void _showDialog(BuildContext context, int index, Hospital model) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: new Text('Edit Form'),
            children: <Widget>[
              new Form(
                key: editPatientKey,
                  child: new Column(
                children: <Widget>[
                  new SimpleDialogOption(
                    onPressed: () {},
                    child: new TextFormField(
                      initialValue: model.patientsList[index].patientName,
                      onSaved: (String val){
                        model.patientsList[index].patientName = val;
                      },
                      validator: (String val){
                        if(val.isEmpty){
                          return 'Name should not be empty';
                        }
                      },
                    ),
                  ),
                  new SimpleDialogOption(
                    onPressed: () {},
                    child: new TextFormField(
                      initialValue: model.patientsList[index].diagnosis,
                      onSaved: (String val){
                        model.patientsList[index].diagnosis = val;
                      },
                      validator: (String val){
                        if(val.isEmpty){
                          return 'Diagnosis must not be empty';
                        }
                      },
                    ),
                    
                  ),
                  new SimpleDialogOption(
                    child: new RaisedButton(onPressed: (){_editedPatient(model, context, index);}, child: new Text('Save'),),
                  ),
                ],
              )),
            ],
          );
        });
  }

  void _editedPatient(Hospital model, BuildContext context, int index) {
    FormState form = editPatientKey.currentState;
    if(form.validate()){
      form.save();

      model.editPatient(model.patientsList[index], index);

      Navigator.pop(context);

    }



  }
}
