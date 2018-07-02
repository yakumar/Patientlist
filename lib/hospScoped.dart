import 'hospitalModel.dart';

import 'connectedScopeModel.dart';

class Hospital extends ConnectedScopeModel{



  List<Doctor> doctorsList = [];

  List<Patient> get listOfPatients {
    return List.from(patientList);
    notifyListeners();
  }

  List<Doctor> get allDoctorsList {
    return List.from(doctorsList);
  }




  void addProduct(Patient patient){
    patientList.add(patient);
    notifyListeners();


  }

  void editPatient(Patient patient, int index){
    patientList[index] = patient;
    notifyListeners();


  }
  void removeProduct(int index){
    patientList.removeAt(index);
    notifyListeners();

  }

  void addDoctor(Doctor doctor){
    allDoctorsList.add(doctor);
    notifyListeners();

  }





}