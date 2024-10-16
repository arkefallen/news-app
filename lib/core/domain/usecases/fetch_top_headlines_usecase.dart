import 'package:news_app/core/domain/entity/news_entity.dart';
import 'package:news_app/core/domain/repository/news_repository.dart';

class FetchTopHeadlinesUsecase {
  final NewsRepository repository;

  FetchTopHeadlinesUsecase(this.repository);

  Future<List<NewsEntity>> call() async {
    return repository.fetchTopHeadlines();
  }
}
