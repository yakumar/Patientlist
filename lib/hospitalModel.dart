

class Doctor {
  String doctorName;
  List<Patient> listOfPatientsTreated;

  Doctor({this.doctorName});
}

class Patient {
  String email;
   String id;

  final String patientName;
  final String diagnosis;
  Patient({this.id, this.patientName, this.diagnosis, this.email});

}

