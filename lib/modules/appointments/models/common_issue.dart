

List<CommonIssue> commonIssueFromJson(List data) => List<CommonIssue>.from(data.map((x) => CommonIssue.fromJson(x)));


class CommonIssue {
    int? id;
    String? issue;

    CommonIssue({
        this.id,
        this.issue,
    });

    factory CommonIssue.fromJson(Map<String, dynamic> json) => CommonIssue(
        id: json["id"],
        issue: json["issue"],
    );
}
