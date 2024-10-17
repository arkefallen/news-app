abstract class NewsEvent {
  final String newsCategory;

  NewsEvent({required this.newsCategory});
}

class FetchHeadlineNews extends NewsEvent {
  FetchHeadlineNews() : super(newsCategory: "");
}

class FetchEverythingNews extends NewsEvent {
  FetchEverythingNews(String newsCategory) : super(newsCategory: newsCategory);

  List<Object> get props => [newsCategory];
}
