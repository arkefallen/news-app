import 'package:news_app/core/domain/usecases/fetch_all_news_usecase.dart';
import 'package:news_app/core/domain/usecases/fetch_top_headlines_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/feature/blocs/news_event.dart';
import 'package:news_app/feature/blocs/news_state.dart';

class HeadlineNewsBloc extends Bloc<NewsEvent, NewsState> {
  final FetchTopHeadlinesUsecase _fetchTopHeadlinesUsecase;

  HeadlineNewsBloc(this._fetchTopHeadlinesUsecase)
      : super(NewsInitial()) {
    on<FetchHeadlineNews>((_, Emitter<NewsState> emit) async {
      emit(HeadlineNewsLoading());
      try {
        final headlineNews = await _fetchTopHeadlinesUsecase.call();

        emit(HeadlineNewsSuccess(headlineNews));
      } catch (e) {
        emit(HeadlineNewsError(e.toString()));
      }
        });
  }
}

class EverythingNewsBloc extends Bloc<NewsEvent, NewsState> {
  final FetchAllNewsUsecase _fetchAllNewsUsecase;

  EverythingNewsBloc(this._fetchAllNewsUsecase)
      : super(NewsInitial()) {
    on<FetchEverythingNews>((event, Emitter<NewsState> emit) async {
      emit(EverythingNewsLoading());

      try {
        final everythingNews =
            await _fetchAllNewsUsecase.call(event.newsCategory.toString());

        emit(EverythingNewsSuccess(everythingNews));

      } catch (e) {
        emit(EverythingNewsError(e.toString()));
      }
        });
  }
}
