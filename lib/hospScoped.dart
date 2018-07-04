import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'connectedScopeModel.dart';
import 'hospitalModel.dart';

class Hospital extends ConnectedScopeModel {
  List<Doctor> doctorsList = [];

  bool isLoading = false;

  List<Patient> get listOfPatients {
    return List.from(patientList);
    notifyListeners();
  }

  List<Doctor> get allDoctorsList {
    return List.from(doctorsList);
  }

  void addProduct(Patient patient) {
    isLoading = true;
    final Map<String, dynamic> newProduct = {
      'name': patient.patientName,
      'diagnosis': patient.diagnosis,
      'email': user.email
    };

    http
        .post(
            'https://test-8e577.firebaseio.com/pateintList.json?auth=${user.token}',
            body: json.encode(newProduct))
        .then((http.Response response) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      //print('${responseData}');

      patient.id = responseData['name'];

      patientList.add(patient);

      isLoading = false;

      notifyListeners();
    });
  }

  void editPatient(Patient patient, int index) {
    final Map<String, dynamic> editedProduct = {
      'name': patient.patientName,
      'diagnosis': patient.diagnosis,
      'email': user.email
    };

    http
        .put(
            'https://test-8e577.firebaseio.com/pateintList/${patient
        .id}.json?auth=${user.token}',
            body: json.encode(editedProduct))
        .then((http.Response response) {
      isLoading = false;
      patientList[index] = patient;
      notifyListeners();
    });
  }

  Future<Null> fetchPatients() async {
    isLoading = true;
    SharedPreferences directToken = await SharedPreferences.getInstance();
    
    String newAuthToken = directToken.get('token') != null ? directToken.get('token'): user.token;
    print('login Fetch ${directToken.get('token')}');
    print('login Fetch ${user.token}');

    var response = await http.get(
        'https://test-8e577.firebaseio.com/pateintList.json?auth=${newAuthToken}');

    final Map<String, dynamic> finalData = json.decode(response.body);

    final List<Patient> fetchedPatientList = [];

    if (finalData == null) {
      isLoading = false;

      notifyListeners();
      return;
    } else {
      finalData.forEach((String patId, dynamic patData) {
        print('from login fetch: ${patData}');
        Patient patient = new Patient(
            id: patId,
            patientName: patData['name'],
            diagnosis: patData['diagnosis'],
            email: patData['email']);
        fetchedPatientList.add(patient);
      });
      patientList = fetchedPatientList;
      isLoading = false;

      notifyListeners();
    }
  }

  void removeProduct(Patient patient, int index) {
    isLoading = true;
    http.delete('https://test-8e577.firebaseio.com/pateintList/${patient
        .id}.json?auth=${user.token}').then((http.Response response) {
      isLoading = false;
      patientList.removeAt(index);
      notifyListeners();
    });
  }

  void addDoctor(Doctor doctor) {
    allDoctorsList.add(doctor);
    notifyListeners();
  }
}
