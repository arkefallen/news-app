import 'package:dio/dio.dart';
import 'package:news_app/core/data/model/news_model.dart';
import 'package:news_app/core/data/model/news_response_model.dart';

import '../../constants.dart';

class NewsRemoteDataSource {
  final Dio dio = Dio();

  Future<List<NewsModel>> fetchTopHeadlines() async {
    try {
      Response response = await dio
      .get(
        'https://newsapi.org/v2/top-headlines?country=us&apiKey=$apiKey&category=general'
        );

      if (response.statusCode == 200) {
        List<NewsModel> topHeadlines =
            NewsResponseModel.fromJson(response.data as Map<String, dynamic>).articles;
        return topHeadlines;
      } else {
        throw Exception(response.statusMessage);
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // Future<NewsResponseModel> fetchAllNews() {

  // }
}
