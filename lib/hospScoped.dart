import 'hospitalModel.dart';

import 'package:scoped_model/scoped_model.dart';

class Hospital extends Model{
  List<Doctor> _doctorsList = [];
  List<Patient> _patientList = [];

  List<Patient> get patientsList {
    return List.from(_patientList);
  }

  List<Doctor> get doctorsList {
    return List.from(doctorsList);
  }




  void addProduct(Patient patient){
    _patientList.add(patient);
    notifyListeners();


  }

  void editPatient(Patient patient, int index){
    _patientList[index] = patient;
    notifyListeners();


  }
  void removeProduct(int index){
    _patientList.removeAt(index);
    notifyListeners();

  }

  void addDoctor(Doctor doctor){
    _doctorsList.add(doctor);
    notifyListeners();

  }




}