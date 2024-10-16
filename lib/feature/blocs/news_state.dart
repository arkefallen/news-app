import 'package:news_app/core/domain/entity/news_entity.dart';

abstract class NewsState {}

class NewsInitial extends NewsState {}

class NewsLoading extends NewsState {}

class NewsSuccess extends NewsState {
  final List<NewsEntity> newsArticles;

  NewsSuccess(this.newsArticles);
}

class NewsError extends NewsState {
  final String errorMessage;

  NewsError(this.errorMessage);
}
