import 'package:dio/dio.dart';
import 'package:news_app/core/data/model/news_model.dart';
import 'package:news_app/core/data/model/news_response_model.dart';

import '../../constants.dart';

class NewsRemoteDataSource {
  late Dio dio;

  NewsRemoteDataSource() {
    dio = Dio();

    dio.interceptors.add(InterceptorsWrapper(
          onRequest: (options, handler) {
        // Called before request is sent
        print('Request: ${options.method} ${options.path}');
        print('Request Headers: ${options.headers}');
        print('Request Data: ${options.data}');
        return handler.next(options); // Continue to next interceptor or request
      },
      onResponse: (response, handler) {
        // Called when response is received
        print('Response [${response.statusCode}]: ${response.data}');
        return handler.next(response); // Continue to next interceptor or response
      },
      onError: (DioException error, handler) {
        // Called when error happens
        print('Error: ${error.message}');
        if (error.response != null) {
          print('Error Data: ${error.response?.data}');
        }
        return handler.next(error); // Continue to next interceptor or error
      },
  ));
  }

  Future<List<NewsModel>> fetchTopHeadlines() async {
    try {
      Response response = await dio.get(
          'https://newsapi.org/v2/top-headlines?country=us&apiKey=$apiKey&category=general');

      if (response.statusCode == 200) {
        List<NewsModel> topHeadlines =
            NewsResponseModel.fromJson(response.data as Map<String, dynamic>)
                .articles;
        return topHeadlines;
      } else {
        throw Exception(response.statusMessage);
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<NewsModel>> fetchEverythingNews(String category) async {
    try {
      Response response = await dio.get(
          'https://newsapi.org/v2/everything?apiKey=$apiKey&q=$category');

      if (response.statusCode == 200) {
        List<NewsModel> everythingNews =
            NewsResponseModel.fromJson(response.data as Map<String, dynamic>)
                .articles;
        return everythingNews;
      } else {
        throw Exception(response.statusMessage);
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
