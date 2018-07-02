import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'addPatient.dart';
import 'hospitalModel.dart';
import 'mainScopeModel.dart';



class Home extends StatelessWidget {
  GlobalKey<FormState> editPatientKey = new GlobalKey<FormState>();
  String diagnosis;
  String ptName;


  @override
  Widget build(BuildContext context) {
    return new ScopedModelDescendant<MainModel>(
        builder: (context, _, model) {

          return new Scaffold(
        appBar: new AppBar(
          title: new Text('Simple Hospital'),
          backgroundColor: Theme.of(context).primaryColor,
          leading: new Text('${model.user.email}'),
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
        body: new Container(
              margin: EdgeInsets.all(10.0),
              padding: EdgeInsets.all(10.0),
              child: new ListView.builder(
                  itemCount: model.listOfPatients.length,
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

                          }),
                      title: new Text(model.listOfPatients[index].patientName),
                      subtitle: new Text(model.listOfPatients[index].diagnosis),
                    );
                  }),
            ),
    );
        });


  }

  void _showDialog(BuildContext context, int index, MainModel model) {
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
                          initialValue: model.listOfPatients[index].patientName,
                          onSaved: (String val) {
                            ptName = val;
                          },
                          validator: (String val) {
                            if (val.isEmpty) {
                              return 'Name should not be empty';
                            }
                          },
                        ),
                      ),
                      new SimpleDialogOption(
                        onPressed: () {},
                        child: new TextFormField(
                          initialValue: model.listOfPatients[index].diagnosis,
                          onSaved: (String val) {
                            diagnosis = val;
                          },
                          validator: (String val) {
                            if (val.isEmpty) {
                              return 'Diagnosis must not be empty';
                            }
                          },
                        ),
                      ),
                      new SimpleDialogOption(
                        child: new RaisedButton(
                          onPressed: () {
                            _editedPatient(model, context, index);
                          },
                          child: new Text('Save'),
                        ),
                      ),
                    ],
                  )),
            ],
          );
        });
  }

  void _editedPatient(MainModel model, BuildContext context, int index) {
    FormState form = editPatientKey.currentState;
    if (form.validate()) {
      form.save();
      Patient patient = new Patient(diagnosis: diagnosis, patientName: ptName);

      model.editPatient(patient, index);



      Navigator.pop(context);
    }
  }
}
