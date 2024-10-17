import 'package:news_app/core/domain/usecases/fetch_top_headlines_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/feature/blocs/news_event.dart';
import 'package:news_app/feature/blocs/news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final FetchTopHeadlinesUsecase _fetchTopHeadlinesUsecase;

  NewsBloc(this._fetchTopHeadlinesUsecase) : super(NewsInitial()) {
    on<FetchNews>((NewsEvent event, Emitter<NewsState> emit) async {
      if (event is FetchNews) {
        emit(NewsLoading());
        try {
          final newsArticles = await _fetchTopHeadlinesUsecase.call();
          emit(NewsSuccess(newsArticles));
        } catch (e) {
          emit(NewsError(e.toString()));
        }
      }
    });
  }
}
