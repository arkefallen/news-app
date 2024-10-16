import 'package:news_app/core/data/datasource/remote_news_datasource.dart';
import 'package:news_app/core/data/model/news_model.dart';
import 'package:news_app/core/domain/entity/news_entity.dart';
import 'package:news_app/core/domain/repository/news_repository.dart';

class NewsRepositoryImpl extends NewsRepository {
  final NewsRemoteDataSource _remoteDataSource;

  NewsRepositoryImpl() : _remoteDataSource = NewsRemoteDataSource();

  @override
  Future<List<NewsEntity>> fetchAllNews() async {
    throw UnimplementedError();
  }

  @override
  Future<List<NewsEntity>> fetchTopHeadlines() async {
    try {
      final List<NewsModel> topHeadlineModels =
          await _remoteDataSource.fetchTopHeadlines();
      return topHeadlineModels.map((model) => NewsEntity(
          source: model.source.toEntity(model.source),
          author: model.author,
          title: model.title,
          description: model.description,
          url: model.url,
          urlToImage: model.urlToImage,
          publishedAt: model.publishedAt,
          content: model.content)).toList();
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
