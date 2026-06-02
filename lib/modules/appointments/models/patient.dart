PatientData patientDataFromJson(Map<String, dynamic> data) =>
    PatientData.fromJson(data);

class PatientData {
  bool? status;
  List<Patient>? data;
  dynamic prev;
  String? next;

  PatientData({
    this.status,
    this.data,
    this.prev,
    this.next,
  });

  factory PatientData.fromJson(Map<String, dynamic> json) => PatientData(
        status: json["status"],
        data: json["data"] == null
            ? []
            : List<Patient>.from(json["data"]!.map((x) => Patient.fromJson(x))),
        prev: json["prev"],
        next: json["next"],
      );

  PatientData copyWith({
    bool? status,
    List<Patient>? data,
    dynamic prev,
    String? next,
  }) {
    return PatientData(
      status: status ?? this.status,
      data: data ?? this.data,
      prev: prev ?? this.prev,
      next: next ?? this.next,
    );
  }
}

List<Patient> patientFromJson(List data) =>
    List<Patient>.from(data.map((x) => Patient.fromJson(x)));

class Patient {
  int? id;
  String? patientId;
  String? firstName;
  String? middleName;
  String? lastName;
  String? email;
  String? phone;
  String? secondaryPhone;
  dynamic dateOfBirth;
  int? age;
  String? gender;
  dynamic referredBy;
  String? bloodGroup;
  String? address;
  String? locality;
  String? city;
  dynamic pincode;
  String? image;
  String? notes;
  String? otherHistory;
  bool? followupEnabled;
  DateTime? followupDate;
  bool? birthdayWishesEnabled;
  String? fullName;

  Patient({
    this.id,
    this.patientId,
    this.firstName,
    this.middleName,
    this.lastName,
    this.email,
    this.phone,
    this.secondaryPhone,
    this.dateOfBirth,
    this.age,
    this.gender,
    this.referredBy,
    this.bloodGroup,
    this.address,
    this.locality,
    this.city,
    this.pincode,
    this.image,
    this.notes,
    this.otherHistory,
    this.followupEnabled,
    this.followupDate,
    this.birthdayWishesEnabled,
    this.fullName,
  });

  factory Patient.fromJson(Map<String, dynamic> json) => Patient(
        id: json["id"],
        patientId: json["patient_id"],
        firstName: json["first_name"],
        middleName: json["middle_name"],
        lastName: json["last_name"],
        email: json["email"],
        phone: json["phone"],
        secondaryPhone: json["secondary_phone"],
        dateOfBirth: json["date_of_birth"],
        age: json["age"],
        gender: json["gender"],
        referredBy: json["referred_by"],
        bloodGroup: json["blood_group"],
        address: json["address"],
        locality: json["locality"],
        city: json["city"],
        pincode: json["pincode"],
        image: json["image"],
        notes: json["notes"],
        otherHistory: json["other_history"],
        followupEnabled: json["followup_enabled"],
        followupDate: json["followup_date"] == null
            ? null
            : DateTime.parse(json["followup_date"]),
        birthdayWishesEnabled: json["birthday_wishes_enabled"],
        fullName: json["full_name"],
      );

  Patient copyWith({
    int? id,
    String? patientId,
    String? firstName,
    String? middleName,
    String? lastName,
    String? email,
    String? phone,
    String? secondaryPhone,
    dynamic dateOfBirth,
    int? age,
    String? gender,
    dynamic referredBy,
    String? bloodGroup,
    String? address,
    String? locality,
    String? city,
    dynamic pincode,
    String? image,
    String? notes,
    String? otherHistory,
    bool? followupEnabled,
    DateTime? followupDate,
    bool? birthdayWishesEnabled,
    String? fullName,
  }) {
    return Patient(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      firstName: firstName ?? this.firstName,
      middleName: middleName ?? this.middleName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      secondaryPhone: secondaryPhone ?? this.secondaryPhone,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      referredBy: referredBy ?? this.referredBy,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      address: address ?? this.address,
      locality: locality ?? this.locality,
      city: city ?? this.city,
      pincode: pincode ?? this.pincode,
      image: image ?? this.image,
      notes: notes ?? this.notes,
      otherHistory: otherHistory ?? this.otherHistory,
      followupEnabled: followupEnabled ?? this.followupEnabled,
      followupDate: followupDate ?? this.followupDate,
      birthdayWishesEnabled:
          birthdayWishesEnabled ?? this.birthdayWishesEnabled,
      fullName: fullName ?? this.fullName,
    );
  }
}
