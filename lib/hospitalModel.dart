

class Doctor {
  String doctorName;
  List<Patient> listOfPatientsTreated;

  Doctor({this.doctorName});
}

class Patient {

  final String patientName;
  final String diagnosis;
  Patient({this.patientName, this.diagnosis});

}

