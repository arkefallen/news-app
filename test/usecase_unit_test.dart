import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:news_app/core/domain/entity/news_entity.dart';
import 'package:news_app/core/domain/repository/news_repository.dart';
import 'package:news_app/core/domain/usecases/fetch_all_news_usecase.dart';
import 'package:news_app/core/domain/usecases/fetch_top_headlines_usecase.dart';
import 'package:test/test.dart';

import 'usecase_unit_test.mocks.dart';

@GenerateMocks([NewsRepository])
void main() {
  late FetchAllNewsUsecase everythingNewsUseCase;
  late FetchTopHeadlinesUsecase topHeadlinesUsecase;
  late MockNewsRepository mockNewsRepository;

  setUp(() {
    mockNewsRepository = MockNewsRepository();
    everythingNewsUseCase = FetchAllNewsUsecase(mockNewsRepository);
    topHeadlinesUsecase = FetchTopHeadlinesUsecase(mockNewsRepository);
  });

  const String testCategory = 'technology';

  final List<NewsEntity> testNewsList = List<NewsEntity>.generate(5, (int i) {
    return NewsEntity(
      source: SourceEntity(id: '1', name: 'TechCrunch'),
      author: 'John Doe',
      title: 'Tech News Today',
      description: 'Latest updates in tech world',
      url: 'https://example.com',
      urlToImage: 'https://example.com/image.png',
      publishedAt: DateTime.now(),
      content: 'Full content of the news',
    );
  });

  test(
      'should return list of NewsEntity when the repository successfully fetches Everything News data',
      () async {
    when(mockNewsRepository.fetchAllNews(testCategory))
        .thenAnswer((_) async => testNewsList);

    final result = await everythingNewsUseCase.call(testCategory);

    expect(result.length, testNewsList.length);
    verify(mockNewsRepository.fetchAllNews(testCategory));
  });

  test(
      'should return list of NewsEntity when the repository successfully fetches Top Headline News data',
      () async {
    when(mockNewsRepository.fetchTopHeadlines())
        .thenAnswer((_) async => testNewsList);

    final result = await topHeadlinesUsecase.call();

    expect(result.length, testNewsList.length);
    verify(mockNewsRepository.fetchTopHeadlines());
  });
}
