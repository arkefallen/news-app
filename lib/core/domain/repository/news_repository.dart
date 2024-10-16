import 'package:news_app/core/domain/entity/news_entity.dart';

abstract class NewsRepository {
  Future<List<NewsEntity>> fetchTopHeadlines();
  Future<List<NewsEntity>> fetchAllNews();
}