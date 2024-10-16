class SourceDto {
    dynamic id;
    String name;

    SourceDto({
        required this.id,
        required this.name,
    });

    factory SourceDto.fromJson(Map<String, dynamic> json) => SourceDto(
        id: json["id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
    };
}
