import 'common_issue.dart';
import 'patient.dart';
import 'doctor.dart';

List<Appointment> appointmentFromJson(List data) => List<Appointment>.from(data.map((x) => Appointment.fromJson(x)));


class Appointment {
    int? id;
    Patient? patient;
    ApptDoctor? doctor;
    String? desc;
    dynamic requestedDate;
    dynamic requestedTime;
    DateTime? scheduledDate;
    dynamic waitingTime;
    dynamic engagedTime;
    String? scheduledTime;
    dynamic trackStatus;
    String? duration;
    CommonIssue? issue;
    Procedure? procedure;
    dynamic treatmentItem;
    String? status;
    String? date;
    String? endTime;
    dynamic checkIn;
    dynamic engaged;
    dynamic done;

    Appointment({
        this.id,
        this.patient,
        this.doctor,
        this.desc,
        this.requestedDate,
        this.requestedTime,
        this.scheduledDate,
        this.waitingTime,
        this.engagedTime,
        this.scheduledTime,
        this.trackStatus,
        this.duration,
        this.issue,
        this.procedure,
        this.treatmentItem,
        this.status,
        this.date,
        this.endTime,
        this.checkIn,
        this.engaged,
        this.done,
    });

    factory Appointment.fromJson(Map<String, dynamic> json) => Appointment(
        id: json["id"],
        patient: json["patient"] == null ? null : Patient.fromJson(json["patient"]),
        doctor: json["doctor"] == null ? null : ApptDoctor.fromJson(json["doctor"]),
        desc: json["desc"],
        requestedDate: json["requested_date"],
        requestedTime: json["requested_time"],
        scheduledDate: json["scheduled_date"] == null ? null : DateTime.parse(json["scheduled_date"]),
        waitingTime: json["waiting_time"],
        engagedTime: json["engaged_time"],
        scheduledTime: json["scheduled_time"],
        trackStatus: json["track_status"],
        duration: json["duration"],
        issue: json["issue"] == null ? null : CommonIssue.fromJson(json["issue"]),
        procedure: json["procedure"] == null ? null : Procedure.fromJson(json["procedure"]),
        treatmentItem: json["treatment_item"],
        status: json["status"],
        date: json["date"],
        endTime: json["end_time"],
        checkIn: json["check_in"],
        engaged: json["engaged"],
        done: json["done"],
    );

}


class Procedure {
    int? id;
    String? name;
    String? price;

    Procedure({
        this.id,
        this.name,
        this.price,
    });

    factory Procedure.fromJson(Map<String, dynamic> json) => Procedure(
        id: json["id"],
        name: json["name"],
        price: json["price"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "price": price,
    };
}