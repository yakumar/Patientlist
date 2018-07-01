

class Doctor {
  String doctorName;
  List<Patient> listOfPatientsTreated;

  Doctor({this.doctorName});
}

class Patient {

  String patientName;
  String diagnosis;
  Patient({this.patientName, this.diagnosis});

}

