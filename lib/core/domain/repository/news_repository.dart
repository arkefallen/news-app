import 'package:news_app/core/data/news_response_dto.dart';

abstract class NewsRepository {
  Future<NewsResponseDto> fetchTopHeadlines();
  Future<NewsResponseDto> fetchAllNews();
}
