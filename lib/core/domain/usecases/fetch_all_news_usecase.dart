
import 'package:news_app/core/domain/entity/news_entity.dart';
import 'package:news_app/core/domain/repository/news_repository.dart';

class FetchAllNewsUsecase {
  final NewsRepository repository;

  FetchAllNewsUsecase(this.repository);

  Future<List<NewsEntity>> call(String newsCategory) async {
    return repository.fetchAllNews(newsCategory);
  }
}