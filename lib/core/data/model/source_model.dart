import 'package:news_app/core/domain/entity/news_entity.dart';

class SourceModel {
  dynamic id;
  String? name;

  SourceModel({
    required this.id,
    required this.name,
  });

  factory SourceModel.fromJson(Map<String, dynamic> json) => SourceModel(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };

  SourceEntity toEntity(SourceModel model) =>
      SourceEntity(id: model.id, name: model.name);
}
