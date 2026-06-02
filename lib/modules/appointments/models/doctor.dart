ApptDoctor doctorFromJson(Map<String, dynamic> data) => ApptDoctor.fromJson(data);
class ApptDoctor {
    int? count;
    dynamic next;
    dynamic previous;
    List<Result>? results;

    ApptDoctor({
        this.count,
        this.next,
        this.previous,
        this.results,
    });

    factory ApptDoctor.fromJson(Map<String, dynamic> json) => ApptDoctor(
        count: json["count"],
        next: json["next"],
        previous: json["previous"],
        results: json["results"] == null ? [] : List<Result>.from(json["results"]!.map((x) => Result.fromJson(x))),
    );

}

class Result {
    int? id;
    String? fullName;
    String? designation;
    String? email;
    String? phone;
    String? calenderColor;
    String? image;

    Result({
        this.id,
        this.fullName,
        this.designation,
        this.email,
        this.phone,
        this.calenderColor,
        this.image,
    });

    factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        fullName: json["full_name"],
        designation: json["designation"],
        email: json["email"],
        phone: json["phone"],
        calenderColor: json["calender_color"],
        image: json["image"],
    );
}