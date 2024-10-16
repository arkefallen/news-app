import 'news_dto.dart';

class NewsResponseDto {
    String status;
    int totalResults;
    List<NewsDto> articles;

    NewsResponseDto({
        required this.status,
        required this.totalResults,
        required this.articles,
    });

    factory NewsResponseDto.fromJson(Map<String, dynamic> json) => NewsResponseDto(
        status: json["status"],
        totalResults: json["totalResults"],
        articles: List<NewsDto>.from(json["articles"].map((x) => NewsDto.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "totalResults": totalResults,
        "articles": List<dynamic>.from(articles.map((x) => x.toJson())),
    };

}