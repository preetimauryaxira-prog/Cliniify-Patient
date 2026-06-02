

List<ApptProcedure> apptProcedureFromJson(List data) => List<ApptProcedure>.from(data.map((x) => ApptProcedure.fromJson(x)));


class ApptProcedure {
    int? id;
    String? name;
    String? price;

    ApptProcedure({
        this.id,
        this.name,
        this.price,
    });

    factory ApptProcedure.fromJson(Map<String, dynamic> json) => ApptProcedure(
        id: json["id"],
        name: json["name"],
        price: json["price"],
    );

}
