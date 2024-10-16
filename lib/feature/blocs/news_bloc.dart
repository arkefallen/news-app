import 'package:news_app/core/data/news_dto.dart';
import 'package:news_app/core/data/news_response_dto.dart';
import 'package:news_app/core/data/repository/news_repository_impl.dart';
import 'package:rxdart/rxdart.dart';

class NewsBloc {
  final _newsRepository = NewsRepositoryImpl();
  final _newsFetcher = PublishSubject<List<NewsDto>>();

  Stream<List<NewsDto>> get allNews => _newsFetcher.stream;

  getTopHeadlinesNews() async {
    NewsResponseDto newsResponse = await _newsRepository.fetchTopHeadlines();
    _newsFetcher.sink.add(newsResponse.articles);
  }

  dispose() {
    _newsFetcher.close();
  }
}

final bloc = NewsBloc();
