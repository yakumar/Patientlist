import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'hospScoped.dart';
import 'hospitalModel.dart';

class AddPatient extends StatefulWidget {
  @override
  _AddPatientState createState() => new _AddPatientState();
}

class _AddPatientState extends State<AddPatient> {
  GlobalKey<FormState> patientFormKey = GlobalKey<FormState>();
  Patient patient = new Patient(diagnosis: "", patientName: "");


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Add Patient'),
        ),
        body: ScopedModelDescendant<Hospital>(
          builder: (context, _, model) {
            return new Container(
                alignment: Alignment.center,
                margin: EdgeInsets.all(10.0),
                padding: EdgeInsets.all(10.0),
                child: new Form(
                    key: patientFormKey,
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        new TextFormField(
                          validator: (String val){
                            if (val.isEmpty){
                              return 'Type Name';
                            }
                          },
                          onSaved: (String val){
                            patient.patientName = val;

                          },
                          decoration:
                              new InputDecoration(labelText: 'Type Name'),
                        ),
                        new TextFormField(
                          validator: (String val){
                            if (val.isEmpty){
                              return 'Type Diagnosis';
                            }
                          },
                          onSaved: (String val){
                            patient.diagnosis = val;
                          },
                          decoration:
                              new InputDecoration(labelText: 'Type diagnosis'),
                        ),
                        new Padding(
                          padding: EdgeInsets.all(15.0),
                          child: new RaisedButton(
                            color: Theme.of(context).primaryColor,
                            onPressed: () {_addPatient(model);},
                            child: new Text('Add Patient'),
                          ),
                        )
                      ],
                    )));
          },
        ));
  }

  void _addPatient(Hospital model) {
    FormState form = patientFormKey.currentState;

    if(form.validate()){
      form.save();
      model.addProduct(patient);
      //print(model.patientsList.length.toString());

      form.reset();
      Navigator.pop(context);

    }




  }
}
