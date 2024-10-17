import 'package:news_app/core/domain/entity/news_entity.dart';

abstract class NewsState {}

class NewsInitial extends NewsState {}

class HeadlineNewsLoading extends NewsState {}

class HeadlineNewsSuccess extends NewsState {
  final List<NewsEntity> newsArticles;

  HeadlineNewsSuccess(this.newsArticles);
}

class HeadlineNewsError extends NewsState {
  final String errorMessage;

  HeadlineNewsError(this.errorMessage);
}

class EverythingNewsLoading extends NewsState {}

class EverythingNewsSuccess extends NewsState {
  final List<NewsEntity> newsArticles;

  EverythingNewsSuccess(this.newsArticles);
}

class EverythingNewsError extends NewsState {
  final String errorMessage;

  EverythingNewsError(this.errorMessage);
}
